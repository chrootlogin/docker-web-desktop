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
  && apt-get update \
  # Install locales
  && DEBIAN_FRONTEND=noninteractive apt-get -y install \
  locales \
  && sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen \
  && sed -i -e 's/# de_CH.UTF-8 UTF-8/de_CH.UTF-8 UTF-8/' /etc/locale.gen \
  && dpkg-reconfigure --frontend=noninteractive locales \
  && locale-gen en_US.UTF-8 \
  && /usr/sbin/update-locale LANG=en_US.UTF-8 \
  # Upgrade all packages
  && DEBIAN_FRONTEND=noninteractive apt-get -y dist-upgrade \
  # Install packages
  && DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends -y install \
  atril \
  avahi-autoipd \
  avahi-daemon \
  bc \
  ca-certificates \
  chromium-browser \
  chromium-browser-l10n \
  cups \
  cups-bsd \
  cups-client \
  cups-filters\
  desktop-file-utils \
  engrampa \
  fonts-dejavu-core \
  fonts-freefont-ttf \
  gigolo \
  git \
  gnome-font-viewer \
  greybird-gtk-theme \
  gtk2-engines-pixbuf \
  gucharmap \
  gvfs-backends \
  gvfs-fuse \
  hplip \
  indicator-messages \
  libnotify-bin \
  libnss-mdns \
  libpam-gnome-keyring \
  libreoffice-calc \
  libreoffice-gnome \
  libreoffice-style-elementary \
  libreoffice-writer \
  libxfce4ui-utils \
  mate-calc \
  menulibre \
  mousepad \
  net-tools \
  openssh-client \
  orage \
  pidgin \
  pidgin-otr \
  pinentry-gtk2 \
  policykit-desktop-privileges \
  printer-driver-brlaser \
  printer-driver-c2esp \
  printer-driver-foo2zjs \
  printer-driver-m2300w \
  printer-driver-min12xxw \
  printer-driver-ptouch \
  printer-driver-pxljr \
  printer-driver-sag-gdi \
  printer-driver-splix \
  python-pip \
  python-setuptools \
  ristretto \
  sudo \
  supervisor \
  system-config-printer \
  thunar \
  thunar-archive-plugin \
  thunar-media-tags-plugin \
  thunar-volman \
  thunderbird \
  tigervnc-standalone-server \
  transmission-gtk \
  unzip \
  util-linux \
  xdg-user-dirs \
  xdg-user-dirs-gtk \
  xfce4-appfinder \
  xfce4-indicator-plugin \
  xfce4-mailwatch-plugin \
  xfce4-notes-plugin \
  xfce4-notifyd \
  xfce4-panel \
  xfce4-places-plugin \
  xfce4-session \
  xfce4-settings \
  xfce4-statusnotifier-plugin \
  xfce4-taskmanager \
  xfce4-terminal \
  xfce4-whiskermenu-plugin \
  xfwm4 \
  zip \
  && apt-get clean \
  # Install noVNC
  && wget -q https://github.com/novnc/noVNC/archive/v1.0.0.zip -O /tmp/novnc.zip \
  && mkdir -p /tmp/novnc /opt/novnc \
  && unzip /tmp/novnc.zip -d /tmp/novnc \
  && mv /tmp/novnc/*/* /opt/novnc/ \
  && rm -rf /tmp/novnc.zip /tmp/novnc \
  # Create User
  && useradd -m -s /bin/bash user \
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
