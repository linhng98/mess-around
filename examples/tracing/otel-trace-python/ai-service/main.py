import time
import os
import random
from fastapi import FastAPI, HTTPException
from opentelemetry import trace
from opentelemetry.sdk.trace import TracerProvider
from opentelemetry.sdk.trace.export import (
    BatchSpanProcessor,
    ConsoleSpanExporter,
)
from opentelemetry.sdk.resources import SERVICE_NAME, Resource

from opentelemetry import trace
from opentelemetry.trace import Status, StatusCode
from opentelemetry.exporter.otlp.proto.http.trace_exporter import OTLPSpanExporter
from opentelemetry.sdk.trace import TracerProvider
from opentelemetry.sdk.trace.export import BatchSpanProcessor
from opentelemetry.trace.propagation.tracecontext import TraceContextTextMapPropagator
from opentelemetry.instrumentation.fastapi import FastAPIInstrumentor

# Service name is required for most backends
resource = Resource(attributes={SERVICE_NAME: os.environ["SERVICE_NAME"]})

traceProvider = TracerProvider(resource=resource)
processor = BatchSpanProcessor(OTLPSpanExporter())
# processor = BatchSpanProcessor(ConsoleSpanExporter())
traceProvider.add_span_processor(processor)
trace.set_tracer_provider(traceProvider)

provider = TracerProvider()
provider.add_span_processor(processor)

tracer = trace.get_tracer(os.environ["SERVICE_NAME"])

app = FastAPI()


@app.post("/infer")
def process_file():
    with tracer.start_as_current_span("download_s3") as span:
        # assuming we are downloading file from s3
        time.sleep(random.randint(10, 100) / 1000)

    try:
        process_layout()
        process_ocr()
        process_kv()
    except:
        raise HTTPException(status_code=500, detail="Unknown")

    return {"sucess": 200}


@tracer.start_as_current_span("process_layout")
def process_layout():
    t = random.randint(10, 200)
    current_span = trace.get_current_span()
    time.sleep(t / 1000)

    if t % 3 == 0:
        e = Exception("bad thing happened")
        current_span.set_status(Status(StatusCode.ERROR))
        current_span.record_exception(e)
        print("exception happened in layout")
        raise e


@tracer.start_as_current_span("process_ocr")
def process_ocr():
    time.sleep(random.randint(10, 200) / 1000)


@tracer.start_as_current_span("process_kv")
def process_kv():
    time.sleep(random.randint(10, 200) / 1000)


FastAPIInstrumentor.instrument_app(app)
