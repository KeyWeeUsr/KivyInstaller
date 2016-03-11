::Author: KeyWeeUsr @ https://github.com/KeyWeeUsr
::Version: 1.1
::Inspired by kivy.bat file for kivy1.8.0
::To reset file just delete "config.kivyinstaller"
::Bitsadmin is available since winXP SP2
::If it is not available, download and install to C:\Windows
::https://www.microsoft.com/en-us/download/details.aspx?id=18546
@echo off
set cp=0
set first=1
set cpwhl=0
set stable=1
set cp2=cp27
set cp3=cp34
set py3=3.4.4
set arch=win32
set py2=2.7.11
set pyversion=0
set gstreamer=0
set master=1.9.2
set installkivy=1
set installerversion=1.1
setlocal ENABLEDELAYEDEXPANSION
set addlocal=ADDLOCAL^=DefaultFeature,PrivateCRT,TclTk,Documentation,Tools,Testsuite

echo #####################################################################
echo KivyInstaller v%installerversion%
echo Author: KeyWeeUsr @ https://github.com/KeyWeeUsr
echo.
echo Report issues @ https://github.com/KeyWeeUsr/KivyInstaller/issues
echo #####################################################################

echo Looking for config file...
if exist "%~dp0config.kivyinstaller" (
    echo Config found, setting variables...
    set first=0
    for /f "delims=" %%z in ('type "%~dp0config.kivyinstaller"') do set %%z
) else (
    echo Config not found, running installation...
    set first=1
)

if not %first%==1 (
    goto installed
)
if %processor_architecture%==AMD64 (
    set /p arch32="64bit detected, use 32bit instead? y/n"
    if !arch32!==n (
        set arch=win_amd64
    )
)
if exist "%~dp0python.exe" (
    echo Python is already installed!
    echo To continue with kivy installation choose "y"
    echo To uninstall choose "n"
    set /p kivycontinue="Continue with kivy installation? y/n"
    if !kivycontinue!==n (
        goto uninstall
    )
)

:version
set /p choice="Python version? 2/3"
if %choice%==2 (
    set pyversion=%py2%
    set cp=%cp2%m
    set cpwhl=%cp2%
) else if %choice%==3 (
    set pyversion=%py3%
    set cp=%cp3%m
    set cpwhl=%cp3%
) else (
    goto version
)

:extensions
set /p choice="Register python extensions (.py, .pyc, ...)? y/n"
if %choice%==y (
    set addlocal=%addlocal%,Extensions
) else if %choice%==n (
    set addlocal=%addlocal%
) else (
    goto extensions
)

:kivy
set /p choice="Install Kivy? y/n"
if %choice%==y (
    set installkivy=1
) else if %choice%==n (
    set installkivy=0
    goto nokivy
) else (
    goto kivy
)
set /p choice="Install kivy-master? y/n"
if %choice%==y (
    set stable=0
)
set /p choice="Install gstreamer? y/n"
if %choice%==y (
    set gstreamer=1
)

:nokivy
if !kivycontinue!==y (
    goto check
)
if %arch%==win32 (
    if exist "%~dp0py%pyversion%.msi" (
        echo Installer is already downloaded!
    ) else (
        echo Downloading Python installer...
        bitsadmin.exe /transfer "GetPythonMSI" "https://www.python.org/ftp/python/%pyversion%/python-%pyversion%.msi" "%~dp0py%pyversion%.msi"
        echo Installing...
    )
    msiexec.exe /i "%~dp0py%pyversion%.msi" /qb /L*V "%~dp0msi.log" ALLUSERS=0 TARGETDIR="%~dp0" CURRENTDIRECTORY="%~dp0" %addlocal%
) else (
    if exist "%~dp0py%pyversion%.amd64.msi" (
        echo Installer is already downloaded!
    ) else (
        bitsadmin.exe /transfer "GetPythonMSI" "https://www.python.org/ftp/python/%pyversion%/python-%pyversion%.amd64.msi" "%~dp0py%pyversion%.amd64.msi"
        echo Installing...
    )
    msiexec.exe /i "%~dp0py%pyversion%.amd64.msi" /qb /L*V "%~dp0msi.log" ALLUSERS=0 TARGETDIR="%~dp0" CURRENTDIRECTORY="%~dp0" %addlocal%
)
goto check

