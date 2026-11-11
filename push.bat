@echo off
REM Publish this folder to https://github.com/Jieunju/Milnor-in-Wonderland
REM Safe to run repeatedly. Works even if the remote already has a web-upload commit.
setlocal
cd /d "%~dp0"

REM --- 1. locate git ---
set "GIT=git"
where git >nul 2>&1
if errorlevel 1 (
  if exist "D:\Git\cmd\git.exe" (
    set "GIT=D:\Git\cmd\git.exe"
  ) else (
    echo [FAIL] git not found. Install Git for Windows or set D:\Git\cmd\git.exe
    exit /b 1
  )
)
"%GIT%" --version

REM --- 2. identity ---
"%GIT%" config user.name  >nul 2>&1 || "%GIT%" config user.name  "Jieunju"
"%GIT%" config user.email >nul 2>&1 || "%GIT%" config user.email "334226582+Jieunju@users.noreply.github.com"

REM --- 3. repo + remote ---
if not exist ".git" (
  "%GIT%" init
  "%GIT%" branch -M main
)
"%GIT%" remote get-url origin >nul 2>&1
if errorlevel 1 (
  "%GIT%" remote add origin https://github.com/Jieunju/Milnor-in-Wonderland.git
) else (
  "%GIT%" remote set-url origin https://github.com/Jieunju/Milnor-in-Wonderland.git
)

REM --- 4. align with remote if it already has commits ---
"%GIT%" fetch origin main >nul 2>&1
if not errorlevel 1 (
  "%GIT%" rev-parse --verify origin/main >nul 2>&1
  if not errorlevel 1 (
    echo [1/3] aligning with origin/main ...
    "%GIT%" reset --soft origin/main
  )
)

REM --- 5. stage and commit ---
"%GIT%" add -A
"%GIT%" diff --cached --quiet
if errorlevel 1 (
  "%GIT%" commit -m "Add full LaTeX sources (sections/) and git attributes" || goto :fail
) else (
  echo [2/3] nothing new to commit
)

REM --- 6. push ---
echo [3/3] pushing ...
"%GIT%" push -u origin main || goto :fail

echo.
echo [OK] https://github.com/Jieunju/Milnor-in-Wonderland
exit /b 0

:fail
echo.
echo [FAIL] see the message above. If it asks for login, choose "Sign in with your browser".
exit /b 2
