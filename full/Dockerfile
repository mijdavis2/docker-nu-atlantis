FROM runatlantis/atlantis:v0.15.0 as builder

LABEL authors="Michael J. Davis"
LABEL description="Combines the benefits of atlantis, \
terragrunt, and tfmask in an opinionated terraform \
ci/cd docker image with refreshingly clean output."

RUN apk update && apk upgrade

# Install credstash dependencies
RUN apk add    \
    build-base \
    gcc        \
    libffi-dev \
    musl-dev   \
    openssl-dev

# Install credstash and ldap3 for local-exec
RUN apk add 'python3<3.9' python3-dev cmd:pip3
USER atlantis
ENV PATH=${PATH}:/home/atlantis/.local/bin
RUN pip3 install --upgrade pip
RUN pip3 install --user credstash ldap3

# Cleanup
USER root
RUN apk del     \
    build-base  \
    gcc         \
    libffi-dev  \
    musl-dev    \
    openssl-dev \
    python3-dev

ENV INSTALL_DIR=/opt/nu-atlantis
ENV WORKDIR=/home/atlantis
ENV PATH=${PATH}:${INSTALL_DIR}
ENV PATH=${PATH}:${INSTALL_DIR}/bin
ARG TERRAFORM_VERSION=0.13.5
ARG TERRAGRUNT_VERSION=0.25.5
ARG TFMASK_VERSION=0.7.0
ARG TFENV_VERSION=2.0.0
ARG TGENV_VERSION=0.1.0
ARG CREDSTASH_PROVIDER_VERSION=0.5.0

# Remove atlantis default terraform binary to ensure no conflicts
RUN rm -rf /usr/local/bin/terraform

WORKDIR ${WORKDIR}
RUN git clone -b v${TFENV_VERSION} https://github.com/tfutils/tfenv.git ${WORKDIR}/.tfenv
RUN ln -s ${WORKDIR}/.tfenv/bin/* /usr/local/bin
RUN tfenv install ${TERRAFORM_VERSION}; tfenv use ${TERRAFORM_VERSION}

RUN git clone -b ${TGENV_VERSION} https://github.com/taosmountain/tgenv.git ${WORKDIR}/.tgenv
RUN ln -s ${WORKDIR}/.tgenv/bin/* /usr/local/bin
RUN tgenv install ${TERRAGRUNT_VERSION}; tgenv use ${TERRAGRUNT_VERSION}

RUN mkdir -p ${INSTALL_DIR}
RUN curl -s -Lo terraform-provider-credstash_v${CREDSTASH_PROVIDER_VERSION} https://github.com/sspinc/terraform-provider-credstash/releases/download/v${CREDSTASH_PROVIDER_VERSION}/terraform-provider-credstash_linux_amd64 && \
    chmod +x terraform-provider-credstash_v${CREDSTASH_PROVIDER_VERSION} && \
    mkdir -p /home/atlantis/.terraform.d/plugins/ && \
    mv terraform-provider-credstash_v${CREDSTASH_PROVIDER_VERSION} /home/atlantis/.terraform.d/plugins/ && \
    chown atlantis:atlantis /home/atlantis/.terraform.d/plugins/terraform-provider-credstash_v${CREDSTASH_PROVIDER_VERSION}

RUN curl -s -Lo tfmask https://github.com/cloudposse/tfmask/releases/download/${TFMASK_VERSION}/tfmask_linux_amd64 && \
    chmod +x tfmask && \
    mv tfmask ${INSTALL_DIR}/ && \
    chown atlantis:atlantis ${INSTALL_DIR}/tfmask

# Multistage use here squeezes about 20% out of the original build image
FROM runatlantis/atlantis:v0.15.0

ENV INSTALL_DIR=/opt/nu-atlantis \
    TF_PLUGIN_DIR=/home/atlantis/.terraform.d/plugins \
    WORKDIR=/home/atlantis
ARG TERRAFORM_VERSION=0.13.5
ARG TERRAGRUNT_VERSION=0.25.5
ARG CREDSTASH_PROVIDER_VERSION=v0.5.0

RUN apk update && apk upgrade
RUN apk add 'python3<3.9' cmd:pip3 && \
    mkdir -p ${INSTALL_DIR} && \
    mkdir -p ${TF_PLUGIN_DIR} && \
    rm -rf /usr/local/bin/terraform

COPY --from=builder ${INSTALL_DIR} ${INSTALL_DIR}
COPY --from=builder ${WORKDIR}/.tfenv ${WORKDIR}/.tfenv
COPY --from=builder ${WORKDIR}/.tgenv ${WORKDIR}/.tgenv
COPY --from=builder /home/atlantis/.local /home/atlantis/.local
COPY --from=builder ${TF_PLUGIN_DIR}/terraform-provider-credstash_${CREDSTASH_PROVIDER_VERSION} ${TF_PLUGIN_DIR}/terraform-provider-credstash_${CREDSTASH_PROVIDER_VERSION}

RUN ln -s ${WORKDIR}/.tfenv/bin/* /usr/local/bin; tfenv use ${TERRAFORM_VERSION}
RUN ln -s ${WORKDIR}/.tgenv/bin/* /usr/local/bin; tgenv use ${TERRAGRUNT_VERSION}

USER atlantis
ENV PATH=${PATH}:${INSTALL_DIR}:/home/atlantis/.local/bin \
    ATLANTIS_HIDE_PREV_PLAN_COMMENTS=true \
    ATLANTIS_WRITE_GIT_CREDS=true \
    ATLANTIS_AUTOMERGE=true \
    TFMASK_VALUES_REGEX="(?i)^.*[^a-zA-Z](oauth|secret|token|password|key|result).*$" \
    TF_CLI_ARGS="-no-color"

WORKDIR ${WORKDIR}

COPY files/ ${WORKDIR}
CMD ["atlantis", "server", "--repo-config", "repos.yaml"]
