FROM ruby:3

# throw errors if Gemfile has been modified since Gemfile.lock
RUN bundle config --global frozen 1
ENV LANG C.UTF-8

# install Node.js for ExecJS
# https://github.com/nodesource/distributions/#installation-instructions
RUN curl -fsSL https://deb.nodesource.com/setup_16.x | bash -
RUN apt-get install -y nodejs

WORKDIR /usr/src/app

COPY Gemfile Gemfile.lock ./
RUN bundle install

CMD bundle exec rerun \
  --dir helpers \
  -- middleman --bind-address=0.0.0.0
