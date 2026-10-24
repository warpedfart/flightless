@echo off
rem downloads Electron for Flight; run once before run.bat
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0tools\fetch-electron.ps1"
pause
