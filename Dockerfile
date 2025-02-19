FROM ubuntu:latest

ARG TARGETARCH

# Set non-interactive mode for apt
#ENV DEBIAN_FRONTEND=noninteractive

# Update & install dependencies
RUN apt-get update && \
    apt-get install -y curl wget git unzip tar jq python3 python3-pip lsb-release pipx && \
    rm -rf /var/lib/apt/lists/*

# Install pre-commit
ENV PATH=/root/.local/bin:$PATH
#RUN apt update && apt install python3-pre-commit
RUN pipx install pre-commit checkov

# Install Terraform and required HashiCorp tools
RUN apt-get update && \
    apt-get install -y gnupg software-properties-common && \
    wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor > /usr/share/keyrings/hashicorp-archive-keyring.gpg && \
    echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg]	https://apt.releases.hashicorp.com $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/hashicorp.list && \
    apt-get update && apt-get -y install terraform

# Install terraform-docs
RUN DOWNLOAD_URL=$(curl -s https://api.github.com/repos/terraform-docs/terraform-docs/releases/latest | \
    jq -r ".assets[] | select(.name | test(\"-linux-${TARGETARCH}.tar.gz\")) | .browser_download_url") && \
    curl -sSL $DOWNLOAD_URL -o ./terraform-docs.tar.gz && \
    tar -xzf terraform-docs.tar.gz && \
    chmod +x terraform-docs && \
    mv terraform-docs /usr/local/bin/ && \
    rm terraform-docs.tar.gz

# Install tflint
RUN curl -s https://raw.githubusercontent.com/terraform-linters/tflint/master/install_linux.sh | bash

# Install tfsec
RUN curl -s https://raw.githubusercontent.com/aquasecurity/tfsec/master/scripts/install_linux.sh | bash

# Install trivy
RUN wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | gpg --dearmor > /usr/share/keyrings/trivy.gpg \
    && echo "deb [signed-by=/usr/share/keyrings/trivy.gpg] https://aquasecurity.github.io/trivy-repo/deb generic main" | tee -a /etc/apt/sources.list.d/trivy.list \
    && apt-get update && apt-get install trivy

# Install terrascan
#RUN curl -L "$(curl -s https://api.github.com/repos/tenable/terrascan/releases/latest | grep -o -E "https://.+?_Linux_x86_64.tar.gz")" > terrascan.tar.gz \
#    && tar -xf terrascan.tar.gz terrascan && rm terrascan.tar.gz \
#    && install terrascan /usr/local/bin && rm terrascan
RUN ARCH=$(echo ${TARGETARCH} | sed -e 's/amd64/x86_64/') && \
    DOWNLOAD_URL=$(curl -s https://api.github.com/repos/tenable/terrascan/releases/latest | \
    jq -r ".assets[] | select(.name | test(\"_Linux_${ARCH}.tar.gz\")) | .browser_download_url") && \
    curl -sSL $DOWNLOAD_URL -o terrascan.tar.gz && \
    tar -xf terrascan.tar.gz terrascan && \
    install terrascan /usr/local/bin && \
    rm terrascan terrascan.tar.gz


# Install infracost
RUN curl -fsSL https://raw.githubusercontent.com/infracost/infracost/master/scripts/install.sh | sh

# Install tfupdate
#RUN curl -sSLo tfupdate.tar.gz https://github.com/minamijoyo/tfupdate/releases/download/v0.8.5/tfupdate_0.8.5_linux_amd64.tar.gz \
#    && tar -xzf tfupdate.tar.gz \
#    && chmod +x tfupdate \
#    && mv tfupdate /usr/local/bin/ \
#    && rm tfupdate.tar.gz
RUN DOWNLOAD_URL=$(curl -s https://api.github.com/repos/minamijoyo/tfupdate/releases/latest | \
	jq -r ".assets[] | select(.name | test(\"_linux_${TARGETARCH}.tar.gz\")) | .browser_download_url") && \
    curl -sSL $DOWNLOAD_URL -o tfupdate.tar.gz && \
    tar -xzf tfupdate.tar.gz && \
    chmod +x tfupdate && \
    mv tfupdate /usr/local/bin/ && \
    rm tfupdate.tar.gz

# Install hcledit
#RUN curl -sSLo hcledit.tar.gz https://github.com/minamijoyo/hcledit/releases/download/v0.2.17/hcledit_0.2.17_linux_amd64.tar.gz \
#    && tar -xzf hcledit.tar.gz \
#    && chmod +x hcledit \
#    && mv hcledit /usr/local/bin/ \
#    && rm hcledit.tar.gz
RUN DOWNLOAD_URL=$(curl -s https://api.github.com/repos/minamijoyo/hcledit/releases/latest | \
    jq -r ".assets[] | select(.name | test(\"_linux_${TARGETARCH}.tar.gz\")) | .browser_download_url") && \
    curl -sSL $DOWNLOAD_URL -o hcledit.tar.gz && \
    tar -xzf hcledit.tar.gz && \
    chmod +x hcledit && \
    mv hcledit /usr/local/bin/ && \
    rm hcledit.tar.gz

WORKDIR /workspace

CMD ["bash"]
