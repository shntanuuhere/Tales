$lcovContent = Get-Content -Path "coverage/lcov.info" -Raw
$lines = $lcovContent -split "`n"

$files = @{}
$currentFile = ""
$linesCovered = 0
$linesTotal = 0

foreach ($line in $lines) {
    if ($line.StartsWith("SF:")) {
        $currentFile = $line.Substring(3)
        $files[$currentFile] = @{
            "covered" = 0
            "total" = 0
            "lines" = @{}
        }
    }
    elseif ($line.StartsWith("DA:")) {
        $parts = $line.Substring(3) -split ","
        $lineNumber = [int]$parts[0]
        $hitCount = [int]$parts[1]
        
        $files[$currentFile]["lines"][$lineNumber] = $hitCount
        $files[$currentFile]["total"]++
        
        if ($hitCount -gt 0) {
            $files[$currentFile]["covered"]++
        }
    }
    elseif ($line -eq "end_of_record") {
        $linesCovered += $files[$currentFile]["covered"]
        $linesTotal += $files[$currentFile]["total"]
    }
}

$totalCoverage = 0
if ($linesTotal -gt 0) {
    $totalCoverage = [math]::Round(($linesCovered / $linesTotal) * 100, 2)
}

# Create HTML report
$html = @"
<!DOCTYPE html>
<html>
<head>
    <title>Flutter Test Coverage Report</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        h1 { color: #333; }
        .summary { margin-bottom: 20px; padding: 10px; background-color: #f5f5f5; border-radius: 5px; }
        .file-list { margin-bottom: 20px; }
        .file { margin-bottom: 10px; padding: 10px; background-color: #f9f9f9; border-radius: 5px; }
        .file-name { font-weight: bold; }
        .coverage-good { color: green; }
        .coverage-medium { color: orange; }
        .coverage-bad { color: red; }
        .progress-bar { height: 20px; background-color: #e0e0e0; border-radius: 10px; margin-top: 5px; }
        .progress { height: 100%; border-radius: 10px; }
        .progress-good { background-color: #4CAF50; }
        .progress-medium { background-color: #FF9800; }
        .progress-bad { background-color: #F44336; }
    </style>
</head>
<body>
    <h1>Flutter Test Coverage Report</h1>
    
    <div class="summary">
        <h2>Summary</h2>
        <p>Total Coverage: $totalCoverage%</p>
        <p>Lines Covered: $linesCovered / $linesTotal</p>
        <div class="progress-bar">
            <div class="progress $($totalCoverage -ge 80 ? 'progress-good' : ($totalCoverage -ge 50 ? 'progress-medium' : 'progress-bad'))" style="width: $totalCoverage%;"></div>
        </div>
    </div>
    
    <div class="file-list">
        <h2>Files</h2>
"@

foreach ($file in $files.Keys | Sort-Object) {
    $covered = $files[$file]["covered"]
    $total = $files[$file]["total"]
    $coverage = 0
    if ($total -gt 0) {
        $coverage = [math]::Round(($covered / $total) * 100, 2)
    }
    
    $coverageClass = "coverage-bad"
    if ($coverage -ge 80) {
        $coverageClass = "coverage-good"
    }
    elseif ($coverage -ge 50) {
        $coverageClass = "coverage-medium"
    }
    
    $progressClass = "progress-bad"
    if ($coverage -ge 80) {
        $progressClass = "progress-good"
    }
    elseif ($coverage -ge 50) {
        $progressClass = "progress-medium"
    }
    
    $html += @"
        <div class="file">
            <div class="file-name">$file</div>
            <div class="file-coverage">
                Coverage: <span class="$coverageClass">$coverage%</span> ($covered / $total lines)
                <div class="progress-bar">
                    <div class="progress $progressClass" style="width: $coverage%;"></div>
                </div>
            </div>
        </div>
"@
}

$html += @"
    </div>
</body>
</html>
"@

# Create directory if it doesn't exist
if (-not (Test-Path -Path "coverage/html")) {
    New-Item -Path "coverage/html" -ItemType Directory | Out-Null
}

# Save HTML report
$html | Out-File -FilePath "coverage/html/index.html" -Encoding utf8

Write-Host "Coverage report generated at coverage/html/index.html"
