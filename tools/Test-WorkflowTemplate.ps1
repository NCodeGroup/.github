<#
.SYNOPSIS
    Checks that workflow-templates/code-review.yml matches the NCode Review caller the project template gives its
    projects.

.DESCRIPTION
    Compares the workflow template's lines from `on:` to its end with the same lines of the project template's
    template/.github/workflows/code-review.yml on its default branch. The comments above `on:` differ on purpose: the
    workflow template's speak to a repository that isn't made from the project template. Prints the difference as a
    diff and exits 1 when the two differ, and exits 0 when they match.

    With -Issue it also keeps one open issue labeled workflow-template, titled "Update the NCode code review workflow
    template", whose body holds the difference, while the two differ, creating the label when the repository lacks it,
    and closes that issue once they match. It talks to GitHub through gh, which needs GH_TOKEN (the workflow passes
    GITHUB_TOKEN, with issues: write) and GH_REPO. ADR-1000 in docs/decisions/ says why.

.PARAMETER Source
    The caller to compare with: a URL, by default the project template's file on its default branch, or a local path.

.PARAMETER Issue
    Open, update or close the workflow-template issue, as the description says.

.EXAMPLE
    ./tools/Test-WorkflowTemplate.ps1
#>
[CmdletBinding()]
param(
    [string]$Source = 'https://raw.githubusercontent.com/NCodeGroup/project-template/main/template/.github/workflows/code-review.yml',
    [switch]$Issue
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$root = Split-Path -Parent $PSScriptRoot
$templatePath = Join-Path $root 'workflow-templates/code-review.yml'
$sourceUrl = 'https://github.com/NCodeGroup/project-template/blob/main/template/.github/workflows/code-review.yml'
$label = 'workflow-template'
$title = 'Update the NCode code review workflow template'

# The lines from `on:` to the end, with LF line endings and one final newline.
function Get-WorkflowBody([string]$Text, [string]$Name) {
    $lines = $Text -replace "`r`n", "`n" -split "`n"
    $start = [array]::IndexOf($lines, 'on:')
    if ($start -lt 0) { throw "$Name has no 'on:' line." }
    return (($lines[$start..($lines.Count - 1)] -join "`n").TrimEnd("`n")) + "`n"
}

function Invoke-Gh {
    $output = & gh @args
    if ($LASTEXITCODE) { throw "gh $($args[0]) $($args[1]) exited with code $LASTEXITCODE." }
    return $output
}

if (Test-Path -LiteralPath $Source) {
    $sourceText = Get-Content -LiteralPath $Source -Raw
} else {
    $sourceText = (Invoke-WebRequest -Uri $Source -MaximumRetryCount 2 -RetryIntervalSec 5 -TimeoutSec 30).Content
}
$want = Get-WorkflowBody $sourceText $Source
$have = Get-WorkflowBody (Get-Content -LiteralPath $templatePath -Raw) 'workflow-templates/code-review.yml'

$diff = ''
if ($have -cne $want) {
    $work = Join-Path ([IO.Path]::GetTempPath()) "workflow-template-$PID"
    New-Item -ItemType Directory -Force -Path $work | Out-Null
    try {
        $haveFile = Join-Path $work 'workflow-template.yml'
        $wantFile = Join-Path $work 'project-template.yml'
        [IO.File]::WriteAllText($haveFile, $have)
        [IO.File]::WriteAllText($wantFile, $want)
        $diff = (& git diff --no-index --no-color -- $haveFile $wantFile) -join "`n"
        if ($LASTEXITCODE -ne 1) { throw "git diff exited with code $LASTEXITCODE." }
        # git prints each absolute path after its a/ or b/ prefix; name the files instead.
        $diff = $diff.Replace($haveFile.Replace('\', '/').TrimStart('/'), 'workflow-templates/code-review.yml').Replace($wantFile.Replace('\', '/').TrimStart('/'), 'template/.github/workflows/code-review.yml')
    } finally {
        Remove-Item -LiteralPath $work -Recurse -Force
    }
}

if ($diff) {
    Write-Host "workflow-templates/code-review.yml differs from the project template's caller below 'on:':"
    Write-Host $diff
} else {
    Write-Host "workflow-templates/code-review.yml matches the project template's caller below 'on:'."
}

if ($Issue) {
    $open = @(Invoke-Gh issue list --label $label --state open --json 'number,body' --limit 100 | ConvertFrom-Json | Sort-Object number)
    if (-not $diff) {
        foreach ($item in $open) {
            Invoke-Gh issue close $item.number --comment 'workflow-templates/code-review.yml matches the project template''s caller again, so this issue is done.' | Out-Null
            Write-Host "Closed #$($item.number)."
        }
    } else {
        $body = @"
``workflow-templates/code-review.yml`` differs from the NCode Review caller the project template gives its projects, [template/.github/workflows/code-review.yml]($sourceUrl), below their ``on:`` lines. A repository that adds NCode Review from Actions > New workflow gets the older caller until this is fixed.

Copy the caller's lines from ``on:`` to its end over the workflow template's, keep the workflow template's own comments above ``on:``, and bring those comments up to date where the caller's changed in substance. ``./tools/Test-WorkflowTemplate.ps1`` passes once they match, and the next run of the Workflow template check closes this issue.

``````diff
$diff
``````
"@
        $bodyFile = Join-Path ([IO.Path]::GetTempPath()) "workflow-template-issue-$PID.md"
        [IO.File]::WriteAllText($bodyFile, $body)
        try {
            if ($open) {
                $item = $open[0]
                if ($item.body.Trim() -ne $body.Trim()) {
                    Invoke-Gh issue edit $item.number --title $title --body-file $bodyFile | Out-Null
                    Write-Host "Updated #$($item.number)."
                } else {
                    Write-Host "#$($item.number) is already up to date."
                }
            } else {
                $labels = @(Invoke-Gh label list --search $label --json name --limit 100 | ConvertFrom-Json | ForEach-Object name)
                if ($label -notin $labels) {
                    Invoke-Gh label create $label --description 'The NCode Review workflow template differs from the project template''s caller' --color 1D76DB | Out-Null
                }
                $url = Invoke-Gh issue create --title $title --label $label --body-file $bodyFile
                Write-Host "Opened $url."
            }
        } finally {
            Remove-Item -LiteralPath $bodyFile -Force
        }
    }
    # The issue is the notice; the scheduled run itself succeeds.
    exit 0
}

if ($diff) { exit 1 }
exit 0
