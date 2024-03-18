param(
    [Parameter(Mandatory=$true)] [String] $databricksWorkspaceResourceId,
    [Parameter(Mandatory=$true)] [String] $databricksWorkspaceUrl,
    [Parameter(Mandatory=$false)] [int] $tokenLifeTimeSeconds = 300,
    [Parameter(Mandatory=$false)] [String] $spid ,
    [Parameter(Mandatory=$false)] [String] $spkey
)

$azureDatabricksresourceId = '2ff814a6-3304-4ab8-85cb-cd0e6f879c1d'
$aadtokenendpoint = 'https://login.microsoftonline.com/8c2cffcd-8683-40e2-963d-80812966a1b7/oauth2/v2.0/token'
$resourceendpoint = 'https://login.microsoftonline.com/8c2cffcd-8683-40e2-963d-80812966a1b7/oauth2/token'
$databricksendpoint = "https://$databricksWorkspaceUrl/api/2.0/token/create"
$azureresourcemanagerendpoint = 'https://management.core.windows.net'


$azureDatabricksPrincipalId = '2ff814a6-3304-4ab8-85cb-cd0e6f879c1d'
Write-Host "Inside PS1"
$headers = @{'Content-Type'='application/x-www-form-urlencoded'}
$method = 'POST'
$url = $aadtokenendpoint
$body = @{
    'client_id'= $spid; #'9e61579c-d1bb-4299-ba46-6db7e7cbbefc'; 
    'grant_type'='client_credentials'; 
    'scope'='2ff814a6-3304-4ab8-85cb-cd0e6f879c1d/.default'; 
    'client_secret'= $spkey #'s9a8Q~a0Hb6v0libOZA45FOZBJDrT0Ak3lDt8duk'
    }

$req1 =Invoke-WebRequest $url -Method $method -Headers $headers -Body $body

$spbearerToken = ($req1.Content | ConvertFrom-Json).access_token
$url2 = $resourceendpoint
$body = @{
    'client_id'=  $spid; #'9e61579c-d1bb-4299-ba46-6db7e7cbbefc'; 
    'grant_type'='client_credentials'; 
    'resource'='https://management.core.windows.net/'; 
    'client_secret'= $spkey #'s9a8Q~a0Hb6v0libOZA45FOZBJDrT0Ak3lDt8duk'
    }

$req2 =Invoke-WebRequest $url2 -Method $method -Headers $headers -Body $body

#$accessToken = (az account get-access-token --resource https://management.core.windows.net/ | ConvertFrom-Json) | Select-Object -ExpandProperty accessToken
$accessToken = ($req2.Content | ConvertFrom-Json).access_token


$headers = @{}
$headers["Authorization"] = "Bearer $spbearerToken"
$headers["X-Databricks-Azure-SP-Management-Token"] = $accessToken
$headers["x-Databricks-Azure-Workspace-Resource-Id"] = $databricksWorkspaceResourceId

$json = @{
    "lifetime_seconds" = $tokenLifeTimeSeconds
}

# Define the endpoint URL
$url = "https://$databricksWorkspaceUrl/api/2.0/token/create"

# Convert the JSON body to a string
$bodyString = ($json | ConvertTo-Json)

# Log the request details
Write-Host "Preparing request to Databricks API:"
Write-Host "URL: $url"
Write-Host "Method: POST"
Write-Host "Headers:"
$headers.GetEnumerator() | ForEach-Object { Write-Host "- $($_.Key): $($_.Value)" }
Write-Host "Body: $bodyString"

Write-Host "Sending request to Databricks API..."
try
{
  $req = Invoke-WebRequest -Uri $url -Body ($json | ConvertTo-Json) -ContentType "application/json" -Headers $headers -Method POST
}catch {
    # Log the exception details
    Write-Host "An error occurred: $($_.Exception.Message)"
    Write-Host "StackTrace: $($_.Exception.StackTrace)"
}
$bearerToken = ($req.Content | ConvertFrom-Json).token_value

Write-Host "Received bearer token: $bearerToken"

return $bearerToken
