# Governance

This is the default governance for every NCodeGroup repository that doesn't have a `GOVERNANCE.md` of its own. A
repository's own file takes precedence. Every NCodeGroup repository belongs to the NCodeGroup organization; this page
says who does what and how decisions are made.

## Roles

| Role | Who | Responsibilities |
| --- | --- | --- |
| Maintainer | The organization's owners, and the people they give write access to a repository | Sets direction, triages issues, reviews and merges pull requests, answers vulnerability and conduct reports, owns the repository's settings |
| Contributor | Anyone | Opens issues and pull requests, under the [contributing guide](https://github.com/NCodeGroup/.github/blob/main/CONTRIBUTING.md) and the [Code of Conduct](https://github.com/NCodeGroup/.github/blob/main/CODE_OF_CONDUCT.md) |
| Automation | Dependabot, GitHub Actions | Proposes dependency updates, runs CI, tags and publishes releases where the repository sets that up; never merges a pull request |

Only a maintainer has write access. A contributor who keeps contributing reviewed, merged work can be invited to become
a maintainer of a repository; the organization's owners decide, and a repository with its own `GOVERNANCE.md` records
the change there.

## Decisions

- Day-to-day decisions are made in issues and pull requests. Anyone can comment; a maintainer decides.
- A decision someone would otherwise re-argue is recorded as an architecture decision record, in the repository's
  `docs/decisions/` where it has one, before or with the pull request that builds it. A change consumers can observe,
  such as to the public API, behavior or security posture, starts as an issue.
- Where maintainers disagree, they discuss it on the issue; with no agreement, the change doesn't happen.

## Releases

Versions follow Semantic Versioning. Each repository says how it releases: in a repository made from the
[project template](https://github.com/NCodeGroup/project-template), the Landing section of its `AGENTS.md`.

## Repository Names

A maintainer names a new repository by one rule, and renames one that doesn't follow it
([ADR-1001](https://github.com/NCodeGroup/.github/blob/main/docs/decisions/1001-a-dotnet-repository-is-named-for-its-root-namespace-and-every-other-repository-in-lowercase.md)):

- A repository of .NET code is named for its root namespace without the leading `NCode.`, in the namespace's casing:
  `NCode.Buffers` is `Buffers`.
- Every other repository is named in lowercase kebab case, such as `project-template`.
- An old name is never reused, so GitHub's redirect from it keeps working.

## Continuity

Every repository, with its issues, decision records, build, release automation and documentation, is in the NCodeGroup
GitHub organization, so anyone given access can carry on with no knowledge held elsewhere. Continuity needs at least
two people who can administer the organization; until there are two, it is incomplete.

## Changing This Document

Governance changes through a pull request to this file in
[NCodeGroup/.github](https://github.com/NCodeGroup/.github), which a maintainer merges.
