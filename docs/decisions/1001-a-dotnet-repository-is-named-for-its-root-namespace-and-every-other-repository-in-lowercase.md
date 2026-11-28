# 1001. A .NET repository is named for its root namespace, and every other repository in lowercase

- **Status:** Accepted
- **Date:** 2026-11-28
- **Deciders:** NCodeGroup's maintainers

## Context

An NCodeGroup repository's name is its URL, its default clone folder and the folder a sibling repository's script
looks for beside its own clone. In a .NET repository, the code also has a name of its own: the root namespace that its
projects, its solution and its NuGet package IDs share, such as `NCode.Buffers`. Without a rule, each repository's
creator picks a casing and a prefix: PascalCase or lowercase, with or without `NCode.`. A reader can't then predict a
repository's name from its package, or the other way round.

The .NET ecosystem has no single convention: Microsoft names its repositories in lowercase (`dotnet/runtime`), and
many libraries match their namespace (`App-vNext/Polly`). Everywhere else, including npm, Helm and OpenTofu, names are
lowercase.

GitHub compares repository names without regard to case. A rename that changes only the case keeps every existing URL,
remote and `owner/repo#123` reference working. A rename that changes more relies on GitHub's redirect from the old
name. The redirect covers the web, issues and `git clone`, `fetch` and `push`. It doesn't cover a GitHub Pages project
site's default URL or an action other workflows call with `uses:`, and it stops working once a new repository takes the
old name (GitHub Docs, read on 2026-11-28). nuget.org matches a trusted publishing policy's owner and repository without
regard to case, and locks the policy to GitHub's repository and owner IDs (Microsoft Learn, read on 2026-11-28). Some
other tools compare a repository's name exactly, as written, so a rename has to be checked in each of them.

## Decision

A repository whose main deliverable is .NET code is named for its root namespace, in the namespace's own casing, with
the leading `NCode.` removed: `NCode.Buffers` is `Buffers`, `NCode.PasswordGenerator` is `PasswordGenerator`, and
`NCode.Identity` is `Identity`. Every other repository is named in lowercase kebab case, such as `brand`,
`project-template` and `identity-platform`. `.github` keeps the name GitHub requires.

- **Root namespace:** the namespace every project in the repository starts with. A repository of several packages,
  hosts or apps is named for what they share, so `NCode.Identity.Jose` and `NCode.Identity.OpenId.Host` make
  `Identity`.
- **.NET repository:** one whose solution at the root is what it builds, tests and ships, even if it also holds a
  frontend, a chart or tooling. A repository that only describes, deploys or supports .NET code, such as
  infrastructure as code, a documentation toolchain or a template, isn't one.
- **Related repositories keep their own kind's casing:** `Identity` and `identity-platform` differ in case because
  one is .NET code and the other is OpenTofu.
- **The name decides the folder:** a clone is made into a folder of the repository's name, and a script that finds a
  sibling clone looks for that name exactly, because file systems on Linux distinguish case.
- **An archived repository keeps its name.** Nothing builds on it, and a rename would only move its links.
- **A name is never reused.** A renamed repository's old name stays free, so GitHub's redirect from it keeps working.

## Options considered

- **The root namespace for .NET code, lowercase kebab case for the rest (chosen).** The name and the package ID can be
  found from each other, and a .NET clone's folder matches its solution's name. Repositories in ecosystems whose names
  are lowercase stay lowercase. The cost is two casings in one organization.
- **Lowercase kebab case for every repository.** One rule with no exceptions, as Microsoft's `dotnet` organization
  does. But a .NET repository's name and its packages' names differ in more than their prefix, for example `identity`
  and `NCode.Identity`.
- **PascalCase for every repository.** Matches .NET, but goes against the convention of every other ecosystem the
  organization works in.
- **The full package ID, `NCode.` included.** Matches the package ID exactly. But the organization's name, NCodeGroup,
  already says NCode, so `NCodeGroup/NCode.Disposables` says it twice. The documentation sites leave the prefix out
  too, as in `buffers.ncode.io`.

## Consequences

- A repository's name can be predicted from its package, and a package's ID from its repository.
- A repository named otherwise is renamed, through an issue in that repository that lists what the rename touches.
- A rename that changes only the case keeps every existing link working. Its issue still checks the tools that
  compare names exactly:
  - badges and services that are keyed by the name, such as OpenSSF Scorecard and Codecov;
  - a cloud provider's federated-identity conditions, which are best keyed by GitHub's numeric IDs;
  - any workflow condition on `github.repository`.

  It also replaces the old name in the repository's own files, except in released changelog sections, which record
  history.
- A rename that changes more than the case relies on GitHub's redirect, and the clone folder changes with the name.
  Its issue also changes the repository name in the nuget.org trusted publishing policy, and moves any link to the
  GitHub Pages default URL to the site's custom domain.
- A repository that changes kind, for example a tool rewritten in .NET, changes the case of its name too.
- `New-Project.ps1 -CreateRemote` in NCodeGroup/project-template names the new repository after its destination
  folder, so that folder is named by this rule.

## References

- [GOVERNANCE.md](../../GOVERNANCE.md#repository-names), which states the rule for maintainers.
- GitHub Docs, [Renaming a repository](https://docs.github.com/en/repositories/creating-and-managing-repositories/renaming-a-repository),
  read on 2026-11-28.
- Microsoft Learn, [Trusted publishing on nuget.org](https://learn.microsoft.com/en-us/nuget/nuget-org/trusted-publishing),
  read on 2026-11-28.
