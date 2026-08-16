---
applyTo: 'VERSION,docs/release-notes.md,.github/workflows/release.yml,Makefile'
---

# Release Instructions

Releases are driven by `v*` git tags. Pushing a tag triggers
`.github/workflows/release.yml`, which checks the tag against `VERSION`, builds
and deploys `example/` as a smoke test, then extracts the matching `## vX.Y.Z`
section from `docs/release-notes.md` and publishes it as the GitHub Release body
(re-runs update the existing release instead of failing). Finally it moves the
floating major tag (`v5` for a `v5.x.y` release) to the released commit, so
consumers pinned to `@v5` pick the release up.

## Cutting a release

1. Bump `VERSION`. That is the single source of truth — the release workflow
   refuses to publish a tag that does not match it. Note this versions the
   *action*, not the `metablock` client it installs; the client pin lives in the
   `Dockerfile` and moves independently.
2. Add a `## vX.Y.Z` section at the top of `docs/release-notes.md` with the
   notes for the release. The header text is matched verbatim by the workflow's
   `awk` extractor, so it must be `## vX.Y.Z` exactly (no trailing dash, no
   title after the version). The release workflow fails if this section is
   missing.
3. Commit and merge to `main`; let the `build` workflow pass.
4. From `main`, run `make release` — it reads `VERSION`, asks for confirmation,
   then creates an annotated `vX.Y.Z` tag and pushes it. The `release` workflow
   takes it from there.

Do not move the major tag by hand — the workflow owns it, and a manual push
will be overwritten by the next release.

Note the smoke test deploys the example bundle through the live metablock API,
so a release needs valid `METABLOCK_API_TOKEN` and `METABLOCK_ORG_ID` secrets
and will fail if the API is down.

## Release-notes conventions

The `## vX.Y.Z` section in `docs/release-notes.md` is published verbatim as the
GitHub Release body, so it must follow these conventions:

- Open with a one-paragraph summary describing the theme of the release. If the
  release contains breaking changes, point readers to the **Breaking changes**
  section in that paragraph. A bump of the `metablock` client pin is worth
  naming in that paragraph, since it is what changes the action's behaviour.
- Group entries under H3 subsections in this order: `### Breaking changes`,
  `### New features`, `### Improvements and fixes`,
  `### Documentation and assets`. Omit any subsection that has no entries.
- Every PR reference must be a markdown link of the form
  `[#NN](https://github.com/quantmind/metablock-web/pull/NN)` — never a bare
  `(#NN)`. GitHub's auto-linking only works in some contexts, and the explicit
  URL works everywhere. When one entry references multiple PRs, list them
  comma-separated inside one set of parentheses, each as its own link.
- Build the PR list by running `git log vPREV..HEAD --oneline` against the
  previous release tag and following each squashed-merge commit back to its PR.
  Cross-check with `gh pr list --state merged --base main` for any PRs merged
  since the previous tag.
- End the section with a
  `[Full changelog](https://github.com/quantmind/metablock-web/compare/vPREV...vX.Y.Z)`
  link comparing the new tag against the previous one.
