# 1000. The review workflow template follows the project template's caller

- **Status:** Accepted
- **Date:** 2026-11-28
- **Deciders:** NCodeGroup's maintainers

## Context

A repository that isn't made from the project template turns on NCode Review by picking the "NCode code review"
workflow template under Actions > New workflow. GitHub copies `workflow-templates/code-review.yml` into the repository
once. The project template gives its projects the same caller, `template/.github/workflows/code-review.yml`, which
NCodeGroup/project-template's own Dependabot keeps current and whose shape changes with NCode Review's releases, as the
`review-forks` input did.

Dependabot's `github-actions` ecosystem reads only `.github/workflows/` and the root `action.yml` or `action.yaml`
(GitHub's Dependabot options reference, `directory`, read on 2026-11-28), so it never updates a pin in
`workflow-templates/`.

## Decision

`workflow-templates/code-review.yml` is the project template's caller from its `on:` line down, with comments of its own
above it. `tools/Test-WorkflowTemplate.ps1` compares the two below their `on:` lines, and the Workflow template check
runs it every Monday, on demand and on each push that changes the workflow template, keeping one open issue labeled
`workflow-template` while they differ and closing it once they match.

## Options considered

- **Follow the project template's caller, checked weekly (chosen).** One caller is reviewed, in the project template,
  and the workflow template follows it: its pin, inputs and conditions, not only its version. The pin waits for the
  template's Dependabot cooldown and review before this repository is asked to take it.
- **A Dependabot entry for `workflow-templates/`.** Not possible: Dependabot doesn't read that folder.
- **A step in NCodeGroup/code-review's release checklist.** Depends on a person remembering it in another repository,
  and catches a new release but not a change to the caller's inputs or conditions.

## Consequences

- A new NCode Review release reaches the workflow template a week or so after the project template takes it, through an
  issue that holds the diff.
- A change to the caller's comments alone opens no issue: the workflow template's comments are its own, and the person
  who copies a change below `on:` brings them up to date.
- Repositories that already copied the workflow template keep their copy; their own Dependabot entry keeps its pin
  current.

## References

- [workflow-templates/README.md](../../workflow-templates/README.md)
- [tools/Test-WorkflowTemplate.ps1](../../tools/Test-WorkflowTemplate.ps1)
- [The project template's caller](https://github.com/NCodeGroup/project-template/blob/main/template/.github/workflows/code-review.yml)
- [#2](https://github.com/NCodeGroup/.github/issues/2)
