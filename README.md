# Dockerized Xubuntu web desktop

This image provides a dockerized web desktop based on Xubuntu 18.04 LTS (Xfce4). Thanks to noVNC you can access a full flegged linux desktop directly over your web browser.

## Features

 * Full flegged Xubuntu 18.04 desktop.
 * NoVNC with auto connect.
 * Password-less sudo.
 * OpenSSH client.

## Usage

To run this desktop enter:
```
docker run -p 80:8083 rootlogin/web-desktop
```

Then surf to [localhost](http://localhost) and have fun.

### Persistent user data

To persist user data you have to mount the volume /home/user:
```
docker run -p 80:8083 -v user_data:/home/user rootlogin/web-desktop
```

## Customizing

To customize your desktop create a child image, as example:

```
FROM rootlogin/web-desktop

RUN apt-get update \
  && DEBIAN_FRONTEND=noninteractive apt-get -y install \
  chromium-browser \
  chromium-browser-l10n
```

## Security notes

This image has no kind of encryption or authentication enabled. You should use a SSL frontend proxy with some kind of authentication (basic auth as example) like Nginx when you deploy this image in the public internet.
