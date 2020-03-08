FROM ruby:2.7

# throw errors if Gemfile has been modified since Gemfile.lock
RUN bundle config --global frozen 1
ENV LANG C.UTF-8

WORKDIR /usr/src/app

COPY Gemfile Gemfile.lock ./
RUN bundle install

CMD bundle exec rackup --host 0.0.0.0
