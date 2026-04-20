$clientId = "6bd405bb29144e76a312217041f2e1df"
$clientSecret = "96a036080fbd4bbda6d86102036f945e"
$authString = "$($clientId):$($clientSecret)"
$bytes = [System.Text.Encoding]::UTF8.GetBytes($authString)
$encodedAuth = [Convert]::ToBase64String($bytes)
$headers = @{ "Authorization" = "Basic $encodedAuth"; "Content-Type"  = "application/x-www-form-urlencoded" }
$body = "grant_type=client_credentials"
try {
    $tokenResponse = Invoke-RestMethod -Method Post -Uri "https://accounts.spotify.com/api/token" -Headers $headers -Body $body
    Write-Host "Token request successful."
    $accessToken = $tokenResponse.access_token
    if ($accessToken) {
        Write-Host "Access Token obtained."
        $apiHeaders = @{ "Authorization" = "Bearer $accessToken" }
        Write-Host "Testing search endpoint instead..."
        $searchResponse = Invoke-RestMethod -Method Get -Uri "https://api.spotify.com/v1/search?q=remaster%2520track%3ADrowning%20artist%3AAvenged%20Sevenfold&type=track" -Headers $apiHeaders
        Write-Host "Search successful. Found $($searchResponse.tracks.total) results."
        $searchResponse.tracks.items | Select-Object -First 3 | ForEach-Object { "$($_.name) - $($_.artists[0].name)" }
    }
} catch {
    Write-Host "Error: $($_.Exception.Message)"
}
