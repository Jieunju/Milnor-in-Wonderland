@echo off
REM Build script: run xelatex twice on main.tex
setlocal
cd /d "%~dp0"

set "XELATEX=E:\texlive\2026\bin\windows\xelatex.exe"
if not exist "%XELATEX%" set "XELATEX=xelatex"

for %%i in (1 2) do (
  "%XELATEX%" -interaction=nonstopmode -halt-on-error -file-line-error main.tex >nul 2>&1
  if errorlevel 1 (
    echo.
    echo [FAIL] pass %%i failed, see main.log
    findstr /B /C:"!" main.log
    exit /b 1
  )
)

echo.
echo [OK] main.pdf built
exit /b 0
