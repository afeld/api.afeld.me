# Aidan Feldman API

## To run locally

1. Download and start Docker.
1. Start the server.

   ```bash
   docker compose up --build
   ```

1. Open http://localhost:4567.

## Checking broken links

```sh
gem install html-proofer
bundle exec middleman build
htmlproofer ./build
```

## Checking tenses

1. Install Python 3
1. [Install spacy](https://spacy.io/usage)
1. Run

   ```sh
   python tense.py
   ```

## Customizing for specific roles

1. Create a new branch locally from [the `compact` branch](https://github.com/afeld/api.afeld.me/compare/main...compact)
1. Get the latest updates:

   ```sh
   git fetch
   git rebase origin/main
   ```

1. Add `"skip": true` to roles that should be hidden
1. Open Chrome to preview
1. Print to PDF

## See also

https://github.com/danfang/me-api
