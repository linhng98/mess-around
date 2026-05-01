#!/bin/bash
set -euo pipefail

aws s3 cp _out/keys.json s3://${S3_OIDC_BUCKET_NAME}/.well-known/keys.json
aws s3 cp _out/discovery.json s3://${S3_OIDC_BUCKET_NAME}/.well-known/openid-configuration
