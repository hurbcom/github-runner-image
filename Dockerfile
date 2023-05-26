FROM ubuntu:20.04
ARG VERSION=2.304.0
ENV GITHUB_ACCESS_TOKEN=
ENV LABELS=
ENV HOSTNAME=
ENV ORG=

COPY requirements.apt /tmp
RUN export DEBIAN_FRONTEND=noninteractive && \
    apt update && \
    apt -f -y install `cat /tmp/requirements.apt` && \
    rm /tmp/requirements.apt

RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - && \
        apt-get install -y nodejs && \
        npm -g install yarn

RUN wget https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb; \
    dpkg -i packages-microsoft-prod.deb;\
    apt update && apt install -y dotnet-runtime-5.0

RUN adduser -q --disabled-password --gecos "" --home /actions-runner github-runner ; \
    usermod -aG sudo github-runner && echo "github-runner ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

WORKDIR /actions-runner
USER github-runner
RUN  curl -O -L https://github.com/actions/runner/releases/download/v${VERSION}/actions-runner-linux-x64-${VERSION}.tar.gz ; \
    tar xzf actions-runner-linux-x64-${VERSION}.tar.gz; \
    rm actions-runner-linux-x64-${VERSION}.tar.gz
#ADD supervisord.conf /etc/supervisor/
COPY --chown=github-runner start.sh /actions-runner/
COPY --chown=github-runner remove.sh /actions-runner/

ENTRYPOINT ["./start.sh"]

