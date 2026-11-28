# Architecture

[//]: # "Maintainers: describe the components, as a diagram and a table (Component, Role), and the rules the design
keeps."

How .github is built. [assurance-case.md](assurance-case.md) explains why the design meets its security
requirements.

## Components

Not described yet.

## Design Rules

- Decisions the design rests on are recorded in [decisions/](decisions/README.md).

## Build and Release

CI
(`.github/workflows/ci.yml`) runs on every pull request, and runs the
project's build and test commands once it has them. Releases are tagged when `AGENTS.md`'s Landing section sets `release: tag`, and published too with
`tag+release`, as
[ADR-0016](decisions/project-template/0016-releases-are-tagged-and-published-when-their-pull-request-merges.md)
records.
