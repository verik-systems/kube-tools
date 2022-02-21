FROM alpine:3.15

LABEL maintainer="Nguyen Cat Pham <dtpham258@gmail.com>"

ENV KUBE_VERSION=1.23.4
ENV HELM_VERSION=3.8.0
ENV TARGETOS=linux
ENV TARGETARCH=amd64

WORKDIR /pulumi

RUN apk -U upgrade \
    && apk add --no-cache ca-certificates bash git openssh curl gettext jq bind-tools python3 py3-pip libc6-compat \
    && wget -q https://storage.googleapis.com/kubernetes-release/release/v${KUBE_VERSION}/bin/${TARGETOS}/${TARGETARCH}/kubectl -O /usr/local/bin/kubectl \
    && wget -q https://get.helm.sh/helm-v${HELM_VERSION}-${TARGETOS}-${TARGETARCH}.tar.gz -O - | tar -xzO ${TARGETOS}-${TARGETARCH}/helm > /usr/local/bin/helm \
    && chmod +x /usr/local/bin/helm /usr/local/bin/kubectl \
    && mkdir /config \
    && chmod g+rwx /config /root \
    && pip3 install --upgrade pip \
    && pip3 install --no-cache-dir awscli

RUN curl --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp \
    && mv /tmp/eksctl /usr/local/bin

RUN curl -fsSL https://get.pulumi.com/ | sh

RUN chmod +x /root/.pulumi/bin/*

ENV PATH "/root/.pulumi/bin:${PATH}"

RUN rm -rf /var/cache/apk/*

# Just to make sure its installed alright
# RUN pulumi version
# RUN aws --version
# RUN kubectl version --client
# RUN helm version
# RUN eksctl version

CMD bash