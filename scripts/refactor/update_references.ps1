$files = Get-ChildItem -Path lib -Recurse -File -Include *.dart
$changedFiles = New-Object System.Collections.Generic.List[string]

foreach ($file in $files) {
    $content = Get-Content $file.FullName -Raw
    $newContent = $content

    $newContent = $newContent -replace 'providers/movies_provider\.dart', 'providers/songs_provider.dart'
    $newContent = $newContent -replace 'MoviesProvider', 'SongsProvider'
    $newContent = $newContent -replace 'moviesProvider', 'songsProvider'
    $newContent = $newContent -replace 'onDisplayMovies', 'onDisplaySongs'
    $newContent = $newContent -replace 'List<Movie>', 'List<Song>'
    $newContent = $newContent -replace 'final Movie', 'final Song'
    $newContent = $newContent -replace 'arguments\.movie', 'arguments.song'

    if ($file.FullName -like "*card_swiper.dart") {
        $newContent = $newContent -replace 'movies', 'songs'
        $newContent = $newContent -replace '\bmovie\b', 'song'
    }

    if ($content -ne $newContent) {
        $newContent | Set-Content $file.FullName
        $changedFiles.Add($file.FullName)
    }
}

if ($changedFiles.Count -gt 0) {
    Write-Host "Changed Files:"
    $changedFiles | ForEach-Object { Write-Host $_ }
} else {
    Write-Host "No files were changed."
}
