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

Write-Host "Test Coverage Summary"
Write-Host "--------------------"
Write-Host "Lines Covered: $linesCovered / $linesTotal"
Write-Host "Total Coverage: $totalCoverage%"

if ($totalCoverage -ge 80) {
    Write-Host "Status: GOOD (>= 80%)" -ForegroundColor Green
} elseif ($totalCoverage -ge 50) {
    Write-Host "Status: ACCEPTABLE (>= 50%)" -ForegroundColor Yellow
} else {
    Write-Host "Status: NEEDS IMPROVEMENT (< 50%)" -ForegroundColor Red
}
