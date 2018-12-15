<#
.SYNOPSIS
Using input from .csv file, removes all Tags from listed Resource Groups 

.DESCRIPTION
Using input from .csv file, removes all Tags from listed Resource Groups in the given subscriptions
You must authenticate to Azure to run this script
e.g. Login-AzureRmAccount

.PARAMETER Subscriptions
Array of subscription IDs e.g. @("dd6dd7d6-2092-4d28-ddd4-8381dd8d7989", "aa6aa7a6-2092-4a28-aaa4-8381aa8a7989")

.PARAMETER File
Path and file name for input .csv

.EXAMPLE
.\Remove-AllResourceGroupTags.ps1 -Subscriptions @("dd6dd7d6-2092-4d28-ddd4-8381dd8d7989", "aa6aa7a6-2092-4a28-aaa4-8381aa8a7989") -File .\AllResourceGroups.csv
#>

[CmdletBinding()]

param
(
    [Parameter(Mandatory = $true, HelpMessage = "array of subscriptions")]
    [array]$Subscriptions,

    [Parameter(Mandatory = $true, HelpMessage = "path to .csv file")]
    [string]$File
)

$ErrorActionPreference = 'Stop'

# Import Resource Group list
$RGs = (import-csv -path $file)

function Remove-ResourceGroupTags {

    $tags = @{}

    foreach ($RG in $RGs) {

        # Only process resources in current subscription
        if ($RG.subscription -eq $subscription) {

            try {
                Write-Host "Removing all Tags from" $RG.ResourceGroup -ForegroundColor Green

                # Write new Tags to Resource Group
                Set-AzureRmResourceGroup -Tag $tags -Name $RG.ResourceGroup
            }
    
            catch {
                Write-Host "An error occurred." -ForegroundColor Yellow
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
    
        Remove-ResourceGroupTags 
    }
    catch {
        Write-Host "An error occurred. Verify the subscription ID is correct and you have required permissions." -ForegroundColor Yellow
        Write-Host "Exception Type: $($_.Exception.GetType().FullName)" -ForegroundColor Red
        Write-Host "Exception Message: $($_.Exception.Message)" -ForegroundColor Red
    }
}
