<#
.SYNOPSIS
Using input from .csv file, applies Tags to Azure Resources 

.DESCRIPTION
Using input from .csv file, applies Tags to Azure Resources in the given subscriptions. 
You must authenticate to Azure to run this script
e.g. Login-AzureRmAccount

.PARAMETER Subscriptions
Array of subscription IDs e.g. @("dd6dd7d6-2092-4d28-ddd4-8381dd8d7989", "aa6aa7a6-2092-4a28-aaa4-8381aa8a7989")

.PARAMETER File
Path and file name for input .csv

.PARAMETER ApplyRGTags
Switch - if specified will apply Tags assigned to Resource Group to the Resource

.EXAMPLE
.\Set-AzureResourceTags.ps1 -Subscriptions @("dd6dd7d6-2092-4d28-ddd4-8381dd8d7989", "aa6aa7a6-2092-4a28-aaa4-8381aa8a7989") -File .\AllResources.csv -ApplyRGTags:$true
#>

[CmdletBinding()]

param
(
    [Parameter(Mandatory = $true, HelpMessage = "array of subscriptions")]
    [array]$Subscriptions,

    [Parameter(Mandatory = $true, HelpMessage = "path to .csv file")]
    [string]$File,

    [Parameter(Mandatory = $true, HelpMessage = "switch - applys tags assigned to Resource Group to all resources")]
    [switch]$ApplyRGTags
)

$ErrorActionPreference = 'Stop'

# List of Resources to be Tagged
$resourceList = (Import-Csv -Path $file)

function Set-AzureResourceTags {
    
    foreach ($resource in $resourceList) {

        # Only process resources in current subscription
        if ($resource.subscription -eq $subscription) {

            Write-Host "Processing" $resource.Resource

            # Exclude Resources that do not support Tags
            if (!($resource.Type -like "*Classic*" `
                        -or $resource.Type -like "Microsoft.OperationsManagement*" `
                        -or $resource.Type -like "Microsoft.Insights/Alert*" `
                        -or $resource.Type -like "Microsoft.Insights/ActivityLogAlert*" `
                        -or $resource.Type -like "Microsoft.Insights/WebTest*" `
                        -or $resource.Type -like "Microsoft.Insights/AutoScale*" `
                        -or $resource.Type -like "Microsoft.Web/Certificate*")) {

                # New Tags to Apply
                $tags = @{
                    Owner     = $resource.Owner
                    Purpose   = $resource.Purpose
                    Tombstone = $resource.Tombstone
                }

                try {
                    # Add Resource Group Tags if parameter evaluates True
                    if ($ApplyRGTags) {
                        $RGTags = (Get-AzureRmResourceGroup -Name $resource.ResourceGroup).Tags
                    }
   
                    $r = Get-AzureRmResource -ResourceId $resource.ResourceID
           
                    # If resource has no tags simply apply new Tags along with Resource Group Tags if specified
                    if (!(Get-Member -inputobject $r -name "Tags" -Membertype Properties)) {
                        Write-Host $r.Name "has no tags" -ForegroundColor Cyan

                        # Add Resource Group Tags to Resource
                        if ($RGTags.Count -gt 0) {

                            # Add RG Tags to Hash Table
                            $tags += $RGTags
                        }

                        # Write Tags to Resource
                        Set-AzureRmResource -Tag $tags -ResourceId $r.ResourceId -Force
                        Write-Host "Added tags to" $r.Name -ForegroundColor Green
                    }
            
                    # If resource has Tags retain or update existing Tags when new Tags are applied
                    else {
                        Write-Host $r.Name "has the Tags property. Adding new tags or updating existing values." -ForegroundColor Magenta
                      
                        if ($r.Tags.Count -gt 0) {

                            # Convert Dictionary to Hash Table
                            [hashtable]$rTags = $r.Tags

                            # Remove existing Tags for Owner, Purpose, TombStone
                            if ($rTags.ContainsKey('Owner')) {$rTags.Remove('Owner')}
                            if ($rTags.ContainsKey('Purpose')) {$rTags.Remove('Purpose')}
                            if ($rTags.ContainsKey('Tombstone')) {$rTags.Remove('Tombstone')}

                            # Combine new Tags with existing Resource Tags
                            $tags += $rTags
                        }

                        if ($RGTags.Count -gt 0) {
                    
                            # Remove duplicate Tags from Resource to apply updated values from RG
                            foreach ($key in $RGTags.Keys) {
                                if ($tags.ContainsKey($key)) {$tags.Remove($key)}
                            }

                            # Combine Tags with RG Tags
                            $tags += $RGTags
                        }

                        # Write tags to Resource
                        Set-AzureRmResource -Tag $tags -ResourceId $r.ResourceId -Force
                        Write-Host "Updated tag values for" $r.Name -ForegroundColor Blue
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


############################ Script Main #############################

# Loop through all specified subscriptions and apply Resource Tags
foreach ($subscription in $subscriptions) {
    
    try {
        Select-AzureRmSubscription -SubscriptionID $subscription
        Write-Output "Processing data for subscription $subscription"

        Set-AzureResourceTags
    }
    catch {
        Write-Host "An error occurred. Verify the subscription ID is correct and you have required permissions." -ForegroundColor Yellow
        Write-Host "Exception Type: $($_.Exception.GetType().FullName)" -ForegroundColor Red
        Write-Host "Exception Message: $($_.Exception.Message)" -ForegroundColor Red
    }
}