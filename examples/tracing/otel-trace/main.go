package main

import (
	"context"
	"fmt"
	"log"
	"math/rand"
	"sync"
	"time"

	"go.opentelemetry.io/otel"
	"go.opentelemetry.io/otel/attribute"
	"go.opentelemetry.io/otel/codes"

	"go.opentelemetry.io/otel/exporters/otlp/otlptrace"
	"go.opentelemetry.io/otel/exporters/otlp/otlptrace/otlptracehttp"
	"go.opentelemetry.io/otel/propagation"
	"go.opentelemetry.io/otel/sdk/resource"
	sdktrace "go.opentelemetry.io/otel/sdk/trace"
	semconv "go.opentelemetry.io/otel/semconv/v1.17.0"
	"go.opentelemetry.io/otel/trace"
)

type msg struct {
	Num        int
	CtxCarrier propagation.MapCarrier
}

const (
	OTEL_ENDPOINT = "otel-http.homelab.linhng98.com"
	SERVICE_NAME  = "mess-around"
	NUM_TRY       = 10
	TIMEOUT       = 10 * time.Second
)

func init() {
	rand.Seed(time.Now().UnixNano())
}

func main() {
	exp, err := newExporter()
	if err != nil {
		log.Fatalf("create exporter failed\n")
	}

	res := newResource()
	tp := newProvider(res, exp)
	defer tp.Shutdown(context.Background())
	otel.SetTracerProvider(tp)

	ctx, cancelFunc := context.WithTimeout(context.Background(), TIMEOUT)
	defer cancelFunc()
	chanX := make(chan msg)
	chanY := make(chan msg)
	chanZ := make(chan msg)
	var wg sync.WaitGroup
	wg.Add(3)

	go serveService(ctx, &wg, chanX, chanY, "SERVICE_A")
	go serveService(ctx, &wg, chanY, chanZ, "SERVICE_B")
	go serveService(ctx, &wg, chanZ, nil, "SERVICE_C")

	for i := 0; i < NUM_TRY; i++ {
		m := msg{Num: i + 1, CtxCarrier: nil}
		chanX <- m
	}

	wg.Wait()
}

func serveService(ctx context.Context, wg *sync.WaitGroup, in chan msg, out chan msg, name string) {
	defer wg.Done()

	count := 0
	for {
		if count == NUM_TRY {
			return
		}

		select {
		case msg := <-in:
			count++
			log.Printf("%s: received package %d\n", name, count)

			var traceCtx context.Context
			var span trace.Span
			propgator := propagation.NewCompositeTextMapPropagator(propagation.TraceContext{}, propagation.Baggage{})

			if msg.CtxCarrier == nil {
				traceCtx, span = otel.Tracer(name).Start(ctx, name)
			} else {
				parentCtx := propgator.Extract(ctx, msg.CtxCarrier)
				traceCtx, span = otel.Tracer(name).Start(parentCtx, name)
				log.Printf("%s: extracted context from package %d\n", name, count)
			}
			carrier := propagation.MapCarrier{}
			propgator.Inject(traceCtx, carrier)
			msg.CtxCarrier = carrier

			sleepTime := 20 + rand.Intn(30)
			time.Sleep(time.Duration(sleepTime) * time.Millisecond)
			if out != nil {
				out <- msg
			}

			if out == nil && msg.Num%3 == 0 {
				unknowErr := fmt.Errorf("unknow error")
				span.RecordError(unknowErr)
				span.SetStatus(codes.Error, unknowErr.Error())
				log.Printf("%s: encounter error %s from package %d", name, unknowErr.Error(), count)
			}
			span.End()
		case <-ctx.Done():
			return
		}
	}
}

func newResource() *resource.Resource {
	r, _ := resource.Merge(
		resource.Default(),
		resource.NewWithAttributes(
			semconv.SchemaURL,
			semconv.ServiceNameKey.String(SERVICE_NAME),
			semconv.ServiceVersionKey.String("v0.1.0"),
			attribute.String("environment", "homelab"),
		),
	)
	return r
}

func newExporter() (*otlptrace.Exporter, error) {
	return otlptracehttp.New(context.Background(), otlptracehttp.WithEndpoint(OTEL_ENDPOINT))
}

func newProvider(res *resource.Resource, exp *otlptrace.Exporter) *sdktrace.TracerProvider {
	return sdktrace.NewTracerProvider(sdktrace.WithBatcher(exp), sdktrace.WithResource(res))
}
