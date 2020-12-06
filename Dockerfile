FROM ruby:alpine
LABEL org.opencontainers.image.source https://github.com/darkpixel/staytus-docker

RUN apk add --update --no-cache libc-dev make g++ nodejs tzdata curl mariadb-dev gettext ruby-bundler libxml2-dev patch git
RUN mkdir  /app
WORKDIR /app

RUN git clone https://github.com/adamcooke/staytus.git /app
RUN git checkout 180291688b53ec331041f6a0472a21df5a7ba7b5
RUN gem install bundler:1.17.2
RUN bundle install --deployment --without development:test

COPY docker-start-v2.sh /app/docker-start-v2.sh
COPY config/database.example.yml /app/config/database.example.yml
COPY config/environment.example.yml /app/config/environment.example.yml
COPY 0001-Disable-asset-fingerprinting.patch /app/0001-Disable-asset-fingerprinting.patch

RUN patch -p0 0001-Disable-asset-fingerprinting.patch

ENV RAILS_ENV=production
ENV RAILS_MAX_THREADS=1
ENV WEB_CONCURRENCY=1

ENTRYPOINT /app/docker-start-v2.sh
EXPOSE 5000
