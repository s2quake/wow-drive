@echo off
powershell -executionpolicy remotesigned -File "%~dp0\unzip-addons.ps1"
if not %errorlevel% == 0 pause