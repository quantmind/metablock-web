# metablock-web

[![build](https://github.com/quantmind/metablock-web/actions/workflows/build.yml/badge.svg)](https://github.com/quantmind/metablock-web/actions/workflows/build.yml)
[![release](https://github.com/quantmind/metablock-web/actions/workflows/release.yml/badge.svg)](https://github.com/quantmind/metablock-web/actions/workflows/release.yml)

Github action for deploying a new version of an html block to metablock cloud.
It is a docker action wrapping `metablock ship` from the
[metablock](https://pypi.org/project/metablock/) python client: the bundle
directory of a static site is zipped and shipped to the block, in either the
`stage` or `prod` environment.

It deploys html blocks only. Other block types are not shipped this way, and
block configuration is handled by the sibling
[metablock-ingress](https://github.com/quantmind/metablock-ingress) action.

## Usage

```yaml
- uses: quantmind/metablock-web@v5
  env:
    METABLOCK_API_TOKEN: ${{ secrets.METABLOCK_API_TOKEN }}
  with:
    block: my-block-id
    org: my-org-id
    env: prod
    bundle: dist
```

## Inputs

- **token**: Metablock API token, you need to create one on the metablock admin. Alternatively set the `METABLOCK_API_TOKEN` environment variable.
- **block**: Metablock Block ID. Alternatively set the `METABLOCK_BLOCK_ID` environment variable.
- **org**: Metablock organization id the request acts within. Alternatively set the `METABLOCK_ORG_ID` environment variable. Required by the API for org-owned blocks.
- **bundle**: filesystem location of the bundle to deploy, defaults to `./dist`.
- **env**: environment to deploy to, either `stage` or `prod`, defaults to `stage`. Alternatively set the `METABLOCK_ENV` environment variable.
- **name**: optional deployment name. Alternatively set the `METABLOCK_NAME` environment variable.

Check the [build.yml](./.github/workflows/build.yml) manifest file for an
example where pushes to a branch are deployed to `stage` and a merge to `main`
to `prod`.

## Releasing

Bump `VERSION`, add the matching section to
[docs/release-notes.md](./docs/release-notes.md) and run `make release` — see
[release.instructions.md](./.github/instructions/release.instructions.md).
