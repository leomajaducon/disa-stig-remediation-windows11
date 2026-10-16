<#
.SYNOPSIS
    Blocks consumer Microsoft account user authentication.

.NOTES
    Author          : Leonard Nathaniel S. Majaducon
    LinkedIn        : linkedin.com/in/leonard-nathaniel-majaducon/
    GitHub          : github.com/leomajaducon
    Date Created    : 2026-10-13
    Last Modified   : 2026-10-13
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN11-00-000126
    Documentation   : DISA Windows 11 STIG

.TESTED ON
    Date(s) Tested  :
    Tested By       :
    Systems Tested  : Windows 11
    PowerShell Ver. : Windows PowerShell 5.1

.USAGE
    Run PowerShell ISE as Administrator.

    Example:
    PS C:\> .\WN11-00-000126.ps1
#>

$ErrorActionPreference = "Stop"

$currentIdentity = [Security.Principal.WindowsIdentity]::GetCurrent()
$principal = New-Object Security.Principal.WindowsPrincipal($currentIdentity)
if (-not $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    throw "Run PowerShell as Administrator."
}

$path = "HKLM:\SOFTWARE\Policies\Microsoft\MicrosoftAccount"
New-Item -Path $path -Force | Out-Null
New-ItemProperty -Path $path -Name "DisableUserAuth" -PropertyType DWord -Value 1 -Force | Out-Null

Write-Host "Configured DisableUserAuth=1 (Block consumer Microsoft account user authentication)." -ForegroundColor Green
Write-Host "Note: Domain Group Policy/MDM may override local configuration. Confirm with gpresult and the Tenable audit result."
