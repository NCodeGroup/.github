# Workflow Templates

NCodeGroup's workflow templates: GitHub lists each one under Actions > New workflow in every repository of the
organization, and copies it into the repository once, when someone picks it.

| Workflow template | File | For |
| --- | --- | --- |
| NCode code review | [code-review.yml](code-review.yml), [code-review.properties.json](code-review.properties.json) | A repository that isn't made from the [project template](https://github.com/NCodeGroup/project-template) and wants NCode Review. A project made from the template already has the same caller. |

## NCode Code Review

`code-review.yml` is the project template's
[`template/.github/workflows/code-review.yml`](https://github.com/NCodeGroup/project-template/blob/main/template/.github/workflows/code-review.yml):
everything from its `on:` line down is the same, and only the comments above it differ, written for a repository that
has none of the template's decision records or scripts. Its header lists the one-time setup a repository needs after
copying it, Dependabot's `github-actions` entry among them, which keeps that repository's copy current.

The workflow template itself is kept in step by
[`tools/Test-WorkflowTemplate.ps1`](../tools/Test-WorkflowTemplate.ps1), which compares the two below their `on:` lines
and prints the difference. The [Workflow template check](../.github/workflows/workflow-template-check.yml) runs it every
Monday and keeps one open issue labeled `workflow-template` while they differ, closing it once they match. To fix one,
copy the caller's lines from `on:` down, keep this file's own comments, and bring them up to date where the caller's
changed in substance. [ADR-1000](../docs/decisions/1000-the-review-workflow-template-follows-the-project-templates-caller.md)
says why it works this way.
