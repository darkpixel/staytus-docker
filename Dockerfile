FROM ruby:alpine
LABEL org.opencontainers.image.source https://github.com/darkpixel/staytus-docker

RUN apk add --update --no-cache libc-dev make g++ nodejs tzdata curl mariadb-dev gettext ruby-bundler libxml2-dev patch
RUN mkdir  /app
WORKDIR /app

RUN curl https://codeload.github.com/adamcooke/staytus/zip/master | unzip -d /tmp -; mv /tmp/staytus-master/* /app/ && rm -rf /tmp/staytus-master/
RUN gem install bundler:1.17.2
RUN bundle install --deployment --without development:test

COPY docker-start-v2.sh /app/docker-start-v2.sh
COPY config/database.example.yml /app/config/database.example.yml
COPY config/environment.example.yml /app/config/environment.example.yml
COPY 0001-Disable-asset-fingerprinting.patch /app/0001-Disable-asset-fingerprinting.patch

RUN patch -p0 0001-Disable-asset-fingerprinting.patch

ENV RAILS_ENV=production

ENTRYPOINT /app/docker-start-v2.sh
EXPOSE 5000
