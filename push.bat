@echo off
REM One-click publish to https://github.com/Jieunju/Milnor-in-Wonderland
REM Requires: Git for Windows installed and on PATH.
setlocal
cd /d "%~dp0"

where git >nul 2>&1
if errorlevel 1 (
  echo.
  echo [FAIL] git not found. Install Git for Windows first:
  echo        https://git-scm.com/download/win
  echo        Then reopen the terminal and run this file again.
  exit /b 1
)

git config user.name  >nul 2>&1 || git config user.name  "Jieunju"
git config user.email >nul 2>&1 || git config user.email "humble2001@berkeley.edu"

if not exist ".git" (
  git init
  git branch -M main
)

git remote get-url origin >nul 2>&1
if errorlevel 1 (
  git remote add origin https://github.com/Jieunju/Milnor-in-Wonderland.git
) else (
  git remote set-url origin https://github.com/Jieunju/Milnor-in-Wonderland.git
)

git add -A
git commit -m "Add Grassmannian non-embedding paper (LaTeX source + PDF)"
git push -u origin main

if errorlevel 1 (
  echo.
  echo [FAIL] push failed. Sign in to GitHub when prompted, or check the error above.
  exit /b 2
)

echo.
echo [OK] pushed to https://github.com/Jieunju/Milnor-in-Wonderland
exit /b 0
