# Release notes

## v5.1.0

Brings the action up to date with version 2 of the [metablock](https://pypi.org/project/metablock/)
python client. The client now selects the organization with a header rather than
in the URL, so the action gained an `org` input: deployments to a block owned by
an organization fail with a `422` without it. The client version shipped by the
action is pinned from now on, so a new client release can no longer change what
the action does without a release here.

### New features

- New `org` input, forwarded to the CLI as `--org`, defaulting to the
  `METABLOCK_ORG_ID` environment variable.
- Tag-driven release workflow: pushing a `v*` tag publishes a GitHub Release
  from this file and moves the floating major tag (`v5`) to the same commit.

### Improvements and fixes

- The `metablock[cli]` install is pinned to `2.0.0` instead of `1.1`, and the
  image is built on python 3.14.
- The action is named `Metablock Web`, matching the repository; it was still
  advertising itself as `Metablock Action` after the rename. Its description now
  says what it actually does: deploy a new version of an html block.
- `VERSION` is the single source of truth for the action version, checked by the
  release workflow against the pushed tag.
- Makefile targets are sorted and documented, and `make release` cuts the tag.

### Documentation and assets

- The readme badges point at this repository instead of the old
  `metablock-action` name, and document the `org` input.
- Development guidance added under `.github/instructions/`, imported by
  `CLAUDE.md` for AI agents.

[Full changelog](https://github.com/quantmind/metablock-web/compare/v5.0.0...v5.1.0)
