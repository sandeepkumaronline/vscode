<#

Set-ExecutionPolicy RemoteSigned -Scope CurrentUser

.SYNOPSIS
Gets all Resource Group tag values for OrganizationID and Env in the given subscriptions and outputs the results to a csv file

.DESCRIPTION
Gets all Resource Group tag values for OrganizationID and Env in the given subscriptions and outputs the results to a csv file.
May be used for reporting and validation, and tag values can be populated and then used to populate new values.
You must authenticate to Azure to run this script
e.g. Login-AzureRmAccount

.PARAMETER Subscriptions
Array of subscription IDs e.g. @("dd6dd7d6-2092-4d28-ddd4-8381dd8d7989", "aa6aa7a6-2092-4a28-aaa4-8381aa8a7989")

.PARAMETER File
Output path and file name for .csv

.EXAMPLE
.\Get-AllAzureResourceGroups.ps1 -Subscriptions @("dd6dd7d6-2092-4d28-ddd4-8381dd8d7989", "aa6aa7a6-2092-4a28-aaa4-8381aa8a7989") -File .\AllResourceGroups.csv
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
$allAzureResourceGroups = @()

# Custom class to create objects for each Resource Group
class azureResourceGroup {
    [string]$Subscription
    [string]$ResourceGroup
    [string]$Location
    [string]$ComponentID
    [string]$Env
    [string]$Tombstone
}

# Function that gets desired properties for all Resource Groups in selected subscripion
function Get-AllAzureResourceGroups {

    # Array to store Resource Group objects created with function
    $allResourceGroups = @()

    # Get all resources in subscription
    $RGs = Get-AzureRmResourceGroup

    # Instantiate a new azureResourceGroup object for each resource
    foreach ($RG in $RGs) {
        $azureResourceGroup = New-Object azureResourceGroup
        $azureResourceGroup.Subscription = $Subscription
        $azureResourceGroup.ResourceGroup = $RG.ResourceGroupName
        $azureResourceGroup.Location = $RG.Location
        if ($RG.Tags -ne $null) {
            if ($RG.Tags.ContainsKey('ComponentID')) {$azureResourceGroup.ComponentID = $RG.Tags.ComponentID}
            if ($RG.Tags.ContainsKey('Env')) {$azureResourceGroup.Env = $RG.Tags.Env}
            if ($RG.Tags.ContainsKey('Tombstone')) {$azureResourceGroup.Tombstone = $RG.Tags.Tombstone}
        }

        # Add Resource Group to array
        $allResourceGroups += $azureResourceGroup
    }

    # Return array of Resource Groups from function
    return $allResourceGroups
}

##################### Script Main ######################

# Iterating through all specified subscriptions
foreach ($subscription in $subscriptions) {

    try {
        Select-AzureRmSubscription -SubscriptionID $subscription
        Write-Output "Processing data for subscription $subscription"
    
        # Collect all results
        $allAzureResourceGroups += Get-AllAzureResourceGroups
    }
    catch {
        Write-Host "An error occurred. Verify the subscription ID is correct and you have required permissions." -ForegroundColor Yellow
        Write-Host "Exception Type: $($_.Exception.GetType().FullName)" -ForegroundColor Red
        Write-Host "Exception Message: $($_.Exception.Message)" -ForegroundColor Red
    }
   
}

# Sort resource objects for output
$allAzureResourceGroups = ($allAzureResourceGroups | Sort-Object -Property Subscription, ResourceGroup)

# Export data to csv file
$allAzureResourceGroups | Export-Csv -Path $file -NoTypeInformation
