import asyncio
import os
import nats
import requests
import json
from nats.aio.msg import Msg
from opentelemetry import trace
from opentelemetry.sdk.trace import TracerProvider
from opentelemetry.sdk.trace.export import (
    BatchSpanProcessor,
    ConsoleSpanExporter,
)
from opentelemetry.sdk.resources import SERVICE_NAME, Resource

from opentelemetry import trace
from opentelemetry.exporter.otlp.proto.http.trace_exporter import OTLPSpanExporter
from opentelemetry.sdk.trace import TracerProvider
from opentelemetry.sdk.trace.export import BatchSpanProcessor
from opentelemetry.trace.propagation.tracecontext import TraceContextTextMapPropagator
from opentelemetry.propagators.jaeger import JaegerPropagator

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

import asyncio
import nats
from nats.errors import TimeoutError


async def main():
    nc = await nats.connect(os.environ["NATS_URL"])

    # Create JetStream context.
    js = nc.jetstream()

    # Create pull based consumer on 'foo'.
    psub = await js.pull_subscribe(
        subject=os.environ["NATS_STREAM_SUBJECT"], durable="consumer_group"
    )

    # Fetch and ack messagess from consumer.
    while True:
        try:
            msgs = await psub.fetch(1)
            for msg in msgs:
                await msg.ack()
                trace_ctx = TraceContextTextMapPropagator().extract(carrier=msg.headers)
                with tracer.start_as_current_span(
                    "send_request_to_ai", context=trace_ctx
                ):
                    send_request(json.loads(msg.data))

        except TimeoutError:
            continue


def send_request(body):
    headers = {}
    TraceContextTextMapPropagator().inject(headers)
    JaegerPropagator().inject(headers)
    print(headers)
    requests.post(os.environ["AI_SERVICE_URL"], json=body, headers=headers)


if __name__ == "__main__":
    asyncio.run(main())
