<#
"Change to user preference for PowerShell execution policy..."
Set-ExecutionPolicy 'Unrestricted' -Force

"First thing first... Login to Azure..."
Login-AzureRmAccount

"Listing down all the subscription account has access to..."
Get-AzureRmSubscription


"List down the Secrets stored in KeyVault..."
Get-AzureKeyVaultSecret -VaultName "MakeKeyVault-DEV" | Select-Object Name, Enabled, Created, Updated, Expires | Format-Table #| Export-Csv -Path "D:\SRE\MAKE\MDS_MAKE_VAULT_DEV - Secrets.csv"
#>

$subscriptionID = Get-AzureRmSubscription -SubscriptionName "MES Development"
$resourceGroupName = 'MDS_Automation_Runbooks'
$resourceGroupLocation = 'WestUS'

$aadApplicationName = "MDSKeyVaultApp"
$aadApplicationUri = "http://MDSKeyVaultApp"
$aadSecureStringPassword = ConvertTo-SecureString -String "doodle$7" -AsPlainText -Force

$automationAccountName = 'azautomationdev'
$runbookName = 'DDS_StorageKey_Rotation_Dev'
$runbookType = 'Powershell'






"Setting context to Azure Subscription the activity needs to perform in..."

$subscriptionID = Get-AzureRmSubscription -SubscriptionName "MES Development"
Set-AzureRmContext -SubscriptionId $subscriptionID.Id

<#----------------------------------------------------------------
        # Create and empty Resource Group

Create an empty Resource Group to hold all relevent resources together
----------------------------------------------------------------#>

New-AzureRmResourceGroup -Name $resourceGroupName -Location $resourceGroupLocation

<#----------------------------------------------------------------
        # Create AAD Application

Most important step is registering your application with Azure Active Directory and then 
telling Key Vault your application information so that it can allow requests from your application.
----------------------------------------------------------------#>

        # Create the Azure AD app
$azureAdApplication = New-AzureRmADApplication -DisplayName $aadApplicationName -HomePage $aadApplicationUri -IdentifierUris $aadApplicationUri -Password $aadSecureStringPassword

        # Create a Service Principal for the app
$svcPrincipal = New-AzureRmADServicePrincipal -ApplicationId $azureAdApplication.ApplicationId

        # Assign the Contributor RBAC role to the service principal
$roleAssignment = New-AzureRmRoleAssignment -RoleDefinitionName Contributor -ServicePrincipalName $azureAdApplication.ApplicationId.Guid

# Display the values for your application 
Write-Output "Save these values for using them in your application..."
Write-Output "Subscription ID:" (Get-AzureRmContext).Subscription.SubscriptionId
Write-Output "Tenant ID:" (Get-AzureRmContext).Tenant.TenantId
Write-Output "Application ID:" $azureAdApplication.ApplicationId.Guid
Write-Output "Application Secret:" $aadSecureStringPassword

<#
    Subscription ID:    1a3ad915-4a5f-415f-b007-6526c68fede6
    Tenant ID:    72f988bf-86f1-41af-91ab-2d7cd011db47
    Application ID:    2dd89595-3e17-4ac4-b7b8-3077df4d328c
    Application Secret:    doodle$7
#>

<#----------------------------------------------------------------
        # Create AAD Application Key

Generate a key for your application so it can interact with your Azure Active Directory. 
Create a key under by navigating to the Keys section under Settings. 
The key will not be available after you navigate out of this section, so note it down carefully.
----------------------------------------------------------------#>




<#----------------------------------------------------------------
        # Grant Get permissions to AAD application on KeyVault
----------------------------------------------------------------#>

$aadApplicationId = "2dd89595-3e17-4ac4-b7b8-3077df4d328c"
$keyVaultName = "MakeKeyVault-DEV"
Set-AzureRmKeyVaultAccessPolicy -VaultName $keyVaultName -ServicePrincipalName $aadApplicationId -PermissionsToSecrets Get

<#----------------------------------------------------------------
        # Create Automation Account
----------------------------------------------------------------#>










        #"Creating a new Azure Automation Runbook..."
New-AzureRmAutomationRunbook -AutomationAccountName $automationAccountName -Name $runbookName -ResourceGroupName (New-AzureRmResourceGroup -Name $resourceGroupName -Location $resourceGroupLocation) -Type $runbookType

        # Import JSON configuration file


        # Schedule Runbook








