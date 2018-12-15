param
(
    [Parameter(Mandatory=$True)]
    [String[]] $storageAccountResourceGroupNames, 
    
    [Parameter(Mandatory=$True)]
    [String[]] $storageAccountNames,
    
    [Parameter(Mandatory=$True)]
    [String[]] $keyVaultNames,
    
    [Parameter(Mandatory=$True)]
    [String[]] $secretNames,
    
    [Parameter(Mandatory=$True)]
    [String[]] $webAppResourceGroupNames,
    
    [Parameter(Mandatory=$True)]
    [String[]] $webAppNames
)

$connectionName = "AzureRunAsConnection"
try
{
    echo "Execution Started"
    # Get the connection "AzureRunAsConnection "
    $servicePrincipalConnection=Get-AutomationConnection -Name $connectionName   
    # "Credentials"
         echo "TenantID: " $servicePrincipalConnection.TenantId
         echo "ApplicationID: " $servicePrincipalConnection.ApplicationId
         $applicationID = $servicePrincipalConnection.ApplicationId
         echo "CertificateThumbprint: " $servicePrincipalConnection.CertificateThumbprint

    "Logging in to Azure..."
    Add-AzureRmAccount `
        -ServicePrincipal `
        -TenantId $servicePrincipalConnection.TenantId `
        -ApplicationId $servicePrincipalConnection.ApplicationId `
        -CertificateThumbprint $servicePrincipalConnection.CertificateThumbprint
    "Login complete."
}
catch {
    if (!$servicePrincipalConnection)
    {
        $errorMessage = "Connection $connectionName not found."
        throw $errorMessage
    } else{
        Write-Error -Message $_.Exception
        throw $_.Exception
    }
}

for($index=0; $index -lt $storageAccountResourceGroupNames.Length; $index++)
{
	# Setting up rotation specific settings
		$storageAccountResourceGroupName = $storageAccountResourceGroupNames[$index]
		$storageAccountName = $storageAccountNames[$index]
		$vaultName = $keyVaultNames[$index]
		$secretName = $secretNames[$index]
		$secretExpirationDate = (Get-Date).AddDays(10)
        $webAppResourceGroupName = $webAppResourceGroupNames[$index]
		$webAppName = $webAppNames[$index]

    # Checking if Azure Automation account has approperiate access on Key Vault
    try
    {
        $getKeyVaultSecret = Get-AzureKeyVaultSecret -VaultName $vaultName -Name $secretName | Select SecretValueText, ContentType
        echo "I am able to connect to Key Vault and pull out specified Secret Value. Get permissions are available ..."

        $encryptedConnection = ConvertTo-SecureString $getKeyVaultSecret.SecretValueText -AsPlainText -Force
        Set-AzureKeyVaultSecret -VaultName $vaultName -Name $secretName -SecretValue $encryptedConnection -ContentType $getKeyVaultSecret.ContentType
        echo "I am able to set the specified Secret value in Key Vault. Set permissions are available..."
    }
    catch
    {
            Write-Error -Message $_.Exception
            throw $_.Exception
    }

		$storageAccountKeys = Get-AzureRmStorageAccountKey -Name $storageAccountName -ResourceGroupName $storageAccountResourceGroupName

		"<<<...... Encryption: Key2 Started"
    		$buildConnectionString2 = "DefaultEndpointsProtocol=https;AccountName="+$storageAccountName+";AccountKey="+$storageAccountKeys[1].Value+";EndpointSuffix=core.windows.net"
    		$encryptedConnection2 = ConvertTo-SecureString $buildConnectionString2 -AsPlainText -Force
    		"Connection2 Value is: $buildConnectionString2"
		"Encryption: Key2 Completed ......>>>"

		"<<<...... Store: Key2 Started"
    		$secret = Set-AzureKeyVaultSecret -VaultName $vaultName -Name $secretName -SecretValue $encryptedConnection2 -ContentType 'text/plain' #-Expires $secretExpirationDate
            if ($secret -eq $null) 
            {
                throw "Could not update Key Vault Secret $secretName" 
            } 
            		"Store: Key2 Completed ......>>>"

		"<<<...... Restart: Azure Functions Started"
    		Invoke-AzureRmResourceAction -ResourceType Microsoft.Web/sites -ResourceName $webAppName -Action restart -ApiVersion 2016-08-01 -Force -ResourceGroupName $webAppResourceGroupName
		"Restart: Azure Functions Completed ......>>>"

		"<<<...... Regenerate: Key1 Started"
    		New-AzureRmStorageAccountKey -Name $storageAccountName -KeyName "key1" -Verbose -ResourceGroupName $storageAccountResourceGroupName
		"Regenerate: Key1 Completed ......>>>"

		$storageAccountKeys = Get-AzureRmStorageAccountKey -Name $storageAccountName -ResourceGroupName $storageAccountResourceGroupName

		"<<<...... Encryption: Key1 Started"
            $buildConnectionString1 = "DefaultEndpointsProtocol=https;AccountName="+$storageAccountName+";AccountKey="+$storageAccountKeys[0].Value+";EndpointSuffix=core.windows.net"
            $encryptedConnection1 = ConvertTo-SecureString $buildConnectionString1 -AsPlainText -Force
            "Connection1 Value is: $buildConnectionString1"
		"Encryption: Key1 Completed ......>>>"

		"<<<...... Store: Key1 Started"
    		$secret = Set-AzureKeyVaultSecret -VaultName $vaultName -Name $secretName -SecretValue $encryptedConnection1 -ContentType 'text/plain' #-Expires $secretExpirationDate
            if ($secret -eq $null) 
            {
                throw "Could not update Key Vault Secret $secretName" 
            } 
		"Store: Key1 Completed ......>>>"

		"<<<...... Restart: Azure Functions Started"
    		Invoke-AzureRmResourceAction -ResourceType Microsoft.Web/sites -ResourceName $webAppName -Action restart -ApiVersion 2016-08-01 -Force -ResourceGroupName $webAppResourceGroupName
		"Restart: Azure Functions Completed ......>>>"

		"<<<...... Regenerate: Key2 Started"
    		New-AzureRmStorageAccountKey -Name $storageAccountName -KeyName "key2" -Verbose -ResourceGroupName $storageAccountResourceGroupName
		"Regenerate: Key2 Completed ......>>>"
}