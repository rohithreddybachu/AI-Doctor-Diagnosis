@echo off
setlocal
cd /d "%~dp0"

where node >nul 2>nul
if %errorlevel% equ 0 (
  node server.js
  exit /b %errorlevel%
)

set "CODEX_NODE=%LOCALAPPDATA%\OpenAI\Codex\bin\node.exe"
if exist "%CODEX_NODE%" (
  "%CODEX_NODE%" server.js
  exit /b %errorlevel%
)

set "RUNTIME_NODE=%USERPROFILE%\.cache\codex-runtimes\codex-primary-runtime\dependencies\node\bin\node.exe"
if exist "%RUNTIME_NODE%" (
  "%RUNTIME_NODE%" server.js
  exit /b %errorlevel%
)

echo Node.js was not found.
echo Install Node.js, then run this file again.
pause
