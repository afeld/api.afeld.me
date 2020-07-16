# Aidan Feldman API

## To run locally

1. Download and start Docker.
1. Start the server.

   ```bash
   docker-compose up --build
   ```

1. Open http://localhost:4567.

## Checking broken links

```sh
gem install html-proofer
bundle exec middleman build
htmlproofer ./build
```

## See also

https://github.com/danfang/me-api
