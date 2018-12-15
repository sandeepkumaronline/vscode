<#
.SYNOPSIS
Using input from .csv file, removes all Tags from listed Resources 

.DESCRIPTION
Using input from .csv file, removes all Tags from listed Resources in the given subscriptions
You must authenticate to Azure to run this script
e.g. Login-AzureRmAccount

.PARAMETER Subscriptions
Array of subscription IDs e.g. @("dd6dd7d6-2092-4d28-ddd4-8381dd8d7989", "aa6aa7a6-2092-4a28-aaa4-8381aa8a7989")

.PARAMETER File
Path and file name for input .csv

.EXAMPLE
.\Remove-AllResourceTags.ps1 -Subscriptions @("dd6dd7d6-2092-4d28-ddd4-8381dd8d7989", "aa6aa7a6-2092-4a28-aaa4-8381aa8a7989") -File .\AllResources.csv
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

# Import List of Resources
$resources = (import-csv -path $file)

# Remove All Tags
function Remove-AllResourceTags {

    foreach ($resource in $resources) {
        
        # Only process resources in current subscription
        if ($resource.subscription -eq $subscription) {

            # Exclude Resources that do not support Tags
            if (!($resource.Type -like "*Classic*" `
                        -or $resource.Type -like "Microsoft.OperationsManagement*" `
                        -or $resource.Type -like "Microsoft.Insights/Alert*" `
                        -or $resource.Type -like "Microsoft.Insights/ActivityLogAlert*" `
                        -or $resource.Type -like "Microsoft.Insights/WebTest*" `
                        -or $resource.Type -like "Microsoft.Insights/AutoScale*" `
                        -or $resource.Type -like "Microsoft.Web/Certificate*")) {
                try {
                    $r = Get-AzureRmResource -ResourceId $resource.ResourceID

                    Write-Host "Processing" $r.Name

                    if (!(Get-Member -inputobject $r -name "Tags" -Membertype Properties)) {
                        Write-Host $r.Name "has no Tags" -ForegroundColor Cyan
                    }
                    else {
                        Set-AzureRmResource -Tag @{} -ResourceId $r.ResourceId -Force | Out-Null
                        Write-Host "Removed all Tags from" $r.Name -ForegroundColor Green
                    }
                }
                catch {
                    Write-Host "An error occurred. Verify that the resource still exists and you have permissions to modify it." -ForegroundColor Yellow
                    Write-Host "Exception Type: $($_.Exception.GetType().FullName)" -ForegroundColor Red
                    Write-Host "Exception Message: $($_.Exception.Message)" -ForegroundColor Red        
                }
            }
        }
    }
}


#################### Script Main ####################

# Loop through all specified subscriptions and remove tags
foreach ($subscription in $subscriptions) {

    try {
        Select-AzureRmSubscription -SubscriptionID $subscription
        Write-Output "Processing data for subscription $subscription"

        Remove-AllResourceTags
    }
    catch {
        Write-Host "An error occurred. Verify the subscription ID is correct and you have required permissions." -ForegroundColor Yellow
        Write-Host "Exception Type: $($_.Exception.GetType().FullName)" -ForegroundColor Red
        Write-Host "Exception Message: $($_.Exception.Message)" -ForegroundColor Red
    }
}