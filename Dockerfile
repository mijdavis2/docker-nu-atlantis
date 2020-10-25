FROM runatlantis/atlantis:v0.15.0

LABEL authors="Michael J. Davis"
LABEL description="Combines the benefits of atlantis, \
terragrunt, and tfmask in an opinionated terraform \
ci/cd docker image with refreshingly clean output."

RUN apk update && apk upgrade

ENV INSTALL_DIR=/usr/local/bin

ARG TERRAFORM_VERSION=0.13.5
ARG TERRAGRUNT_VERSION=v0.25.5
ARG TFMASK_VERSION=0.7.0

RUN rm -rf ${INSTALL_DIR}/terraform && \
    curl -s -Lo terraform.zip https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    unzip terraform.zip && \
    rm -rf terraform.zip && \
    chmod +x terraform && \
    mv terraform ${INSTALL_DIR}/ && \
    chown atlantis:atlantis ${INSTALL_DIR}/terraform

RUN curl -s -Lo terragrunt https://github.com/gruntwork-io/terragrunt/releases/download/${TERRAGRUNT_VERSION}/terragrunt_linux_amd64 && \
    chmod +x terragrunt && \
    mv terragrunt ${INSTALL_DIR}/ && \
    chown atlantis:atlantis ${INSTALL_DIR}/terragrunt

RUN curl -s -Lo tfmask https://github.com/cloudposse/tfmask/releases/download/${TFMASK_VERSION}/tfmask_linux_amd64 && \
    chmod +x tfmask && \
    mv tfmask ${INSTALL_DIR}/ && \
    chown atlantis:atlantis ${INSTALL_DIR}/tfmask

ENV ATLANTIS_HIDE_PREV_PLAN_COMMENTS=true \
    ATLANTIS_WRITE_GIT_CREDS=true \
    ATLANTIS_AUTOMERGE=true \
    TF_CLI_ARGS="-no-color" \
    WORKDIR=/home/atlantis

RUN mkdir -p ${WORKDIR}
WORKDIR ${WORKDIR}

COPY files/ ${WORKDIR}
CMD ["atlantis", "server", "--repo-config", "repos.yaml"]
