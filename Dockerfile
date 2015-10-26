FROM gliderlabs/alpine:3.2

MAINTAINER Allan Costa <allaninocencio@yahoo.com.br>

RUN apk --update add nginx curl bash \
    && mkdir -p /tmp/nginx/client-body \
    && rm -rf /var/cache/apk/*

# Install confd
RUN curl -L https://github.com/kelseyhightower/confd/releases/download/v0.7.1/confd-0.7.1-linux-amd64 -o confd
RUN chmod +x confd
RUN cp confd /usr/local/bin/confd

# Add files
ADD nginx.toml /etc/confd/conf.d/nginx.toml
ADD nginx.conf.tmpl /etc/confd/templates/nginx.conf.tmpl
ADD confd-watch.sh /usr/local/bin/confd-watch

# Give correct rights to NGINX folder
RUN chown -R nginx:nginx /var/lib/nginx/

ENTRYPOINT ["/usr/local/bin/confd-watch"]
