::Author: KeyWeeUsr @ https://github.com/KeyWeeUsr
::Version: 1.3
::Inspired by kivy.bat file for kivy1.8.0
::To reset file just delete "config.kivyinstaller"
::Bitsadmin is available since winXP SP2
::If it is not available, download and install to C:\Windows
::https://www.microsoft.com/en-us/download/details.aspx?id=18546
@echo off
set xp=0
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
set installerversion=1.3
setlocal ENABLEDELAYEDEXPANSION
ver | find "5.1" >nul && set xp=1
title = KivyInstaller %installerversion%
set sendto=%appdata%\Microsoft\Windows\SendTo
set taskbar=%appdata%\Microsoft\Internet Explorer\Quick Launch
set addlocal=ADDLOCAL^=DefaultFeature,PrivateCRT,TclTk,Documentation,Tools,Testsuite
if %xp%==1 (
    set sendto=%userprofile%\SendTo
)

echo ###############################################################################
echo KivyInstaller v%installerversion%
echo Author: KeyWeeUsr @ https://github.com/KeyWeeUsr
echo.
echo Report issues @ https://github.com/KeyWeeUsr/KivyInstaller/issues
echo ###############################################################################

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
    set shrtct=%cp2:~2%
) else if %choice%==3 (
    set pyversion=%py3%
    set cp=%cp3%m
    set cpwhl=%cp3%
    set shrtct=%cp3:~2%
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
set /p choice="Make shortcuts? y/n"
if %choice%==y (
    set shortcuts=1
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
set /p choice2="Remove cached pip files? y/n"
set /p choice3="Remove dist folder? y/n"
if %arch%==win32 (
    if not exist "%~dp0py%pyversion%.msi" (
        bitsadmin.exe /transfer "GetPythonMSI" "https://www.python.org/ftp/python/%pyversion%/python-%pyversion%.msi" "%~dp0py%pyversion%.msi"
    )
    if %choice%==y (
        msiexec.exe /x "%~dp0py%pyversion%.msi" /qb
    ) else (goto end)
) else (
    if not exist "%~dp0py%pyversion%.amd64.msi" (
        bitsadmin.exe /transfer "GetPythonMSI" "https://www.python.org/ftp/python/%pyversion%/python-%pyversion%.amd64.msi" "%~dp0py%pyversion%.amd64.msi"
    )
    if %choice%==y (
        msiexec.exe /x "%~dp0py%pyversion%.amd64.msi" /qb
    ) else (goto end)
)
if not exist "%~dp0python.exe" (
    del /q "%~dp0config.kivyinstaller"
    del /q "%~dp0update_kivy.bat"
    del /q "%~dp0backup_kivy.bat"
    del /s /q /f "%~dp0*.spec"
    rmdir /s /q "%userprofile%\.kivy"
    rmdir /s /q "%userprofile%\.idlerc"
    rmdir /s /q "%~dp0Lib"
    rmdir /s /q "%~dp0Scripts"
    rmdir /s /q "%~dp0share"
    rmdir /s /q "%~dp0whls"
    rmdir /s /q "%~dp0build"
)
if %choice2%==y (
    if exist "%localappdata%\pip" (
        rmdir /s /q "%localappdata%\pip"
    ) else (
        rmdir /s /q "%userprofile%\Local Settings\Application Data\pip"
    )
)
if %choice3%==y (
    rmdir /s /q "%~dp0dist"
)
goto rmshortcuts

:batupdate
echo Checking for updates...
bitsadmin.exe /transfer "GetKivyInstaller" "https://raw.githubusercontent.com/KeyWeeUsr/KivyInstaller/master/kivy.bat" "%~dp0_update_kivy.bat"
type "%~dp0_update_kivy.bat" | more /p > "%~dp0update_kivy.bat"
del "%~dp0_update_kivy.bat"
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
echo F | xcopy /y "%~dp0%~n0.bat" "%~dp0backup_kivy.bat"
echo Updating...
start cmd /c timeout /t 5 & (echo Y | xcopy "%~dp0update_kivy.bat" "%~dp0%~n0.bat") & del "%~dp0update_kivy.bat"
exit

:help
echo.
echo KivyInstaller v%installerversion%
echo.
echo Usage:
echo   %~n0 [options]
echo.
echo   ^<file^>                  Run python(.py) file.
echo   update                  Update kivy wheel to the latest stable.
echo   updatemaster            Update kivy wheel to the latest nightly-build.
echo   batcheck                Check for new KivyInstaller version only.
echo   batupdate               Check for new KivyInstaller version and update.
echo   remove                  Uninstall kivy only.
echo   uninstall               Uninstall kivy, python and leave only %~n0.bat.
echo   mkshortcuts             Create shortcuts for SendTo and TaskBar.
echo   rmshortcuts             Remove shortcuts for SendTo and TaskBar.
echo   pack "<path to .py>"    Quick packaging with pyinstaller.
echo   help                    Show this.
echo.
echo Optional:
echo   idle                    Python(.py) text editor with syntax highlighting
echo   pyinstaller             Executable packager for Python programs
goto end

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
set packurl=--extra-index-url https://kivy.org/downloads/packages/simple/
set packages=docutils pygments pypiwin32 requests wget kivy.deps.sdl2 kivy.deps.glew pyinstaller
if %gstreamer%==1 (
    python -m pip install %packages% kivy.deps.gstreamer %packurl%
) else (
    python -m pip install %packages% %packurl%
)
if %stable%==1 (
    python -m pip uninstall -y kivy
    python -m pip install kivy
    goto kivyend
)
mkdir "%~dp0whls"
set driveurl=https://drive.google.com/folderview?id=0B1_HB9J8mZepOV81UHpDbmg5SWM^^^&usp=sharing#list
echo.import os,glob,sys,re,requests,wget,datetime,shutil> "%~dp0getnightly.py"
echo.n = requests.get('%driveurl%').content>> "%~dp0getnightly.py"
>>"%~dp0getnightly.py" echo.y = '{:%%d%%m%%Y}'.format(datetime.datetime.now()-datetime.timedelta(days=1))
echo.try:>> "%~dp0getnightly.py"
>>"%~dp0getnightly.py" echo.    m=re.findall('''\"(Kivy-\d\.\d\.\d)(\.\w{4}_'''+y+'''_git\_?\w{7}-%cpwhl%)(-none|_\d{8}_git_\w{7}-%cp%)(-%arch%.whl)",,,,,"(\S+)",,\"''',n.decode('utf-8'))[0]
echo.except IndexError:>> "%~dp0getnightly.py"
echo.    print("No nightly-build yet")>> "%~dp0getnightly.py"
echo.file_name = ''.join(m[:len(m)-1])>> "%~dp0getnightly.py"
echo.file_id = m[-1]>> "%~dp0getnightly.py"
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
set PATH=%~dp0;%~dp0Tools;%~dp0Scripts;%~dp0share\sdl2\bin;%~dp0Lib\idlelib;%PATH%
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
    (echo shrtct=%shrtct%) >> "%~dp0config.kivyinstaller"
) else (
    echo Kivy was not installed properly!
)

:mkshortcuts
if %shortcuts%==1 (
    (echo @echo off) > "%taskbar%\Kivy%shrtct%.bat"
    (echo if "%%~1"=="" ^() >> "%taskbar%\Kivy%shrtct%.bat"
    (echo     start "" call "%~dp0%~n0.bat") >> "%taskbar%\Kivy%shrtct%.bat"
    (echo ^) else ^() >> "%taskbar%\Kivy%shrtct%.bat"
    (echo     start "" call "%~dp0%~n0.bat" "%%~1") >> "%taskbar%\Kivy%shrtct%.bat"
    (echo ^)) >> "%taskbar%\Kivy%shrtct%.bat" && type "%taskbar%\Kivy%shrtct%.bat" > "%sendto%\Kivy%shrtct%.bat"
)
goto end

:rmshortcuts
del /q "%sendto%\Kivy%shrtct%.bat"
del /q "%taskbar%\Kivy%shrtct%.bat"
goto end

:pack
for /f %%a in ("%2") do for %%b in ("%%~dpa\.") do set n=%%~nxb
for /f %%a in ("%2") do for %%b in ("%%~dpa") do set d=%%b
echo Collecting data...
python -m PyInstaller --debug --name "%n%" "%2"
echo Editing .spec file...
set d=%d:\=\\\\%
set f=from kivy.deps import sdl2, glew\na = 
set t=a.datas,*[Tree(p) for p in (sdl2.dep_bins + glew.dep_bins)],
python -c "o=open;f=o('%n%.spec');t=f.read();f.close();f=o('%n%.spec','w');f.write(t.replace('\na = ','%f%').replace('a.datas,','%t%').replace('T(exe,','T(exe,Tree(\'%d:"=%\'),'));f.close();"
echo Packaging...
python -m PyInstaller "%n%.spec"
del /q "%~dp0%n%.spec"
goto end

