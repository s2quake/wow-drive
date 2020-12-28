@echo off
powershell -executionpolicy remotesigned -File "%~dp0\zip-wtf.ps1"
if not %errorlevel% == 0 pause