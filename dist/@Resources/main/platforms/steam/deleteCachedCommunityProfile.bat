@echo off
cls
echo Deleting cached Steam community profile
cd "%~dp0"
cd ..\..\..\cache
if not exist "%cd%\steam" mkdir "%cd%\steam"
if not exist "%cd%\steam_shortcuts" mkdir "%cd%\steam_shortcuts"
cd steam
set "communityProfile="%cd%\communityProfile.txt""
if exist %communityProfile% del %communityProfile%
::pause
