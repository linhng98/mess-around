FROM summerwind/actions-runner:ubuntu-22.04

USER root

RUN apt update -y

RUN apt install -y git unzip curl gcc make vim golang-go pre-commit

RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    ./aws/install && \
    rm -rf awscliv2.zip

RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" && \
    chmod +x kubectl && \
    mv kubectl /usr/bin/kubectl

RUN tgv="0.40.0" && \
    curl -L "https://github.com/gruntwork-io/terragrunt/releases/download/v${tgv}/terragrunt_linux_amd64" --output "terragrunt${tgv}" && \
    chmod +x "terragrunt${tgv}" && \
    mv "terragrunt${tgv}" /usr/local/bin/terragrunt

RUN tfv="1.3.7" && \
    curl -L https://releases.hashicorp.com/terraform/${tfv}/terraform_${tfv}_linux_amd64.zip --output terraform.zip && \
    unzip terraform.zip -d terraform_${tfv} && \
    mv terraform_${tfv}/terraform /usr/local/bin/terraform && \
    rm -rf terraform_${tfv} terraform.zip

USER runner

RUN curl https://sh.rustup.rs -sSf | sh -s -- -y
RUN export PATH=$PATH:$HOME/.cargo/bin

RUN v="3.41.1" && \
    curl -LO https://github.com/trufflesecurity/trufflehog/releases/download/v${v}/trufflehog_${v}_linux_amd64.tar.gz --output trufflehog.tar.gz && \
    tar -zxvf trufflehog.tar.gz && \
    mv trufflehog /usr/local/bin/trufflehog
