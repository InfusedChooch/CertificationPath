param(
    [string]$Root = (Get-Location).Path
)

$rootPath = (Resolve-Path -LiteralPath $Root).Path
$indexPath = Join-Path $rootPath 'Resource-Index.md'
$certDirs = Get-ChildItem -LiteralPath $rootPath -Directory |
    Where-Object { $_.Name -match '^\d{2}-' } |
    Sort-Object Name

function Convert-ToMarkdownPath {
    param([string]$BasePath, [string]$TargetPath)

    $baseUri = [System.Uri]("$BasePath\")
    $targetUri = [System.Uri]$TargetPath
    $relative = $baseUri.MakeRelativeUri($targetUri).ToString()
    return "./$relative"
}

$lines = [System.Collections.Generic.List[string]]::new()
$generatedAt = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'

$lines.Add('# Resource Index')
$lines.Add('')
$lines.Add("Generated: $generatedAt")
$lines.Add('')
$lines.Add('Run `.\Update-Index.ps1` from this folder to refresh the index.')
$lines.Add('')

foreach ($certDir in $certDirs) {
    $lines.Add("## $($certDir.Name)")
    $lines.Add('')

    foreach ($bucketName in @('Resources-and-PDFs', 'OCR-Dumps')) {
        $bucketPath = Join-Path $certDir.FullName $bucketName
        $files = @()

        if (Test-Path -LiteralPath $bucketPath) {
            $files = Get-ChildItem -LiteralPath $bucketPath -File -Recurse | Sort-Object FullName
        }

        $lines.Add("### $bucketName")
        $lines.Add('')

        if ($files.Count -eq 0) {
            $lines.Add('- (empty)')
            $lines.Add('')
            continue
        }

        foreach ($file in $files) {
            $relativePath = Convert-ToMarkdownPath -BasePath $rootPath -TargetPath $file.FullName
            $modified = $file.LastWriteTime.ToString('yyyy-MM-dd')
            $sizeKb = [math]::Round($file.Length / 1KB, 1)
            $lines.Add("- [$($file.Name)]($relativePath) - $sizeKb KB - updated $modified")
        }

        $lines.Add('')
    }
}

Set-Content -LiteralPath $indexPath -Value $lines -Encoding UTF8
Write-Output "Updated $indexPath"
