<#
.SYNOPSIS
    This powershell script enables the Windows password complexity requirement for STIG compliance.

.NOTES
    Author          : Leonard Nathaniel S. Majaducon
    LinkedIn        : linkedin.com/in/leonard-nathaniel-majaducon/
    GitHub          : github.com/leomajaducon
    Date Created    : 2026-10-13
    Last Modified   : 2026-10-13
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN11-AC-000040
    Documentation   : DISA Windows 11 STIG

.TESTED ON
    Date(s) Tested  :
    Tested By       :
    Systems Tested  : Windows 11
    PowerShell Ver. : Windows PowerShell 5.1

.USAGE
    Run PowerShell ISE as Administrator.
    Execute this script to enable password complexity.

    Example:
    PS C:\> .\WN11-AC-000040.ps1
#>

$ErrorActionPreference = "Stop"

# 1. Check administrator privileges
$currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
$principal = New-Object Security.Principal.WindowsPrincipal($currentUser)

if (-not $principal.IsInRole(
    [Security.Principal.WindowsBuiltInRole]::Administrator
)) {
    throw "ERROR: Run PowerShell ISE as Administrator."
}

# 2. Define working files
$workDir = Join-Path $env:TEMP "STIG-AC-000040"
New-Item -Path $workDir -ItemType Directory -Force | Out-Null

$backupFile = Join-Path $workDir "secpol-backup.inf"
$configFile = Join-Path $workDir "secpol-updated.inf"
$dbFile = Join-Path $workDir "secpol.sdb"

# 3. Export current local security policy
Write-Host "[1/3] Backing up current security policy..." -ForegroundColor Cyan

secedit.exe /export /cfg $backupFile /areas SECURITYPOLICY

if ($LASTEXITCODE -ne 0) {
    throw "Failed to export the current security policy. No changes applied."
}

# 4. Modify PasswordComplexity only in the exported policy
Write-Host "[2/3] Enabling password complexity..." -ForegroundColor Cyan

$content = Get-Content -Path $backupFile -Encoding Unicode

$sectionStart = -1
$sectionEnd = $content.Count

for ($i = 0; $i -lt $content.Count; $i++) {
    if ($content[$i] -match '^\s*\[System Access\]\s*$') {
        $sectionStart = $i
        continue
    }

    if ($sectionStart -ge 0 -and
        $i -gt $sectionStart -and
        $content[$i] -match '^\s*\[') {
        $sectionEnd = $i
        break
    }
}

if ($sectionStart -lt 0) {
    throw "The [System Access] section was not found. No changes applied."
}

$settingIndex = -1

for ($i = $sectionStart + 1; $i -lt $sectionEnd; $i++) {
    if ($content[$i] -match '^\s*PasswordComplexity\s*=') {
        $settingIndex = $i
        break
    }
}

if ($settingIndex -ge 0) {
    $content[$settingIndex] = "PasswordComplexity = 1"
}
else {
    $content = @(
        $content[0..($sectionEnd - 1)]
        "PasswordComplexity = 1"
        $content[$sectionEnd..($content.Count - 1)]
    )
}

Set-Content -Path $configFile -Value $content -Encoding Unicode

# 5. Apply the exported security policy
Write-Host "[3/3] Applying security policy..." -ForegroundColor Cyan

secedit.exe /configure /db $dbFile /cfg $configFile /areas SECURITYPOLICY

if ($LASTEXITCODE -ne 0) {
    throw "Policy application failed. Review the secedit output."
}

Write-Host ""
Write-Host "SUCCESS: Password complexity policy applied." -ForegroundColor Green
Write-Host "Original policy backup: $backupFile"
Write-Host "Updated policy file: $configFile"
Write-Host ""
Write-Host "Run Verify-STIG-AC-000040.ps1 to verify the setting."
```
