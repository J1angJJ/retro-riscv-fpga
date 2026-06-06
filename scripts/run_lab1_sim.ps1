param(
    [string]$Iverilog = "iverilog",
    [string]$Vvp = "vvp"
)

$ErrorActionPreference = "Stop"

$repoRoot = Split-Path -Parent $PSScriptRoot
$buildDir = Join-Path $repoRoot "build\lab1_led_blink"
$outFile = Join-Path $buildDir "led_blink_tb.vvp"
$srcFile = Join-Path $repoRoot "labs\lab1_led_blink\src\led_blink.v"
$tbFile = Join-Path $repoRoot "labs\lab1_led_blink\tb\led_blink_tb.v"

New-Item -ItemType Directory -Force -Path $buildDir | Out-Null

& $Iverilog -o $outFile $srcFile $tbFile
& $Vvp $outFile
