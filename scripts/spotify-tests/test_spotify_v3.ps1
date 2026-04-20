$clientId = "6bd405bb29144e76a312217041f2e1df"
$clientSecret = "96a036080fbd4bbda6d86102036f945e"
$authString = "$($clientId):$($clientSecret)"
$bytes = [System.Text.Encoding]::UTF8.GetBytes($authString)
$encodedAuth = [Convert]::ToBase64String($bytes)
$headers = @{ "Authorization" = "Basic $encodedAuth"; "Content-Type"  = "application/x-www-form-urlencoded" }
$body = "grant_type=client_credentials"
try {
    $tokenResponse = Invoke-RestMethod -Method Post -Uri "https://accounts.spotify.com/api/token" -Headers $headers -Body $body
    $accessToken = $tokenResponse.access_token
    $apiHeaders = @{ "Authorization" = "Bearer $accessToken" }
    Write-Host "New Releases (Expected 403):"
    try {
        $r = Invoke-RestMethod -Method Get -Uri "https://api.spotify.com/v1/browse/new-releases?limit=5" -Headers $apiHeaders
        Write-Host "Success!"
    } catch { Write-Host "Error: $($_.Exception.Message)" }
    
    Write-Host "`nSearch (Expected 200):"
    try {
        $s = Invoke-RestMethod -Method Get -Uri "https://api.spotify.com/v1/search?q=queen&type=track&limit=2" -Headers $apiHeaders
        $s.tracks.items | ForEach-Object { "$($_.name) - $($_.artists[0].name)" }
    } catch { Write-Host "Error: $($_.Exception.Message)" }
} catch { Write-Host "Auth Error: $($_.Exception.Message)" }
