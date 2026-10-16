<#
.SYNOPSIS
    Sets password history to remember 24 passwords.

.NOTES
    Author          : Leonard Nathaniel S. Majaducon
    LinkedIn        : linkedin.com/in/leonard-nathaniel-majaducon/
    GitHub          : github.com/leomajaducon
    Date Created    : 2026-10-15
    Last Modified   : 2026-10-15
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN11-AC-000020
    Documentation   : DISA Windows 11 STIG

.TESTED ON
    Date(s) Tested  :
    Tested By       :
    Systems Tested  : Windows 11
    PowerShell Ver. : Windows PowerShell 5.1

.USAGE
    Run PowerShell ISE as Administrator.

    Example:
    PS C:\> .\WN11-AC-000020.ps1
#>

$ErrorActionPreference = "Stop"

$currentIdentity = [Security.Principal.WindowsIdentity]::GetCurrent()
$principal = New-Object Security.Principal.WindowsPrincipal($currentIdentity)
if (-not $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    throw "Run PowerShell as Administrator."
}

$workDir = Join-Path $env:TEMP "STIG-WN11-AC-000020"
New-Item -Path $workDir -ItemType Directory -Force | Out-Null
$backupFile = Join-Path $workDir "secpol-backup.inf"
$configFile = Join-Path $workDir "secpol-updated.inf"
$dbFile = Join-Path $workDir "secpol.sdb"

& secedit.exe /export /cfg $backupFile /areas SECURITYPOLICY
if ($LASTEXITCODE -ne 0) {
    throw "Failed to export the current security policy. No changes were applied."
}

$content = Get-Content -Path $backupFile -Encoding Unicode
$sectionStart = -1
$sectionEnd = $content.Count

for ($i = 0; $i -lt $content.Count; $i++) {
    if ($content[$i] -match '^\s*\[System Access\]\s*$') {
        $sectionStart = $i
        continue
    }
    if ($sectionStart -ge 0 -and $i -gt $sectionStart -and $content[$i] -match '^\s*\[') {
        $sectionEnd = $i
        break
    }
}

if ($sectionStart -lt 0) {
    throw "The [System Access] section was not found. No changes were applied."
}

$settingIndex = -1
for ($i = $sectionStart + 1; $i -lt $sectionEnd; $i++) {
    if ($content[$i] -match '^\s*PasswordHistorySize\s*=') {
        $settingIndex = $i
        break
    }
}

if ($settingIndex -ge 0) {
    $content[$settingIndex] = "PasswordHistorySize = 24"
}
else {
    $insertAt = $sectionEnd
    $content = @($content[0..($insertAt - 1)] + "PasswordHistorySize = 24" + $content[$insertAt..($content.Count - 1)])
}

Set-Content -Path $configFile -Value $content -Encoding Unicode
& secedit.exe /configure /db $dbFile /cfg $configFile /areas SECURITYPOLICY
if ($LASTEXITCODE -ne 0) {
    throw "Failed to apply the security policy. Review secedit output."
}

Write-Host "Password history configured to remember 24 passwords." -ForegroundColor Green
Write-Host "Policy backup: $backupFile"
Write-Host "Updated policy: $configFile"
