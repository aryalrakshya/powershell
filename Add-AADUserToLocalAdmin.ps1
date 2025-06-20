
param (
    [Parameter(Mandatory=$true)]
    [string]$AzureADUser
)

# Check if the user profile exists locally
$localProfileExists = (Get-LocalUser -Name $AzureADUser -ErrorAction SilentlyContinue) -ne $null

if (-not $localProfileExists) {
    Write-Output "User $AzureADUser must sign in to the device at least once before being added to local Administrators group."
    exit 1
}

try {
    Add-LocalGroupMember -Group "Administrators" -Member "AzureAD\$AzureADUser"
    Write-Output "Successfully added AzureAD\\$AzureADUser to Administrators group."
} catch {
    Write-Error "Failed to add user: $_"
}
