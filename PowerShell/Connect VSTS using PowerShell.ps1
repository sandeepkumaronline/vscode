Param(
   [string]$vstsAccount = "microsoftit",
   [string]$projectName = "Supply Chain Staging",
   [string]$user = "sandeek",
   [string]$token = "sk7hgejj7gq262zdnc45klho7dppyxf46kxr4jok5podqnhr33lq"
)

Write-Verbose "Parameter Values"
foreach($key in $PSBoundParameters.Keys)
{
     Write-Verbose ("  $($key)" + ' = ' + $PSBoundParameters[$key])
}
 
# Base64-encodes the Personal Access Token (PAT) appropriately
$base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f $user,$token)))
 
# Construct the REST URL to obtain all releases
$uri = "https://$($vstsAccount).visualstudio.com/$($projectName)/_release"

# Invoke the REST call and capture the results
$result = Invoke-RestMethod -Uri $uri -Method Get -ContentType "application/json" -Headers @{Authorization=("Basic {0}" -f $base64AuthInfo)}
 
# This call should only provide a single result; Capture the Build ID from the result
if ($result.count -eq 0)
{
     throw "Unable to pull release information"
}

$result

#($result | ConvertFrom-Json).results | ConvertTo-Csv -NoTypeInformation #| Set-Content "D:\EngineYard\releases.csv"
