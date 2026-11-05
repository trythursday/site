# The Thursday website. `just site` builds dist/, `just publish` deploys it.

dist := "dist"
_landing := "site"
_next_steps := "https://github.com/trythursday/next-steps"
_thing_refiner := "https://github.com/trythursday/thing-refiner"
_domain := "trythursday.org"

# List the available recipes.
default:
    @just --list

# Build the static site into dist/.
site:
    #!/usr/bin/env bash
    set -euo pipefail

    rm -rf {{dist}}
    mkdir -p {{dist}}/experiments/next-steps {{dist}}/experiments/thing-refiner

    cp {{_landing}}/AGENTS.md {{dist}}/AGENTS.md
    bun run scripts/home.ts

    tmp=$(mktemp -d)
    trap 'rm -rf "$tmp"' EXIT
    git clone --quiet --depth 1 {{_next_steps}} "$tmp/next-steps"
    rm -rf "$tmp/next-steps/.git"
    cp -R "$tmp/next-steps/." {{dist}}/experiments/next-steps/

    git clone --quiet --depth 1 {{_thing_refiner}} "$tmp/thing-refiner"
    rm -rf "$tmp/thing-refiner/.git"
    cp -R "$tmp/thing-refiner/." {{dist}}/experiments/thing-refiner/

    touch {{dist}}/.nojekyll

    # GitHub Pages reads this to serve the custom domain.
    printf '%s\n' {{_domain}} > {{dist}}/CNAME
