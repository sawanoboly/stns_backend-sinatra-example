FROM ruby:2.3

RUN apt-get update && \
  apt-get install --no-install-recommends -y sudo openssh-server nscd tmux vim rsyslog && \
  curl -fsSL https://repo.stns.jp/scripts/apt-repo.sh | sh && \
  apt-get update && \
  apt-get install -y stns libnss-stns libpam-stns && \
  rm -rf /var/lib/apt/lists/*

RUN curl -fsSL https://github.com/just-containers/s6-overlay/releases/download/v1.11.0.1/s6-overlay-amd64.tar.gz | tar xvz -C /
RUN mkdir -p /var/run/sshd
RUN install -d -m 0700 /root/bin && cp -p /usr/local/bin/stns-key-wrapper /root/bin/

ADD conf/nsswitch.conf /etc/nsswitch.conf
ADD conf/nscd.conf /etc/nscd.conf
ADD conf/stns.conf /etc/stns/stns.conf
ADD conf/libnss_stns.conf /etc/stns/libnss_stns.conf
RUN echo 'AuthorizedKeysCommand /root/bin/stns-key-wrapper' >> /etc/ssh/sshd_config
RUN echo 'AuthorizedKeysCommandUser root' >> /etc/ssh/sshd_config


ADD . /code

WORKDIR /code
ENV BUNDLE_PATH vender_docker/bundle
RUN bundle

ADD entrypoint.sh /entrypoint.sh

## WIP..
# ENV AWS_ACCESS_KEY AAAAAAAAAAAAAAAAA
# ENV AWS_SECRET_ACCESS_KEY XXXXXXXXXXXXXXXX
# ENV AWS_REGION ap-northeast-1
# ENV DYNAMODB_TABLENAME myusers

ENTRYPOINT ["/entrypoint.sh"]
