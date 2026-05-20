$paths = @(
    $env:TEMP,
    "C:\Windows\Temp",
    "C:\Windows\Prefetch",
    "C:\Windows\SoftwareDistribution\Download"
)

foreach ($path in $paths) {
    if (Test-Path $path) {
        try {
            $files = Get-ChildItem -Path $path -Recurse -File -ErrorAction SilentlyContinue
            $size = ($files | Measure-Object -Property Length -Sum).Sum / 1MB
            Write-Host "$path : $([math]::Round($size, 2)) MB"
        } catch {
            Write-Host "$path : Access Denied or Error"
        }
    } else {
        Write-Host "$path : Not Found"
    }
}
