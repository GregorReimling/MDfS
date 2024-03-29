## Snippets to enable/disable Microsoft Defender for Servers at resource level
## The related Blogarticle can be found here: 
## More information about Defender for Servers enablement at resource level can be found here:
## Please note, for the script to work you must already be authenticated to Azure and have rights to the resource group/or the server object to be secured

# Variables to access Azure environment
$subscriptionid = "00000000-0000-0000-0000-0000000000000"
$resourcegroup = "Name-of-resourcegroup-contained-the-server"
$vmname = "AzureServerName"
$url = "https://management.azure.com/subscriptions/$subscriptionid/resourceGroups/$resourcegroup/providers/Microsoft.Compute/virtualMachines/$vmname/providers/Microsoft.Security/pricings/virtualMachines?api-version=2024-01-01"

# Get an set access token for access via REST API
# Authenticated to Azure must be done
$accessToken = (Get-AzAccessToken).Token
$headers = @{
    "Authorization" = "Bearer $accessToken"
    "Content-Type"  = "application/json"
}

# Prepare API request to set Defender for Server plan 1 on selected VM
$body = @{
    location   = $location
    properties = @{
        pricingTier = "Standard"
        subPlan = "P1"
    }
} | ConvertTo-Json

# Execute API request to get the actual Defender for Server plan on selected VM
Invoke-RestMethod -Method Get -Uri $url -Headers $headers | ConvertTo-Json


# Execute API request to enable the selected Defender for Server plan on the VM
Invoke-RestMethod -Method Put -Uri $url -Body $body -Headers $headers | ConvertTo-Json

# Execute API request to disable the selected Defender for Server plan on the VM
Invoke-RestMethod -Method Delete -Uri $url -Body $body -Headers $headers | ConvertTo-Json

