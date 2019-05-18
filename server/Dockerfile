FROM ruby:2.5.3-alpine

ENV APP_ROOT /usr/src/w-board
ENV TZ Asia/Tokyo

WORKDIR $APP_ROOT

RUN apk add --no-cache --no-progress mysql-client libxml2-dev libxslt-dev tzdata sqlite-dev

ADD Gemfile $APP_ROOT
ADD Gemfile.lock $APP_ROOT

RUN \
  apk add --no-cache --virtual .ruby-builddeps build-base mysql-dev && \
  echo 'gem: --no-document' >> ~/.gemrc && \
  cp ~/.gemrc /etc/gemrc && \
  chmod uog+r /etc/gemrc && \
  gem install bundler && \
  bundle config --global build.nokogiri --use-system-libraries && \
  bundle config --global jobs 4 && \
  bundle install && \
  apk del --purge .ruby-builddeps && \
  apk add --no-cache mariadb-connector-c && \
  mkdir logs tmp

ADD . $APP_ROOT

EXPOSE 3000
CMD ["rails", "server", "-b", "0.0.0.0"]
