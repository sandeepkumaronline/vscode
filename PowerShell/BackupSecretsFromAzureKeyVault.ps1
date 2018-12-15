<#
.SYNOPSIS 
Takes a backup of Key Vault secrets and stores in a local folder.

.DESCRIPTION

.NOTES

.PARAMETER KeyVaultName
KeyVault from where secrets will be downloaded

.PARAMETER KeyVaultLocalRootFolder
Local directory under which a new folder gets created/updated in which secrets will be downloaded as .blob files

.EXAMPLE
.\BackupSecretsFromAzureKeyVault.ps1  -KeyVaultName InventorySitKV -KeyVaultLocalRootFolder D:\

#>

param 
(
    [Parameter(Mandatory=$true)] 
    [string]$KeyVaultName,

    [Parameter(Mandatory=$true)]    
    [string]$KeyVaultLocalRootFolder
)
$kv = Get-AzureRmKeyVault -VaultName $KeyVaultName
if($kv -eq $null)
{
    $errmsg = "Get KeyVault failed !!"
    Write-Warning $errmsg
    throw $errmsg
}
else
{
    $secrets = Get-AzureKeyVaultSecret -VaultName $kv.VaultName
    if($secrets -eq $null -or $secrets.Count -lt 1)
    {
        $errmsg = "Get Secrets failed !!"
        Write-Warning $errmsg
        throw $errmsg
    }
    else
    {
        $keyVaultLocalFolder = $KeyVaultLocalRootFolder+'\'+$KeyVaultName
        If (Test-Path $keyVaultLocalFolder){
	        Remove-Item $keyVaultLocalFolder -Recurse -Force
        }

        New-Item $keyVaultLocalFolder -ItemType directory -Force

        foreach($secret in $secrets)
        {
			$contentType=$secret.ContentType
			if($contentType -ne "application/x-pkcs12")
			{
				$outputFile = $keyVaultLocalFolder+'\'+$secret.Name
				Backup-AzureKeyVaultSecret -VaultName $KeyVaultName -Name $secret.Name -OutputFile $outputFile
			}
        }
    }
}