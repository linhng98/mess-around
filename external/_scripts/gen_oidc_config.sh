#!/bin/bash
set -euo pipefail

OUT_DIR="_out"
PRIV_KEY="${OUT_DIR}/service.key"
PUB_KEY="${OUT_DIR}/service.pub"
PKCS_KEY="${OUT_DIR}/service-pkcs8.pub"
JWKS="${OUT_DIR}/keys.json"
OIDC_CONFIG="${OUT_DIR}/discovery.json"
OIDC_DISCOVERY_ENDPOINT="https://${S3_OIDC_BUCKET_NAME}.s3.${AWS_REGION}.amazonaws.com"

mkdir -p ${OUT_DIR}
echo "Copying service account key from ${METAL_CONTROLPLANE_IP}... to ${PRIV_KEY}"
ssh -i "${METAL_SSH_KEY}" \
  -o StrictHostKeyChecking=no \
  "ubuntu@${METAL_CONTROLPLANE_IP}" \
  'sudo cat /var/lib/rancher/rke2/server/tls/service.key' > "${PRIV_KEY}"
chmod 600 ${PRIV_KEY}

echo "Extract the public key and convert to PKCS8..."
ssh-keygen -y -f "${PRIV_KEY}" > "${PUB_KEY}"
ssh-keygen -e -m PKCS8 -f "${PUB_KEY}" > "${PKCS_KEY}"

echo "Generating keys.json..."
go run github.com/aws/amazon-eks-pod-identity-webhook/hack/self-hosted@latest \
  -key "${PKCS_KEY}" | jq '.keys += [.keys[0]] | .keys[1].kid = ""' > ${JWKS}

echo "Generating discovery.json..."
cat > ${OIDC_CONFIG} <<EOF
{
    "issuer": "${OIDC_DISCOVERY_ENDPOINT}",
    "jwks_uri": "${OIDC_DISCOVERY_ENDPOINT}/.well-known/keys.json",
    "authorization_endpoint": "urn:kubernetes:programmatic_authorization",
    "response_types_supported": [
        "id_token"
    ],
    "subject_types_supported": [
        "public"
    ],
    "id_token_signing_alg_values_supported": [
        "RS256"
    ],
    "claims_supported": [
        "sub",
        "iss"
    ]
}
EOF
