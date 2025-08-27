#!/usr/bin/env pwsh
param(
	[string]$In,
	[switch]$Verbose
)


function debug {
    if (-not $Verbose) { return }
    Write-Host '[DEBUG]: ' $args
}



# Path to your CSV
$csvPath = $in

# Import CSV and select the SearchCode column (adjust if your column name is different)
$codes = Import-Csv $csvPath | ForEach-Object { [int]$_."SearchCode" }

# Sort and deduplicate codes
$codes = $codes | Sort-Object -Unique

$ranges = @()
$start = $null
$prev = $null

foreach ($code in $codes) {
    if ($start -eq $null) {
        # Initialize first value
        $start = $code
        $prev = $code
        continue
    }

    if ($code -eq $prev + 1) {
        # Still in a sequence
        $prev = $code
        continue
    }
    else {
        # Sequence broke, add previous range
        if ($start -eq $prev) {
            $ranges += "$start"
        } else {
            $ranges += "$start-$prev"
        }
        # Start new sequence
        $start = $code
        $prev = $code
    }
}

# Add the final range
if ($start -ne $null) {
    if ($start -eq $prev) {
        $ranges += "$start"
    } else {
        $ranges += "$start-$prev"
    }
}

# Output as a string
$rangesString = $ranges -join ", "
$rangesString
