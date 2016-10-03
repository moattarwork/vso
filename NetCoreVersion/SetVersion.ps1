
[cmdletbinding()]

param(
    [string] $SourceFolder, 
    [string] $BuildNumber = "1.0.0")

function Set-PackageVersion([String]$version, [String]$sourceFolder, [String]$filename = "project.json") {
    
    Write-Host "Start to change the package version to" $version

    $filePath = Join-Path $sourceFolder $filename

    $fileExists = [IO.File]::Exists( $filePath );
    if (!$fileExists -or [String]::IsNullOrWhiteSpace($version)) {

        Write-Host "Invalid file or version =>" $version "," $filePath
        return;
    } 

    Write-Host "read file from" $filePath
    $json = Get-Content -Raw $filePath | ConvertFrom-Json
    
    Write-Host "Set the version to" $version
    $json.version = $version

    Write-Host "Save the content to" $filePath
    $json | ConvertTo-Json -depth 20 | Set-Content $filePath
}

if ([String]::IsNullOrWhiteSpace($SourceFolder)) {
    $SourceFolder = Join-Path (Get-Location) ""
}

$fileVersion = $($BuildNumber + "-*")

Set-PackageVersion -version $fileVersion -sourceFolder $SourceFolder
