# This Script will set ASPNETCORE_ENVIRONMENT to the appropriate value based on the Server's name
# This Script needs elevated permissions in order to set the system variable

param (
    [ValidateSet($null, "Test", "Stage", "Prod")]
    [string]
    $AspValue = $null
)

if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs;
    exit
}

$VariableName = 'ASPNETCORE_ENVIRONMENT'

if (!$AspValue) {
    $AspValue = switch -wildcard ($env:COMPUTERNAME.ToLower()) {
        "wtw2ppldvwb*" { "Test"; break }
        "aun1pplpvwb*" { "Staging"; break }
        "aun1pplmvapp*" { "Prod"; break }
        "aun1pplmvweb*" { "Prod"; break }
        default {
            Write-Error "Unknown Server Name. Can not set $VariableName."
            exit
        }
    }
}

Write-Host "Server Environment will be set to: $AspValue" -ForegroundColor Green

try {
    [System.Environment]::SetEnvironmentVariable($VariableName, $AspValue, "Machine")
}
catch [System.Management.Automation.MethodInvocationException] {
    Write-Error "This script needs elevated privileges to set environment variables. Please re-run this script with Admin Level Privileges."
    exit
}

Write-Host "$VariableName has been set to $AspValue" -ForegroundColor Green
Write-Host "Script Finished" -ForegroundColor Green
