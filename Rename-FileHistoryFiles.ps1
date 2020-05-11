param(
    [string]$Path = $(Read-Host -Prompt "No path specified, use current directory ($(Get-Location))?`nYes (default) | No, use this path"),
    [switch]$Silent = $false,
    [switch]$Verbose = $false,
    [switch]$WhatIf = $false
)
$WhatIfPreference = $WhatIf
$regex = [regex]"^(?:(.*) )?\(((?:\d*[ _]){6}\w*)\)(?:\.(.*))?$"

Get-ChildItem $Path -File -Recurse -Force -ErrorAction Ignore | ForEach-Object {
    $match = $regex.Match($_.Name)
    if ($match.Success) {
        if ($Verbose) { Write-Host "Renaming $($_.Name) to $($match.Groups[1]).$($match.Groups[3])" }
        Move-Item -LiteralPath $_.FullName -Destination (Join-Path $_.DirectoryName "$($match.Groups[1]).$($match.Groups[3])") -Force
    }
    elseif (!$Silent) { Write-Host "Skipping $($_.FullName)" }
}