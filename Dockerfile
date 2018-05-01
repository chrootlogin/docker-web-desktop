FROM ubuntu:18.04

ARG TINI_VERSION=v0.18.0
ARG BUILD_DATE
ARG VCS_REF

LABEL maintainer="Simon Erhardt <hello@rootlogin.ch>" \
  org.label-schema.name="Web Desktop" \
  org.label-schema.description="Dockerized web desktop based on Xubuntu 18.04." \
  org.label-schema.build-date=$BUILD_DATE \
  org.label-schema.vcs-ref=$VCS_REF \
  org.label-schema.vcs-url="https://github.com/chrootLogin/docker-web-desktop" \
  org.label-schema.schema-version="1.0"

ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /usr/local/bin/tini

ENV LC_ALL=en_US.UTF-8 \
  LANG=en_US.UTF-8 \
  LANGUAGE=en_US.UTF-8 \
  TZ=Europe/Zurich

RUN set -ex \
  # Install packages
  && apt-get update \
  && DEBIAN_FRONTEND=noninteractive apt-get -y dist-upgrade \
  && DEBIAN_FRONTEND=noninteractive apt-get -y install \
  git \
  locales \
  openssh-client \
  python-pip \
  sudo \
  supervisor \
  tigervnc-standalone-server \
  util-linux \
  xubuntu-desktop \
  && apt-get clean \
  # Install noVNC
  && wget -q https://github.com/novnc/noVNC/archive/v1.0.0.zip -O /tmp/novnc.zip \
  && mkdir -p /tmp/novnc /opt/novnc \
  && unzip /tmp/novnc.zip -d /tmp/novnc \
  && mv /tmp/novnc/*/* /opt/novnc/ \
  && rm -rf /tmp/novnc.zip /tmp/novnc \
  # Create User
  && useradd -m -s /bin/bash user \
  # Enable locales
  && sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen \
  && dpkg-reconfigure --frontend=noninteractive locales \
  && locale-gen en_US.UTF-8 \
  && /usr/sbin/update-locale LANG=en_US.UTF-8 \
  # Install pip packages
  && pip install websockify \
  # Make tini executable
  && chmod +x /usr/local/bin/tini \
  # Remove incompatible packages
  && DEBIAN_FRONTEND=noninteractive apt-get -y remove \
  blueman

COPY root /

EXPOSE 8083

VOLUME /home/user

ENTRYPOINT ["/usr/local/bin/tini", "--"]
CMD ["/docker-run.sh"]
