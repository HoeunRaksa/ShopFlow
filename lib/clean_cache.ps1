$paths = @(
    $env:TEMP,
    "C:\Windows\Temp"
)

foreach ($path in $paths) {
    if (Test-Path $path) {
        Write-Host "Cleaning $path..." -ForegroundColor Cyan
        $items = Get-ChildItem -Path $path -Recurse -ErrorAction SilentlyContinue
        foreach ($item in $items) {
            try {
                Remove-Item -Path $item.FullName -Force -Recurse -ErrorAction Stop
                # Write-Host "Deleted: $($item.FullName)"
            } catch {
                # This is normal for files in use
                # Write-Host "Skipped (In Use): $($item.FullName)" -ForegroundColor Yellow
            }
        }
        Write-Host "Finished cleaning $path." -ForegroundColor Green
    }
}

Write-Host "`nCleanup Complete!" -ForegroundColor Cyan
