# Aidan Feldman API [![CircleCI](https://circleci.com/gh/afeld/api.afeld.me.svg?style=svg)](https://circleci.com/gh/afeld/api.afeld.me)

## To run locally

Requires Ruby 1.9.3+ and Node.js 0.8+.

```bash
gem install bundler
bundle install

npm install -g bower
bower install

bundle exec rackup
open http://localhost:9292
```

## To generate resume

...using [JSONResume](http://jsonresume.org):

```bash
npm install -g resume-cli
ruby jsonresume.rb
open resume.html
```

## To make your own

1. Fork that sh\*t
2. Modify `views/index.json` and `views/index.html.erb`
3. Push up to Heroku, or wherever

See also: https://github.com/danfang/me-api
