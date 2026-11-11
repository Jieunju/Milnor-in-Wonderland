# 构建脚本
# 用法： pwsh -File build.ps1            （编译两遍）
#        pwsh -File build.ps1 -Clean     （先清理辅助文件）
param([switch]$Clean)

$ErrorActionPreference = 'Stop'
Set-Location $PSScriptRoot

$xelatex = 'E:\texlive\2026\bin\windows\xelatex.exe'
if (-not (Test-Path $xelatex)) {
    $cmd = Get-Command xelatex -ErrorAction SilentlyContinue
    if (-not $cmd) { throw 'xelatex 未找到：请确认 TeX Live 安装路径。' }
    $xelatex = $cmd.Source
}

if ($Clean) {
    Get-ChildItem -File | Where-Object {
        $_.Extension -in '.aux', '.log', '.out', '.toc', '.synctex.gz'
    } | Remove-Item -Force
}

for ($i = 1; $i -le 2; $i++) {
    & $xelatex -interaction=nonstopmode -halt-on-error -file-line-error main.tex |
        Out-Null
    if ($LASTEXITCODE -ne 0) {
        Write-Host "第 $i 遍编译失败，错误摘要：" -ForegroundColor Red
        Select-String -Path main.log -Pattern '^!|\.tex:\d+:' |
            Select-Object -First 20 | ForEach-Object { $_.Line }
        exit 1
    }
}

$pages = (Select-String -Path main.log -Pattern 'Output written on main\.pdf \((\d+) pages').Matches.Groups[1].Value
$over  = (Select-String -Path main.log -Pattern 'Overfull \\hbox' -AllMatches).Count
$undef = (Select-String -Path main.log -Pattern 'undefined' -AllMatches).Count

Write-Host "OK    main.pdf 已生成：$pages 页" -ForegroundColor Green
Write-Host "       overfull hbox : $over"
Write-Host "       undefined ref : $undef"
if ($over -gt 0 -or $undef -gt 0) { exit 2 }