:uninstall
set /p choice="Uninstall? y/n"
del "%~dp0config.kivyinstaller"
if %arch%==win32 (
    if not exist "%~dp0py%pyversion%.msi" (
        bitsadmin.exe /transfer "GetPythonMSI" "https://www.python.org/ftp/python/%pyversion%/python-%pyversion%.msi" "%~dp0py%pyversion%.msi"
    )
    if %choice%==y (
        msiexec.exe /x "%~dp0py%pyversion%.msi" /qb
    )
) else (
    if not exist "%~dp0py%pyversion%.amd64.msi" (
        bitsadmin.exe /transfer "GetPythonMSI" "https://www.python.org/ftp/python/%pyversion%/python-%pyversion%.amd64.msi" "%~dp0py%pyversion%.amd64.msi"
    )
    if %choice%==y (
        msiexec.exe /x "%~dp0py%pyversion%.amd64.msi" /qb
    )
)
if not exist "%~dp0python.exe" (
    del /q "%~dp0config.kivyinstaller"
    del /q "%~dp0update_kivy.bat"
    del /q "%~dp0backup_kivy.bat"
    rmdir /s /q "%~dp0Lib"
    rmdir /s /q "%~dp0Scripts"
    rmdir /s /q "%~dp0share"
    rmdir /s /q "%~dp0whls"
    
)
set /p choice="Remove cached pip files? y/n"
if %choice%==y (
    if exist "%localappdata%\pip" (
        rmdir /s /q "%localappdata%\pip"
    ) else (
        rmdir /s /q "%userprofile%\Local Settings\Application Data\pip"
    )
)
goto end

:batupdate
echo Checking for updates...
bitsadmin.exe /transfer "GetKivyInstaller" "https://raw.githubusercontent.com/KeyWeeUsr/KivyInstaller/master/kivy.bat" "%~dp0update_kivy.bat"
set /a line=0
for /f "delims=" %%l in ('type "%~dp0update_kivy.bat"') do (
    set /a line=line+1
    if !line! equ 2 (
        set updateversion=%%l
        set updateversion=!updateversion:~11!
    )
)
if %installerversion% lss %updateversion% (
    echo You are using KivyInstaller version %installerversion%!
    echo New version %updateversion% is available!
    if %onlycheck%==1 (
        echo To install new version use - %~n0 batupdate
        del "%~dp0update_kivy.bat"
        goto console
    )
) else if %installerversion%==%updateversion% (
    echo Your version is up to date!
    del "%~dp0update_kivy.bat"
    goto console
)
echo Backing up original file...
echo f | xcopy "%~dp0kivy.bat" "%~dp0backup_kivy.bat"
echo Updating...
start cmd /c timeout /t 5 & (echo Y | xcopy "%~dp0update_kivy.bat" "%~dp0kivy.bat") & del %~dp0update_kivy.bat && cmd /c "%~dp0%~n0"
exit

:help
echo.
echo KivyInstaller v%installerversion%
echo.
echo Usage:
echo   %~n0 ^<file^> [update] [updatemaster] [batcheck] [batupdate]
echo          [uninstall] [help]
echo.
echo   ^<file^>             Run python(.py) file.
echo   update             Update kivy wheel to the latest stable.
echo   updatemaster       Update kivy wheel to the latest nightly-build.
echo   batcheck           Check for new KivyInstaller version only.
echo   batupdate          Check for new KivyInstaller version and update.
echo   uninstall          Uninstall kivy, python and leave only %~n0.
echo   help               Show this.
echo.
echo Optional:
echo   idle               Python(.py) file editor with syntax highlighting
exit

