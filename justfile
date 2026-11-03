# The Thursday website. `just site` builds dist/, `just publish` deploys it.

dist := "dist"
_landing := "site"
_next_steps := "https://github.com/trythursday/next-steps"
_domain := "trythursday.org"

# List the available recipes.
default:
    @just --list

# Build the static site into dist/.
site:
    #!/usr/bin/env bash
    set -euo pipefail

    rm -rf {{dist}}
    mkdir -p {{dist}}/experiments/next-steps

    cp {{_landing}}/AGENTS.md {{dist}}/AGENTS.md
    bun run scripts/home.ts

    tmp=$(mktemp -d)
    trap 'rm -rf "$tmp"' EXIT
    git clone --quiet --depth 1 {{_next_steps}} "$tmp/next-steps"
    rm -rf "$tmp/next-steps/.git"
    cp -R "$tmp/next-steps/." {{dist}}/experiments/next-steps/

    touch {{dist}}/.nojekyll

    # GitHub Pages reads this to serve the custom domain.
    printf '%s\n' {{_domain}} > {{dist}}/CNAME

# Publish dist/ to the `site` branch, which GitHub Pages serves.
publish: site
    #!/usr/bin/env bash
    set -euo pipefail
    root=$(git rev-parse --show-toplevel)
    branch=site
    base=$(mktemp -d)
    wt="$base/$branch"
    trap 'git -C "$root" worktree remove --force "$wt" >/dev/null 2>&1 || true; rm -rf "$base"' EXIT

    git -C "$root" worktree prune
    # GitHub commits to this branch directly (e.g. when the custom domain is
    # set), so track the remote and rebuild on top of whatever is there.
    git -C "$root" fetch --quiet origin "$branch" || true
    if git -C "$root" show-ref --verify --quiet "refs/remotes/origin/$branch"; then
        git -C "$root" branch -f "$branch" "origin/$branch"
    fi
    if git -C "$root" show-ref --verify --quiet "refs/heads/$branch"; then
        git -C "$root" worktree add --force "$wt" "$branch"
    else
        git -C "$root" worktree add --force --detach "$wt" HEAD
        git -C "$wt" checkout --orphan "$branch"
    fi

    find "$wt" -mindepth 1 -maxdepth 1 ! -name .git -exec rm -rf {} +
    cp -R "{{dist}}/." "$wt/"

    git -C "$wt" add -A
    git -C "$wt" commit -m "site: rebuild from $(git -C "$root" rev-parse --short HEAD)"
    git -C "$wt" push origin "$branch"
