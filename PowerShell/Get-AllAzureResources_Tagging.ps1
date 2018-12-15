<#
.SYNOPSIS
Gets all resources in the given subscriptions and outputs the results to a csv file

.DESCRIPTION
Gets all resources  in the given subscriptions and outputs the results to a csv file
You must authenticate to Azure  in order to run this script
e.g. Login-AzureRmAccount

.PARAMETER Subscriptions
Array of subscription IDs e.g. @("dd6dd7d6-2092-4d28-ddd4-8381dd8d7989", "aa6aa7a6-2092-4a28-aaa4-8381aa8a7989")

.PARAMETER File
Output path and file name for .csv

.EXAMPLE
.\Get-AllAzureResources.ps1 -Subscriptions @("dd6dd7d6-2092-4d28-ddd4-8381dd8d7989", "aa6aa7a6-2092-4a28-aaa4-8381aa8a7989") -File .\AllResources.csv
#>

[CmdletBinding()]

param
(
    [Parameter(Mandatory = $true, HelpMessage = "array of subscriptions")]
    [array]$Subscriptions,

    [Parameter(Mandatory = $true, HelpMessage = "path to output .csv file")]
    [string]$File
)

$ErrorActionPreference = 'Stop'

# Array to store resource objects
$allAzureResources = @()

# Custom class to create object to store the data
class AzureResource {
    [string]$Subscription
    [string]$ResourceGroup
    [string]$Resource
    [string]$Type
    [string]$Location
    [string]$ResourceID
    [string]$Owner
    [string]$Purpose
    [string]$Tombstone
}

# Function that gets all resources in currently selected subscripion
function Get-AllAzureResources {

    # Array to store resource objects created with Function
    $allResources = @()

    # Get all resources in subscription
    $resources = Get-AzureRmResource

    # Instantiate a new AzureResource object for each resource
    foreach ($resource in $resources) {
        
        $azureResource = New-Object AzureResource
        $azureResource.Subscription = $Subscription
        $azureResource.ResourceGroup = $resource.ResourceGroupName
        $azureResource.Resource = $resource.Name
        $azureResource.Type = $resource.ResourceType
        $azureResource.ResourceID = $resource.ResourceID
        $azureResource.Location = $resource.Location
        if ($resource.Tags.Count -gt 0) {
            if ($resource.Tags.ContainsKey('Owner')) {$azureResource.Owner = $resource.Tags.Owner}      
            if ($resource.Tags.ContainsKey('Purpose')) {$azureResource.Purpose = $resource.Tags.Purpose}
            if ($resource.Tags.ContainsKey('Tombstone')) {$azureResource.Tombstone = $resource.Tags.Tombstone}
        }
        else {
            $azureResource.Owner = ""
            $azureResource.Purpose = ""
            $azureResource.Tombstone = ""
        }

        # Add resource object to array
        $allResources += $azureResource
    }
# Return array of resource objects from function
return $allResources
}


#################### Script Main #####################

# Iterating through all specified subscriptions
foreach ($subscription in $subscriptions) {

    try {
        Select-AzureRmSubscription -SubscriptionID $Subscription
        Write-Output "Processing data for subscription $Subscription"

        # Get all reources and add to array
        $allAzureResources += Get-AllAzureResources
    }
    catch {
        Write-Host "An error occurred. Verify the subscription ID is correct and you have required permissions." -ForegroundColor Yellow
        Write-Host "Exception Type: $($_.Exception.GetType().FullName)" -ForegroundColor Red
        Write-Host "Exception Message: $($_.Exception.Message)" -ForegroundColor Red
    }
}

# Sort resource objects for output
$allAzureResources = ($allAzureResources | Sort-Object -Property Subscription, ResourceGroup, Type, Name)

# Export data to csv file
$allAzureResources | Export-Csv -Path $file -NoTypeInformation