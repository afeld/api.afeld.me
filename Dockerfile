FROM ruby:3

RUN gem update --system && \
  gem update bundler
# throw errors if Gemfile has been modified since Gemfile.lock
RUN bundle config --global frozen 1
ENV LANG C.UTF-8

# install Node.js for ExecJS
# https://github.com/nodesource/distributions#installation-instructions
RUN apt-get update -y && \
  apt-get install -y ca-certificates curl gnupg
RUN mkdir -p /etc/apt/keyrings && \
  curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg
ENV NODE_MAJOR=20
RUN echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_$NODE_MAJOR.x nodistro main" | \
  tee /etc/apt/sources.list.d/nodesource.list
RUN apt-get update -y && \
  apt-get install -y nodejs

WORKDIR /usr/src/app

COPY Gemfile Gemfile.lock ./
RUN bundle install

CMD bundle exec rerun \
  --dir helpers \
  -- middleman --bind-address=0.0.0.0
