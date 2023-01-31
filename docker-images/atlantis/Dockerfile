FROM ghcr.io/runatlantis/atlantis:v0.22.3-debian

RUN tgv="0.38.0" && \
    curl -L "https://github.com/gruntwork-io/terragrunt/releases/download/v${tgv}/terragrunt_linux_amd64" --output "terragrunt${tgv}" && \
    chmod +x "terragrunt${tgv}" && \
    mv "terragrunt${tgv}" /usr/local/bin


RUN tgv="0.40.0" && \
    curl -L "https://github.com/gruntwork-io/terragrunt/releases/download/v${tgv}/terragrunt_linux_amd64" --output "terragrunt${tgv}" && \
    chmod +x "terragrunt${tgv}" && \
    mv "terragrunt${tgv}" /usr/local/bin
