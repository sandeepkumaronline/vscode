## Install the DevOps Kit
# iwr 'https://aka.ms/azsk/install.ps1' -UseBasicParsing | iex

# Login to Azure Account
Connect-AzureRmAccount
Login-AzureRmAccount

# Select subscrpition
Set-AzureRmContext -SubscriptionId ($subscriptionID = Get-AzureRmSubscription -SubscriptionName "MES Development").Id








