param(
    [string]$name
)

if (!([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Warning "Please re-run this script as an Administrator"
    break
}

while ([string]::IsNullOrEmpty($name)) {
    $name = Read-Host -Prompt "`nEnter the name of the package to remove"
}
Write-Host "`n"

[string[]]$packages = (Get-AppxPackage -AllUsers).Where{ $_.PackageFullName.Contains($name) }

if ($packages.Count -eq 0) {
    Write-Warning "No packages found"
    break
}

Write-Host "The following packages matched the name and will be removed:"
$packages.ForEach{ Write-Host $_ }

if ("y".Equals((Read-Host "`n`nContinue? (y/N)"))) {
    $packages.ForEach{ Remove-AppxPackage $_ }
}
else {
    Write-Warning "Aborted"
}