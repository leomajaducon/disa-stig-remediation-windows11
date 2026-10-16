<#
.SYNOPSIS
    Configures the Application event log maximum size to at least 32768 KB.

.NOTES
    Author          : Leonard Nathaniel S. Majaducon
    LinkedIn        : linkedin.com/in/leonard-nathaniel-majaducon/
    GitHub          : github.com/leomajaducon
    Date Created    : 2026-10-16
    Last Modified   : 2026-10-16
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN11-AU-000500
    Documentation   : DISA Windows 11 STIG

.TESTED ON
    Date(s) Tested  :
    Tested By       :
    Systems Tested  : Windows 11
    PowerShell Ver. : Windows PowerShell 5.1

.USAGE
    Run PowerShell ISE as Administrator.

    Example:
    PS C:\> .\WN11-AU-000500.ps1
#>

$ErrorActionPreference = "Stop"

$currentIdentity = [Security.Principal.WindowsIdentity]::GetCurrent()
$principal = New-Object Security.Principal.WindowsPrincipal($currentIdentity)
if (-not $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    throw "Run PowerShell as Administrator."
}

$requiredSizeKB = 32768
$requiredSizeBytes = $requiredSizeKB * 1KB
$policyPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\EventLog\Application"

New-Item -Path $policyPath -Force | Out-Null
New-ItemProperty -Path $policyPath -Name "MaxSize" -PropertyType DWord -Value $requiredSizeKB -Force | Out-Null

& wevtutil.exe sl Application "/ms:$requiredSizeBytes"
if ($LASTEXITCODE -ne 0) {
    throw "Failed to set the Application event log maximum size with wevtutil."
}

Write-Host "Application event log maximum size configured to $requiredSizeKB KB ($requiredSizeBytes bytes)." -ForegroundColor Green
Write-Host "Note: A domain GPO may override the policy registry value. Confirm the effective policy and Tenable audit result."
