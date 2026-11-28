# Changelog

What changes in NCodeGroup's organization defaults: the profile, the default community files and the workflow
templates.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and this project adheres to
[Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- The "NCode code review" workflow template, under Actions > New workflow in every NCodeGroup repository: the NCode
  Review caller the project template gives its projects, for a repository that isn't made from the template, with the
  one-time setup in its header. A weekly check keeps one issue labeled `workflow-template` open while it differs from
  the template's caller (ADR-1000).
- The default `CONTRIBUTING.md` says how NCode Review reviews and approves a pull request where a repository runs it.
