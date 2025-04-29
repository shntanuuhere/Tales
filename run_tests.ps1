# Clean the project
Write-Host "Cleaning project..." -ForegroundColor Cyan
flutter clean

# Get dependencies
Write-Host "Getting dependencies..." -ForegroundColor Cyan
flutter pub get

# Generate mocks
Write-Host "Generating mocks..." -ForegroundColor Cyan
flutter pub run build_runner build --delete-conflicting-outputs

# Run tests with coverage
Write-Host "Running tests with coverage..." -ForegroundColor Cyan
flutter test --coverage

# Parse coverage report
Write-Host "Parsing coverage report..." -ForegroundColor Cyan
$lcovContent = Get-Content -Path "coverage/lcov.info" -Raw
$lines = $lcovContent -split "`n"

$linesCovered = 0
$linesTotal = 0

foreach ($line in $lines) {
    if ($line.StartsWith("DA:")) {
        $parts = $line.Substring(3) -split ","
        $hitCount = [int]$parts[1]
        
        $linesTotal++
        
        if ($hitCount -gt 0) {
            $linesCovered++
        }
    }
}

$totalCoverage = 0
if ($linesTotal -gt 0) {
    $totalCoverage = [math]::Round(($linesCovered / $linesTotal) * 100, 2)
}

Write-Host "`nTest Coverage Summary" -ForegroundColor Green
Write-Host "--------------------" -ForegroundColor Green
Write-Host "Lines Covered: $linesCovered / $linesTotal" -ForegroundColor White
Write-Host "Total Coverage: $totalCoverage%" -ForegroundColor White

if ($totalCoverage -ge 80) {
    Write-Host "Status: GOOD (>= 80%)" -ForegroundColor Green
} elseif ($totalCoverage -ge 50) {
    Write-Host "Status: ACCEPTABLE (>= 50%)" -ForegroundColor Yellow
} else {
    Write-Host "Status: NEEDS IMPROVEMENT (< 50%)" -ForegroundColor Red
}

Write-Host "`nTest run complete!" -ForegroundColor Cyan
