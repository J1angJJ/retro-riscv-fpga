param(
    [string]$GwSh = "gw_sh"
)

$ErrorActionPreference = "Stop"

$repoRoot = Split-Path -Parent $PSScriptRoot
$tclFile = Join-Path $repoRoot "scripts\create_lab1_gowin_project.tcl"

& $GwSh $tclFile