:check
if exist "%~dp0python.exe" (
    echo Python is installed!
    echo Installing pip...
    python -m ensurepip
)
if %installkivy%==0 (
    goto end
)
echo Preparing Python for Kivy...
python -m pip install --upgrade pip wheel setuptools
if %gstreamer%==1 (
    python -m pip install docutils pygments pypiwin32 requests wget kivy.deps.sdl2 kivy.deps.glew kivy.deps.gstreamer --extra-index-url https://kivy.org/downloads/packages/simple/
) else (
    python -m pip install docutils pygments pypiwin32 requests wget kivy.deps.sdl2 kivy.deps.glew --extra-index-url https://kivy.org/downloads/packages/simple/
)
if %stable%==1 (
    python -m pip uninstall -y kivy
    python -m pip install kivy
    goto kivyend
)
mkdir "%~dp0whls"
echo.import os,glob,sys,re,requests,wget,datetime,shutil> "%~dp0getnightly.py"
echo.nightly = requests.get('https://drive.google.com/folderview?id=0B1_HB9J8mZepOV81UHpDbmg5SWM^&usp=sharing#list').content>> "%~dp0getnightly.py"
>>"%~dp0getnightly.py" echo.yesterday = '{:%%d%%m%%Y}'.format(datetime.datetime.now()-datetime.timedelta(days=1))
echo.try:>> "%~dp0getnightly.py"
>>"%~dp0getnightly.py" echo.    match = re.findall('''\"(Kivy-\d\.\d\.\d)(\.\w{4}_'''+yesterday+'''_git\_?\w{7}-%cpwhl%)(-none|_\d{8}_git_\w{7}-%cp%)(-%arch%.whl)",,,,,"(\S+)",,\"''',nightly.decode('utf-8'))[0]
echo.except IndexError:>> "%~dp0getnightly.py"
echo.    print("No nightly-build yet")>> "%~dp0getnightly.py"
echo.file_name = ''.join(match[:len(match)-1])>> "%~dp0getnightly.py"
echo.file_id = match[-1]>> "%~dp0getnightly.py"
echo.link = 'https://docs.google.com/uc?id='+file_id>> "%~dp0getnightly.py"
echo.p = os.path.dirname(os.path.abspath(__file__))+'\\whls\\'+file_name.replace('%cp%','none')>> "%~dp0getnightly.py"
echo.try:>>"%~dp0getnightly.py"
echo.    wget.download(link,p)>> "%~dp0getnightly.py"
echo.except:>>"%~dp0getnightly.py"
echo.    with open(p,'wb') as f:>>"%~dp0getnightly.py"
echo.        import ssl>>"%~dp0getnightly.py"
echo.        import urllib.request as ulib>>"%~dp0getnightly.py"
echo.        f.write(ulib.urlopen(link,context=ssl._create_unverified_context()).read())>>"%~dp0getnightly.py"
echo.print('Wheel downloaded...')>> "%~dp0getnightly.py"
echo.root=os.path.dirname(os.path.abspath(sys.executable))>> "%~dp0getnightly.py"
echo.whl=os.path.basename(max(glob.glob(root+'/whls/*.[Ww][Hh][Ll]*'),key=os.path.getctime))>>"%~dp0getnightly.py"
echo.new='Kivy-%master%.dev0-%cpwhl%-none-%arch%.whl'>> "%~dp0getnightly.py"
echo.shutil.copy2(root+'\\whls\\'+whl,root+'\\whls\\'+new)>> "%~dp0getnightly.py"
python "%~dp0getnightly.py"
del "%~dp0getnightly.py"
if %first%==0 (
    python -m pip uninstall -y kivy
    python -m pip install "%~dp0whls\Kivy-%master%.dev0-%cpwhl%-none-%arch%.whl"
) else (
    python -m pip install "%~dp0whls\Kivy-%master%.dev0-%cpwhl%-none-%arch%.whl"
)
del "%~dp0whls\Kivy-%master%.dev0-%cpwhl%-none-%arch%.whl"

:kivyend
del "%~dp0msi.log"
echo Close touchtracer demo with Escape key, do not use X!
pause
echo Running touchtracer demo...
>"%~dp0temp.txt" python -c "exec(\"try:\n    import kivy;\nexcept ImportError:\n    print('unsuccessful');\")"
find /c "unsuccessful" "%~dp0temp.txt"
del "%~dp0temp.txt"
if not %errorlevel%==1 (
    start python "%~dp0share\kivy-examples\demo\touchtracer\main.py"
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
) else (
    echo Kivy was not installed properly!
)
goto end

:installed
if [%1]==[update] (
    set stable=1
    goto check
) else if [%1]==[updatemaster] (
    set stable=0
    goto check
) else if [%1]==[uninstall] (
    goto uninstall
) else if [%1]==[batcheck] (
    set onlycheck=1
    goto batupdate
) else if [%1]==[batupdate] (
    set onlycheck=0
    goto batupdate
) else if [%1]==[help] (
    goto help
)
set PATH=%~dp0;%~dp0Tools;%~dp0Lib\idlelib;%PATH%
echo PATH:
echo %PATH%
echo ---------------------------------------------------------------------
if [%1]==[] goto console
echo.
echo Running "python.exe %*"
python %*
if not %errorlevel%==0 (pause)
goto end

:console
echo.
echo #####################################################################
@echo OFF
python -c "import sys; print('.'.join(str(x) for x in sys.version_info[:3]))" > temp.txt
set /p python_version=<temp.txt
del temp.txt
start "" /min /wait python.exe -c "from kivy import __version__;f=open('temp.txt','w');f.write(str(__version__)[:5]);f.close()"
set /p kivy_version=<temp.txt
del temp.txt
python -c "exec(\"try:\n    import os, glob, re, datetime, sys;p=os.path.dirname(os.path.abspath(sys.executable));match = re.findall('(\d{8})', os.path.basename(max(glob.glob(p+'/whls/*.[Ww][Hh][Ll]*'), key=os.path.getctime))[:-4])[0];print(match[:2]+' '+datetime.date(1900, int(match[2:4]), 1).strftime('%%B')[:3]+' '+match[4:]);\nexcept:\n    pass\")" >temp.txt
set /p wheel_version=<temp.txt
del temp.txt
echo - KivyInstaller: %installerversion%
echo - Python: %python_version%
echo - Kivy: %kivy_version%
echo - Wheel: %wheel_version%
echo - New wheel: %~n0 update or %~n0 updatemaster
echo - Examples: share\kivy-examples
echo - Launch: %~n0 main.py or python main.py
echo - Uninstall: %~n0 uninstall
echo #####################################################################
echo.
cmd

:end
pause
exit
