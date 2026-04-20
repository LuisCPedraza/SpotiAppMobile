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
        $response = Invoke-RestMethod -Method Get -Uri $url -Headers @{ "Authorization" = "Bearer $token" }
        Write-Host "Status: 200"
        $json = $response | ConvertTo-Json -Depth 5
        if ($json.Length -gt 300) { $json = $json.Substring(0, 300) }
        Write-Host "Body: $json"
    } catch {
        if ($_.Exception.Response) {
             $resp = $_.Exception.Response
             Write-Host "Status: $($resp.StatusCode.Value__)"
        } elseif ($_.ErrorDetails) {
             # Invoke-RestMethod puts the body in ErrorDetails when it fails
             Write-Host "ErrorDetails found"
        }
        
        # In PowerShell Core Invoke-RestMethod, the response body for a failed request
        # can often be found in the exception's ErrorDetails or Response
        try {
            # Try to get the raw stream if possible
            $stream = $_.Exception.Response.GetResponseStream()
            if ($stream) {
                $reader = New-Object System.IO.StreamReader($stream)
                $body = $reader.ReadToEnd()
                if ($body.Length -gt 300) { $body = $body.Substring(0, 300) }
                Write-Host "Error Body: $body"
            }
        } catch {
            Write-Host "Error Body: Could not read body ($($_.Exception.Message))"
        }
        
        if ($_.ErrorDetails.Message) {
            $msg = $_.ErrorDetails.Message
            if ($msg.Length -gt 300) { $msg = $msg.Substring(0, 300) }
            Write-Host "Message: $msg"
        }
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
