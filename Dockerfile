FROM ubuntu:20.04
ARG VERSION=2.278.0
ENTRYPOINT ["./start.sh"]
CMD ["/usr/bin/supervisord"]

RUN export DEBIAN_FRONTEND=noninteractive && \
    apt update && \
    apt -y install \
        supervisor \
        curl \
        jq \
        wget \
        liblttng-ust0 \
        libkrb5-3 \
        zlib1g \
        libssl1.1 \
        libicu66 \
        build-essential \
        sudo \
        apt-transport-https && \
    apt clean

RUN wget https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb; \
    dpkg -i packages-microsoft-prod.deb;\
    apt update && apt install -y dotnet-runtime-5.0 git
RUN adduser -q --disabled-password --gecos "" --home /actions-runner github-runner 
WORKDIR /actions-runner
USER github-runner
RUN  curl -O -L https://github.com/actions/runner/releases/download/v${VERSION}/actions-runner-linux-x64-${VERSION}.tar.gz ;\
    tar xzf actions-runner-linux-x64-${VERSION}.tar.gz
ADD supervisord.conf /etc/supervisor/
COPY --chown=github-runner start.sh /actions-runner/
COPY --chown=github-runner remove.sh /actions-runner/

