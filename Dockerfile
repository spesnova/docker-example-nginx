FROM buildpack-deps:jessie
MAINTAINER Seigo Uchida <spesnova@gmail.com> (@spesnova)

ENV NGINX_VERSION 1.6.2

# Install dependency packages
RUN apt-get update && \
    apt-get install -y \
      binutils-doc \
      bison \
      flex \
      gettext \
      libpcre3 \
      libpcre3-dev \
      libssl-dev \
      libperl-dev && \
    rm -rf /var/lib/apt/lists/*

# Fetch and unarchive nginx source
RUN curl -L http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz > /tmp/nginx-${NGINX_VERSION}.tar.gz && \
    cd /tmp && \
    tar zxf nginx-${NGINX_VERSION}.tar.gz

# Compile nginx
RUN cd /tmp/nginx-${NGINX_VERSION} && \
    ./configure \
      --prefix=/opt/nginx \
      --conf-path=/etc/nginx/nginx.conf \
      --sbin-path=/opt/nginx/sbin/nginx \
      --with-http_stub_status_module \
      --with-http_perl_module \
      --with-pcre && \
    make && \
    make install && \
    rm -rf /tmp/*

RUN mkdir -p /etc/nginx && \
    mkdir -p /var/run && \
    mkdir -p /etc/nginx/conf.d && \
    mkdir -p /var/www/nginx/cache && \
    mkdir -p /var/www/nginx/images && \
    mkdir -p /var/www/nginx/tmp

# Add config files
COPY files/nginx.conf   /etc/nginx/nginx.conf
COPY files/mime.types   /etc/nginx/mime.types

EXPOSE 80 8090

CMD ["/opt/nginx/sbin/nginx"]
