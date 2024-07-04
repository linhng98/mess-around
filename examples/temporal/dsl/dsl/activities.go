package dsl

import (
	"context"
	"fmt"
	"math/rand"
	"time"

	"go.temporal.io/sdk/activity"
)

type FlaxActivities struct {
}

func (a *FlaxActivities) PreProcessing(ctx context.Context, input []string) (string, error) {
	name := activity.GetInfo(ctx).ActivityType.Name
	fmt.Printf("Run %s with input %v \n", name, input)

	// Assume calling http service, or publish then polling result from message queue
	time.Sleep(time.Duration(rand.Intn(200)) * time.Millisecond)

	return "Result_" + name, nil
}

func (a *FlaxActivities) Layout(ctx context.Context, input []string) (string, error) {
	name := activity.GetInfo(ctx).ActivityType.Name
	fmt.Printf("Run %s with input %v \n", name, input)

	// Assume calling http service, or publish then polling result from message queue
	time.Sleep(time.Duration(rand.Intn(200)) * time.Millisecond)

	return "Result_" + name, nil
}

func (a *FlaxActivities) Ocr(ctx context.Context, input []string) (string, error) {
	name := activity.GetInfo(ctx).ActivityType.Name
	fmt.Printf("Run %s with input %v \n", name, input)

	// Assume calling http service, or publish then polling result from message queue
	time.Sleep(time.Duration(rand.Intn(200)) * time.Millisecond)

	return "Result_" + name, nil
}

func (a *FlaxActivities) Kv(ctx context.Context, input []string) (string, error) {
	name := activity.GetInfo(ctx).ActivityType.Name
	fmt.Printf("Run %s with input %v \n", name, input)

	// Assume calling http service, or publish then polling result from message queue
	time.Sleep(time.Duration(rand.Intn(200)) * time.Millisecond)

	return "Result_" + name, nil
}

func (a *FlaxActivities) PostProcessing(ctx context.Context, input []string) (string, error) {
	name := activity.GetInfo(ctx).ActivityType.Name
	fmt.Printf("Run %s with input %v \n", name, input)

	// Assume calling http service, or publish then polling result from message queue
	time.Sleep(time.Duration(rand.Intn(200)) * time.Millisecond)

	return "Result_" + name, nil
}
