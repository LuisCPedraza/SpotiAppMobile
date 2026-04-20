function Get-SpotifyToken {
    $clientId = "6bd405bb29144e76a312217041f2e1df"
    $clientSecret = "96a036080fbd4bbda6d86102036f945e"
    $authString = "$($clientId):$($clientSecret)"
    $encodedAuth = [Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($authString))
    $headers = @{ "Authorization" = "Basic $encodedAuth"; "Content-Type" = "application/x-www-form-urlencoded" }
    $body = "grant_type=client_credentials"
    $response = Invoke-RestMethod -Method Post -Uri "https://accounts.spotify.com/api/token" -Headers $headers -Body $body
    return $response.access_token
}

function Test-Endpoint {
    param($url, $token)
    Write-Host "Testing: $url"
    try {
        $response = Invoke-WebRequest -Uri $url -Headers @{ "Authorization" = "Bearer $token" } -Method Get
        Write-Host "Status: $($response.StatusCode)"
        $content = $response.Content
        if ($content.Length -gt 300) { $content = $content.Substring(0, 300) }
        Write-Host "Body: $content"
    } catch {
        $status = $_.Exception.Response.StatusCode.Value__
        Write-Host "Status: $status"
        $reader = New-Object System.IO.StreamReader($_.Exception.Response.GetResponseStream())
        $body = $reader.ReadToEnd()
        if ($body.Length -gt 300) { $body = $body.Substring(0, 300) }
        Write-Host "Error Body: $body"
    }
    Write-Host "-----------------------------------"
}

$token = Get-SpotifyToken
$endpoints = @(
    "https://api.spotify.com/v1/search?q=mana&type=artist&limit=20",
    "https://api.spotify.com/v1/search?q=mana&type=artist&limit=10",
    "https://api.spotify.com/v1/search?q=artist:mana&type=artist&limit=10",
    "https://api.spotify.com/v1/search?q=artist:shakira&type=track&market=US&limit=20",
    "https://api.spotify.com/v1/search?q=artist:shakira&type=track&market=US&limit=10",
    "https://api.spotify.com/v1/artists/0EmeFodog0BfCgMzAIvKQp/top-tracks?market=US"
)

foreach ($url in $endpoints) {
    Test-Endpoint -url $url -token $token
}
