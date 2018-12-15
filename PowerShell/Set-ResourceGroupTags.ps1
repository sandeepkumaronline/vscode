<#

Set-ExecutionPolicy RemoteSigned -Scope CurrentUser

.SYNOPSIS
Using input from .csv file, sets specified Resource Group Tags in the given subscriptions

.DESCRIPTION
Using input from .csv file, sets specified Resource Group Tags in the given subscriptions
You must authenticate to Azure to run this script
e.g. Login-AzureRmAccount

.PARAMETER Subscriptions
Array of subscription IDs e.g. @("dd6dd7d6-2092-4d28-ddd4-8381dd8d7989", "aa6aa7a6-2092-4a28-aaa4-8381aa8a7989")

.PARAMETER File
Path and file name for input .csv

.EXAMPLE
.\Set-ResourceGroupTags.ps1 -Subscriptions @("dd6dd7d6-2092-4d28-ddd4-8381dd8d7989", "aa6aa7a6-2092-4a28-aaa4-8381aa8a7989") -File .\AllResourceGroups.csv
#>

[CmdletBinding()]

param
(
    [Parameter(Mandatory = $true, HelpMessage = "array of subscriptions")]
    [array]$Subscriptions,

    [Parameter(Mandatory = $true, HelpMessage = "path to input .csv file")]
    [string]$File
)

$ErrorActionPreference = 'Stop'

# Import Resource Group Tag info
$RGs = (import-csv -path $file)

function Set-ResourceGroupTags {

    foreach ($RG in $RGs) {

        # Only process resources in current subscription
        if ($RG.subscription -eq $subscription) {
            try {
                Write-Host "Applying Tags to" $RG.ResourceGroup -ForegroundColor Green

                # Get existing Tags assigned to Resource Group
                $tags = (Get-AzureRmResourceGroup -Name $RG.ResourceGroup).Tags
            
                # If ComponentID or Env are already set drop current values
                if ($tags.Count -gt 0) {
                    if ($tags.ContainsKey('ComponentID')) {$tags.Remove('ComponentID')}
                    if ($tags.ContainsKey('Env')) {$tags.Remove('Env')}
                    if ($tags.ContainsKey('Tombstone')) {$tags.Remove('Tombstone')}
                }

                # Add new Tags to hash table
                $newTags = @{
                    ComponentID = $RG.ComponentID
                    Env         = $RG.Env
                    Tombstone   = $RG.Tombstone
                }

                $tags += $newTags

                # Write new Tags to Resource Group
                Set-AzureRmResourceGroup -Tag $tags -Name $RG.ResourceGroup
            }
    
            catch {
                Write-Host "An error occurred. Verify the RG still exists and you have permissions to modify it." -ForegroundColor Yellow
                Write-Host "Exception Type: $($_.Exception.GetType().FullName)" -ForegroundColor Red
                Write-Host "Exception Message: $($_.Exception.Message)" -ForegroundColor Red
            }     
        }
    }
}

# Loop through all subscriptions and apply Tags
foreach ($subscription in $subscriptions) {

    try {
        Select-AzureRmSubscription -SubscriptionID $subscription
        Write-Output "Processing data for subscription $subscription"
    
        Set-ResourceGroupTags 
    }
    catch {
        Write-Host "An error occurred. Verify the subscription ID is correct and you have required permissions." -ForegroundColor Yellow
        Write-Host "Exception Type: $($_.Exception.GetType().FullName)" -ForegroundColor Red
        Write-Host "Exception Message: $($_.Exception.Message)" -ForegroundColor Red
    }
}


