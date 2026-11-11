# ============================================================================
#  把本工程提交到 GitHub：Jieunju/Milnor-in-Wonderland
#  用法： powershell -ExecutionPolicy Bypass -File push.ps1
#  前置： 已安装 Git for Windows（https://git-scm.com/download/win）
#  说明： 首次运行会 init 仓库、加 remote、提交并推送；
#         之后每次运行就是 add + commit + push。
# ============================================================================
param(
    [string]$Remote = 'https://github.com/Jieunju/Milnor-in-Wonderland.git',
    [string]$Branch = 'main',
    [string]$Message = ''
)

$ErrorActionPreference = 'Stop'
Set-Location $PSScriptRoot

# ---- 1. 检查 git ----
$git = (Get-Command git -ErrorAction SilentlyContinue).Source
if (-not $git) {
    $cand = 'C:\Program Files\Git\cmd\git.exe'
    if (Test-Path $cand) { $git = $cand }
}
if (-not $git) {
    Write-Host '未找到 git。请先安装 Git for Windows，然后重开终端再运行本脚本。' -ForegroundColor Red
    Write-Host '下载：https://git-scm.com/download/win'
    exit 1
}

# ---- 2. 身份（缺省时补上，仅本仓库有效） ----
if (-not (git config user.name))  { git config user.name  'Jieunju' }
if (-not (git config user.email)) { git config user.email 'humble2001@berkeley.edu' }

# ---- 3. 初始化 / 接上远端 ----
if (-not (Test-Path (Join-Path $PSScriptRoot '.git'))) {
    git init | Out-Null
    git branch -M $Branch
}
$hasRemote = (git remote) -contains 'origin'
if (-not $hasRemote) { git remote add origin $Remote }
git remote set-url origin $Remote

# ---- 4. 先与远端对齐（远端已有内容时不要强推） ----
git fetch origin $Branch 2>$null
if ($LASTEXITCODE -eq 0) {
    git pull --rebase --allow-unrelated-histories origin $Branch 2>$null
}

# ---- 5. 提交 ----
git add -A
$staged = (git diff --cached --name-only | Measure-Object).Count
if ($staged -eq 0) {
    Write-Host '没有需要提交的改动。' -ForegroundColor Yellow
} else {
    if (-not $Message) {
        $Message = 'Sync paper: ' + (Get-Date -Format 'yyyy-MM-dd HH:mm')
    }
    git commit -m $Message | Out-Null
    Write-Host "已提交 $staged 个文件。" -ForegroundColor Green
}

# ---- 6. 推送 ----
git push -u origin $Branch
if ($LASTEXITCODE -eq 0) {
    Write-Host "推送完成：$Remote （分支 $Branch）" -ForegroundColor Green
} else {
    Write-Host '推送失败。常见原因：未登录 GitHub 凭据，或本地与远端冲突。' -ForegroundColor Red
    Write-Host '可运行 `git push -u origin main` 查看详细报错。'
    exit 2
}
