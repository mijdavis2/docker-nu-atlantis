FROM runatlantis/atlantis:v0.15.0

LABEL authors="Michael J. Davis"
LABEL description="Combines the benefits of atlantis, \
terragrunt, and tfmask in an opinionated terraform \
ci/cd docker image with refreshingly clean output."

RUN apk update && apk upgrade

ENV INSTALL_DIR=/opt/nu-atlantis
ENV WORKDIR=/home/atlantis
ARG TERRAFORM_VERSION=0.13.5
ARG TERRAGRUNT_VERSION=0.25.5
ARG TFMASK_VERSION=0.7.0
ARG TFENV_VERSION=2.0.0
ARG TGENV_VERSION=0.1.0

WORKDIR ${WORKDIR}

# Remove preinstalled atlantis terraform binary to ensure no conflicts
RUN rm -rf /usr/local/bin/terraform

RUN git clone -b v${TFENV_VERSION} https://github.com/tfutils/tfenv.git ${WORKDIR}/.tfenv && \
    chown -R atlantis:atlantis ${WORKDIR}/.tfenv && \
    ln -s ${WORKDIR}/.tfenv/bin/* /usr/local/bin && \
    tfenv install ${TERRAFORM_VERSION} && \
    tfenv use ${TERRAFORM_VERSION}

RUN git clone -b ${TGENV_VERSION} https://github.com/taosmountain/tgenv.git ${WORKDIR}/.tgenv && \
    chown -R atlantis:atlantis ${WORKDIR}/.tgenv && \
    ln -s ${WORKDIR}/.tgenv/bin/* /usr/local/bin && \
    tgenv install ${TERRAGRUNT_VERSION} && \
    tgenv use ${TERRAGRUNT_VERSION}

RUN mkdir -p ${INSTALL_DIR} && \
    curl -s -Lo tfmask https://github.com/cloudposse/tfmask/releases/download/${TFMASK_VERSION}/tfmask_linux_amd64 && \
    chmod +x tfmask && \
    mv tfmask ${INSTALL_DIR}/ && \
    chown atlantis:atlantis ${INSTALL_DIR}/tfmask

ENV INSTALL_DIR=/opt/nu-atlantis \
    PATH=${PATH}:${INSTALL_DIR} \
    ATLANTIS_HIDE_PREV_PLAN_COMMENTS=true \
    ATLANTIS_WRITE_GIT_CREDS=true \
    ATLANTIS_AUTOMERGE=true \
    TFMASK_VALUES_REGEX="(?i)^.*[^a-zA-Z](oauth|secret|token|password|key|result).*$" \
    TF_CLI_ARGS="-no-color"

COPY files/ ${WORKDIR}
RUN chown -R atlantis:atlantis ${WORKDIR}
USER atlantis
CMD ["atlantis", "server", "--repo-config", "repos.yaml"]
