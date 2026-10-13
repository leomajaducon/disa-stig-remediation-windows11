<#
.SYNOPSIS
    Enables blocking of consumer Microsoft account user authentication for STIG compliance.

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

# Check administrator privileges
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    throw "ERROR: Run PowerShell as Administrator."
}

# Enable the STIG setting
$path = "HKLM:\SOFTWARE\Policies\Microsoft\MicrosoftAccount"
New-Item -Path $path -Force | Out-Null
New-ItemProperty -Path $path -Name "DisableUserAuth" -PropertyType DWord -Value 1 -Force | Out-Null

# Verify the setting
$value = (Get-ItemProperty -Path $path -Name "DisableUserAuth").DisableUserAuth

if ($value -eq 1) {
    Write-Host "PASS: Consumer Microsoft account user authentication is blocked." -ForegroundColor Green
} else {
    throw "FAIL: Setting was not applied correctly."
}
