# Aidan Feldman API [![CircleCI](https://circleci.com/gh/afeld/api.afeld.me.svg?style=svg)](https://circleci.com/gh/afeld/api.afeld.me)

## To run locally

Requires Ruby 1.9.3+ and Node.js 0.8+.

```bash
gem install bundler
bundle install

bundle exec rackup
open http://localhost:9292
```

## To make your own

Note that the experience is meant to include all the information needed for a [federal resume](https://join.tts.gsa.gov/resume/).

1. Fork that sh\*t
2. Modify `views/index.json` and `views/index.html.erb`
3. Push up to Heroku, or wherever

See also: https://github.com/danfang/me-api
