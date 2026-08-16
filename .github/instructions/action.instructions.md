---
name: metablock-web action instructions
applyTo: "**"
description: Development guidance for the metablock web deployment github action - layout, the metablock client it wraps, inputs and CI.
---

# metablock-web

A github action that ships a static bundle to an **html block** on
[metablock](https://api.metablock.io/v1/docs) cloud — it deploys site content,
not backend blocks, and block configuration belongs to the sibling
`metablock-ingress` action. There is no application code in this repo: the
action is a thin docker wrapper around the `metablock` CLI, so almost every
change is to `Dockerfile`, `action.yml` or the workflows.

The repository was renamed from `metablock-action` to `metablock-web`; old
references to the previous name are stale, not a second repo.

## Layout

| Path | Purpose |
|---|---|
| `Dockerfile` | installs the pinned `metablock[cli]` release the action runs |
| `action.yml` | the action definition — inputs and the `metablock ship` argv |
| `example/` | a vite/react app built and deployed as the CI smoke test |
| `VERSION` | the action version, single source of truth for `make release` |
| `docs/release-notes.md` | release bodies, published by the release workflow |

## The client it wraps

The action runs
`metablock ship <bundle> --token ... --block-id ... --org ... --env ... --name ...`
from the [metablock](https://pypi.org/project/metablock/) python client,
developed in the sibling `metablock-py` repo. Two things follow from that:

- **The client version is pinned in the `Dockerfile`.** It used to track
  whatever was latest at image build time, which meant a client release changed
  the behaviour of every existing action tag. Bump the pin deliberately and cut
  a release for it.
- **Every CLI option must have a matching input in `action.yml`.** When the CLI
  grows an option the action should expose, add the input and forward it in
  `args`. Inputs are passed unconditionally, so an unset input arrives as an
  empty string; the CLI treats that as "fall back to the environment variable"
  (`token or METABLOCK_API_TOKEN`), which is what makes the env-variable
  alternatives in the readme work. Do not add a default that would defeat that
  fallback — `bundle` and `env` have defaults on purpose, because the action's
  defaults differ from the CLI's (the CLI ships to `prod` unless told
  otherwise, the action defaults to `stage`).

Since version 2 of the client, the organization is selected by the
`x-metablock-org-id` header rather than in the URL, so deployments to a block
owned by an organization need `org` (or `METABLOCK_ORG_ID`) and fail with a
`422` without it.

## CI

`build.yml` runs on every push: it builds the image, then builds `example/` and
runs the action from the checkout (`uses: ./`) to deploy it — to `stage` on a
branch, to `prod` on `main`. That job deploys for real, so it needs the
`METABLOCK_API_TOKEN` and `METABLOCK_ORG_ID` secrets and it is a live test — a
failure may reflect API state rather than a bug here.

`release.yml` is tag-driven, see [release.instructions.md](./release.instructions.md).

## Conventions

- Keep the readme's input list in step with `action.yml`; it has drifted before
  (it documented a `BUNDLE_LOCATION` variable the CLI does not read).
- Bump `VERSION` and add release notes in the same change as the behaviour
  change, so a release is only ever a tag push.
