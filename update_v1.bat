::Author: KeyWeeUsr @ https://github.com/KeyWeeUsr
::Updater for KivyInstaller v1.0
::Version: 1.0
::Bitsadmin is available since winXP SP2
::If it is not available, download and install to C:\Windows
::https://www.microsoft.com/en-us/download/details.aspx?id=18546
@echo off
setlocal ENABLEDELAYEDEXPANSION
set /a line=0
for /f "delims=" %%l in ('type "%~dp0kivy.bat"') do (
    set /a line=line+1
    if !line! equ 2 (
        set version=%%l
        set version=!version:~11!
    )
)
if not %version%==1.0 (
    echo The Updater is not suitable for your version^^! & echo The Updater is not suitable for your version^^! > "%~dp0update_v1.log"
    echo %version% ^> 1.0
    goto end
)
echo Preparing config file... & echo Preparing config file... > "%~dp0update_v1.log"
set /a line=0
for /f "skip=8 delims=" %%l in ('type "%~dp0kivy.bat"') do (
    if !line! lss 13 (
        set /a line=line+1
        %%l
    )
)
echo Writing to config file... & echo Writing to config file... >> "%~dp0update_v1.log"
(echo cp=%cp%) > "%~dp0config.kivyinstaller"
(echo cpwhl=%cpwhl%) >> "%~dp0config.kivyinstaller"
(echo stable=%stable%) >> "%~dp0config.kivyinstaller"
(echo cp2=%cp2%) >> "%~dp0config.kivyinstaller"
(echo cp3=%cp3%) >> "%~dp0config.kivyinstaller"
(echo py3=%py3%) >> "%~dp0config.kivyinstaller"
(echo arch=%arch%) >> "%~dp0config.kivyinstaller"
(echo py2=%py2%) >> "%~dp0config.kivyinstaller"
(echo pyversion=%pyversion%) >> "%~dp0config.kivyinstaller"
(echo gstreamer=%gstreamer%) >> "%~dp0config.kivyinstaller"
(echo master=%master%) >> "%~dp0config.kivyinstaller"
(echo installkivy=%installkivy%) >> "%~dp0config.kivyinstaller"
echo Updating kivy.bat to the latest one... & echo Updating kivy.bat to the latest one... >> "%~dp0update_v1.log"
bitsadmin.exe /transfer "GetKivyInstaller" "https://raw.githubusercontent.com/KeyWeeUsr/KivyInstaller/master/kivy.bat" "%~dp0kivy.bat" && echo Successfully updated KivyInstaller & echo Successfully updated KivyInstaller >> "%~dp0update_v1.log"

:end
pause
exit
