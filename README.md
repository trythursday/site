# Thursday website

The source for [trythursday.org](https://trythursday.org). Part of
[Thursday](https://github.com/trythursday/thursday).

## Build it

Needs `git`, [just](https://github.com/casey/just), and bun.

```sh
just site
```

That writes `dist/`: the landing page, `AGENTS.md`, and a copy of each
experiment, cloned at build time and served under `/experiments/`:

- [Next Steps](https://github.com/trythursday/next-steps) at
  `/experiments/next-steps/`
- [Thing Refiner](https://github.com/trythursday/thing-refiner) at
  `/experiments/thing-refiner/`

Pushing to `main` deploys. `.github/workflows/pages.yml` runs `just site` and
publishes `dist/` to GitHub Pages, which serves it at `trythursday.org`.

## Layout

- `site/HOME.md` — the landing page, rendered to `dist/index.html` by `scripts/home.ts`
- `site/blog/01.md` — blog draft, not built
- `site/AGENTS.md` — copied to `dist/` as-is
- `scripts/home.ts` — the only build script; bun-only

## License

MIT. See [Thursday](https://github.com/trythursday/thursday) for the license.