:installed
if [%1]==[update] (
    set stable=1
    goto check
) else if [%1]==[updatemaster] (
    set stable=0
    goto check
) else if [%1]==[remove] (
    python -m pip uninstall -y kivy
) else if [%1]==[uninstall] (
    goto uninstall
) else if [%1]==[batcheck] (
    set onlycheck=1
    goto batupdate
) else if [%1]==[batupdate] (
    set onlycheck=0
    goto batupdate
) else if [%1]==[mkshortcuts] (
    set shortcuts=1
    goto mkshortcuts
) else if [%1]==[rmshortcuts] (
    goto rmshortcuts
) else if [%1]==[pack] (
    goto pack
) else if [%1]==[help] (
    goto help
)
cls
set PATH=%~dp0;%~dp0Tools;%~dp0Scripts;%~dp0share\sdl2\bin;%~dp0Lib\idlelib;%PATH%
echo PATH:
echo %PATH%
if [%1]==[] goto console
echo.
echo Running "python.exe %*"
python %*
if not %errorlevel%==0 (pause)

:end
pause
exit

:console
echo.
echo ###############################################################################
@echo OFF
python -c "import sys; print('.'.join(str(x) for x in sys.version_info[:3]))" > temp.txt
set /p python_version=<temp.txt
del temp.txt
start "" /min /wait python.exe -c "from kivy import __version__;f=open('temp.txt','w');f.write(str(__version__)[:5]);f.close()"
set /p kivy_version=<temp.txt
del temp.txt
python -c "exec(\"try:\n    import os.path as o,glob,re,datetime,sys;    p=o.dirname(o.abspath(sys.executable));    m=re.findall('(\d{8})', o.basename(max(glob.glob(p+'/whls/*.[Ww][Hh][Ll]*'), key=o.getctime))[:-4])[0];    print(m[:2]+datetime.date(1900, int(m[2:4]), 1).strftime('%%B')[:3]+m[4:]);\nexcept:\n    pass\")">t
set /p wheel_version=<t
del t
echo - KivyInstaller: %installerversion%
echo - Python:        %python_version%
echo - Kivy:          %kivy_version%
echo - Wheel:         %wheel_version%
echo - New wheel:     %~n0 update or %~n0 updatemaster
echo - Examples:      share\kivy-examples
echo - Launch:        %~n0 main.py or python main.py
echo - Pack:          %~n0 pack "<path>"
echo - Uninstall:     %~n0 uninstall
echo ###############################################################################
echo.
cmd
