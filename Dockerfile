FROM ubuntu:20.04
ARG VERSION=2.278.0
ARG VE_UBUNTU_TAG=20211219.1
ARG PACKAGES=all

ENTRYPOINT ["./start.sh"]
CMD ["/usr/bin/supervisord"]

COPY requirements.apt /tmp
RUN export DEBIAN_FRONTEND=noninteractive && \
    apt update && \
    apt -f -y install `cat /tmp/requirements.apt` && \
    rm /tmp/requirements.apt

# RUN wget https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb; \
#     dpkg -i packages-microsoft-prod.deb;\
#     apt update && apt install -y dotnet-runtime-5.0

RUN adduser -q --disabled-password --gecos "" --home /actions-runner github-runner ; \
    usermod -aG sudo github-runner
# New user can sudo without password, for setup-php@v2
RUN echo 'github-runner ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers.d/runner
#RUN echo 'github-runner ALL=(ALL) NOPASSWD:/usr/bin/rm, /usr/bin/ln, /usr/bin/sed, /usr/bin/find, /usr/bin/tee, /usr/bin/apt-cache, /usr/bin/chmod, /usr/bin/update-alternatives, /usr/bin/mkdir, /usr/bin/cp, /usr/bin/apt-fast' >> /etc/sudoers


WORKDIR /actions-runner
USER github-runner
RUN  curl -O -L https://github.com/actions/runner/releases/download/v${VERSION}/actions-runner-linux-x64-${VERSION}.tar.gz ;\
    tar xzf actions-runner-linux-x64-${VERSION}.tar.gz ;\
    rm actions-runner-linux-x64-${VERSION}.tar.gz

ADD supervisord.conf /etc/supervisor/
COPY --chown=github-runner start.sh /actions-runner/
COPY --chown=github-runner remove.sh /actions-runner/

# Install github environment for ubuntu-20.04
ADD scripts/fake_invoke_tests.sh /tmp/invoke_tests.sh
ADD scripts/setup-ve-ubuntu20.sh /tmp/ubuntu20.sh

RUN /tmp/ubuntu20.sh "${PACKAGES}"

