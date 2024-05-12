import time
import os
import nats
import json
import random
from fastapi import FastAPI
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


@app.get("/")
async def create_job_controller():
    with tracer.start_as_current_span("upload_s3") as span:
        # assuming we are uploading to s3
        # response = s3_client.upload_file(file_name, bucket, object_name)
        time.sleep(random.randint(20, 50) / 1000)

    await insert_new_job_to_db()
    await publish_task_nats()

    return {"sucess": 200}


@tracer.start_as_current_span("insert_new_job_to_db")
async def insert_new_job_to_db():
    time.sleep(0.02)


@tracer.start_as_current_span("publish_task_nats")
async def publish_task_nats():
    nc = await nats.connect(os.environ["NATS_URL"])
    js = nc.jetstream()
    await js.add_stream(
        name=os.environ["NATS_STREAM"], subjects=[os.environ["NATS_STREAM_SUBJECT"]]
    )
    msg = {"content": "okla"}
    headers = {}
    TraceContextTextMapPropagator().inject(headers)
    print(headers)
    await js.publish(
        subject=os.environ["NATS_STREAM_SUBJECT"],
        payload=str.encode(json.dumps(msg)),
        headers=headers,
    )
    await nc.flush()
    await nc.close()


FastAPIInstrumentor.instrument_app(app)
