<#
.SYNOPSIS
    Disables the Secondary Logon service.

.NOTES
    Author          : Leonard Nathaniel S. Majaducon
    LinkedIn        : linkedin.com/in/leonard-nathaniel-majaducon/
    GitHub          : github.com/leomajaducon
    Date Created    : 2026-10-13
    Last Modified   : 2026-10-13
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN11-00-000175
    Documentation   : DISA Windows 11 STIG

.TESTED ON
    Date(s) Tested  :
    Tested By       :
    Systems Tested  : Windows 11
    PowerShell Ver. : Windows PowerShell 5.1

.USAGE
    Run PowerShell ISE as Administrator.

    Example:
    PS C:\> .\WN11-00-000175.ps1
#>

$ErrorActionPreference = "Stop"

$currentIdentity = [Security.Principal.WindowsIdentity]::GetCurrent()
$principal = New-Object Security.Principal.WindowsPrincipal($currentIdentity)
if (-not $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    throw "Run PowerShell as Administrator."
}

Set-Service -Name "seclogon" -StartupType Disabled
$service = Get-Service -Name "seclogon"
if ($service.Status -ne "Stopped") {
    Stop-Service -Name "seclogon" -Force
}

Write-Host "Secondary Logon startup type set to Disabled." -ForegroundColor Green
Write-Host "If the service cannot stop immediately, reboot and verify its final state."
