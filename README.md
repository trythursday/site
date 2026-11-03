# Thursday website

The source for [trythursday.org](https://trythursday.org). Part of
[Thursday](https://github.com/trythursday/thursday).

## Build it

Needs `git`, [just](https://github.com/casey/just), and bun.

```sh
just site
```

That writes `dist/`: the landing page, `AGENTS.md`, and a copy of
[Next Steps](https://github.com/trythursday/next-steps), which is cloned at build
time and served under `/experiments/next-steps/`.

Then:

```sh
just publish
```

builds `dist/` and pushes it to the `site` branch, which GitHub Pages serves at
`trythursday.org`. The custom domain is written as `dist/CNAME`.

## Layout

- `site/HOME.md` — the landing page, rendered to `dist/index.html` by `scripts/home.ts`
- `site/blog/01.md` — blog draft, not built
- `site/AGENTS.md` — copied to `dist/` as-is
- `scripts/home.ts` — the only build script; bun-only

## License

MIT. See [Thursday](https://github.com/trythursday/thursday) for the license.
