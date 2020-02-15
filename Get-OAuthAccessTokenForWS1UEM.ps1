### VARIABLES ###
# Create WS1 UEM OAuth client ID and secret from UEM admin console > Groups & Settings > Configurations > OAuth Client Management
# Direct URL Example:  https://ws1-uem-admin-console.company.com/AirWatch/aa/#/configurations/oauth-clients
$client_id = "ENTER_CLIENT_ID_HERE"
$client_secret = "ENTER_CLIENT_SECRET_HERE"

# Create WS1 UEM API key from UEM admin console > Groups & Settings > All Settings > System > Advanced > API > REST API
# Direct URL Example:  https://ws1-uem-admin-console.company.com/AirWatch/#/AirWatch/Settings/RESTApi
$api_key = "ENTER_API_TOKEN_HERE"

# Regional Token Request URIs
#Ensure there is no trailing '/' otherwise a 404 will be returned
$uat_access_token_url = "https://uat.uemauth.vmwservices.com/connect/token"
$na_access_token_url = "https://na.uemauth.vmwservices.com/connect/token"
$emea_access_token_url = "https://emea.uemauth.vmwservices.com/connect/token"
$apac_access_token_url = "https://apac.uemauth.vmwservices.com/connect/token"

### BEGIN ###
# Request an access token
$body = @{
    grant_type = "client_credentials"
    client_id = $client_id
    client_secret = $client_secret
}
$response = Invoke-WebRequest -Method Post -Uri $uat_access_token_url -Body $body
$response = $response | ConvertFrom-Json

# Perform WS1 UEM API call with access token
$headers = @{
    "aw-tenant-code" = $api_key
    Authorization = "Bearer $($response.access_token)"
    Accept = "application/json"
}
$api_url = "https://as135.awmdm.com/API/system/info"
Invoke-RestMethod -Uri $api_url -Method Get -Headers $headers