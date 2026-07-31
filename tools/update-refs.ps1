#!/usr/bin/env pwsh
# Regenerate the sts2 + 0Harmony reference assemblies from the local game install.
# Reads SteamLibraryPath from ../local.props; override with -Sts2DataDir.
# Run after a game update, then commit refs/ and publish a release.

param([string]$Sts2DataDir)

$ErrorActionPreference = "Stop"
Set-Location (Join-Path $PSScriptRoot "..")

if (-not $Sts2DataDir) {
    $steam = ([xml](Get-Content "local.props")).SelectSingleNode("//SteamLibraryPath").InnerText
    $Sts2DataDir = "$steam/common/Slay the Spire 2/data_sts2_windows_x86_64"
}
Write-Host "Game data dir: $Sts2DataDir"

dotnet tool restore
dotnet refasmer --all -O refs "$Sts2DataDir/sts2.dll"
dotnet refasmer --all -O refs "$Sts2DataDir/GodotSharp.dll"
dotnet refasmer --all -O refs "$Sts2DataDir/0Harmony.dll"

Write-Host "Done. Commit refs/ and publish a release."