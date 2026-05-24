# Aidan Feldman API

This is a static site built with [Middleman](https://middlemanapp.com/).

## To run locally

1. Install Ruby.
1. Install dependencies.

   ```bash
   bundle install
   ```

1. Start the server.

   ```bash
   bundle exec middleman
   ```

1. Open http://localhost:4567.

## Checking broken links

```sh
bundle exec middleman build
htmlproofer ./build
```

## Checking tenses

1. [Install uv.](https://docs.astral.sh/uv/getting-started/installation/)
1. Install dependencies.

   ```sh
   uv sync
   ```

1. Install the [spaCy model](https://spacy.io/usage/models/).

   ```sh
   uv run python -m spacy download en_core_web_sm
   ```

1. Run

   ```sh
   uv run pytest
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
