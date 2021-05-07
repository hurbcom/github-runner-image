FROM ubuntu:20.04
ARG VERSION=2.278.0
RUN export DEBIAN_FRONTEND=noninteractive && apt update && apt -y install supervisor curl jq wget liblttng-ust0 libkrb5-3 zlib1g libssl1.1 libicu66 apt-transport-https && apt clean
RUN wget https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb; \
    dpkg -i packages-microsoft-prod.deb;\
    apt update && apt install -y dotnet-runtime-5.0
RUN adduser -q --disabled-password --gecos "" --home /actions-runner github-runner 
WORKDIR /actions-runner
USER github-runner
RUN  curl -O -L https://github.com/actions/runner/releases/download/v${VERSION}/actions-runner-linux-x64-${VERSION}.tar.gz ;\
    tar xzf actions-runner-linux-x64-${VERSION}.tar.gz
ARG TOKEN 
ARG URL
ADD supervisord.conf /etc/supervisor/
COPY start.sh /actions-runner/
COPY get_token.sh /actions-runner/
ENTRYPOINT ["./start.sh"]
CMD ["/usr/bin/supervisord"]