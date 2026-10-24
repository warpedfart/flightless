@echo off
if not exist "%~dp0electron-win\electron.exe" (
  echo Electron is missing: run setup.bat first
  pause
  exit /b 1
)
start "" "%~dp0electron-win\electron.exe" "%~dp0app" %*
