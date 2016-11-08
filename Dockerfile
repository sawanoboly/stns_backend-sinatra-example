FROM lambdalinux/baseimage-amzn:2016.09-000

RUN yum update -y && \
  yum install -y sudo openssh-server nscd tmux vim ruby23 && \
  curl -fsSL https://repo.stns.jp/scripts/yum-repo.sh | sh && \
  yum install -y stns libnss-stns libpam-stns && \
  yum clean all -y

ADD conf/nsswitch.conf /etc/nsswitch.conf
ADD conf/nscd.conf /etc/nscd.conf
ADD conf/stns.conf /etc/stns/stns.conf
ADD conf/libnss_stns.conf /etc/stns/libnss_stns.conf
RUN echo 'AuthorizedKeysCommand /usr/lib/stns/stns-key-wrapper' >> /etc/ssh/sshd_config
RUN echo 'AuthorizedKeysCommandUser root' >> /etc/ssh/sshd_config

ADD . /code

WORKDIR /code
ENV BUNDLE_PATH vender_docker/bundle
RUN gem install bundler --no-ri --no-rdoc
RUN bundle

ADD entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
