::Author: KeyWeeUsr @ https://github.com/KeyWeeUsr
::Version: 2.2
::Inspired by kivy.bat file for kivy1.8.0
::To reset file just delete "config.kivyinstaller"
::Bitsadmin is available since winXP SP2
::If it is not available, download and install to C:\Windows
::https://www.microsoft.com/en-us/download/details.aspx?id=18546
@if not defined DEBUG (echo off)
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
set installerversion=2.2
set admin=1
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

:privileges
set /p choice_privileges="Admin privileges? y/n"
if %choice_privileges%==y (
    goto version
) else if %choice_privileges%==n (
    set admin=0
) else (
    goto privileges
)

:version
set /p choice_python="Python version? 2/3"
if %choice_python%==2 (
    set pyversion=%py2%
    set cp=%cp2%m
    set cpwhl=%cp2%
    set shrtct=%cp2:~2%
) else if %choice_python%==3 (
    set pyversion=%py3%
    set cp=%cp3%m
    set cpwhl=%cp3%
    set shrtct=%cp3:~2%
) else (
    goto version
)

:extensions
set /p choice_ext="Register python extensions (.py, .pyc, ...)? y/n"
if %choice_ext%==y (
    set addlocal=%addlocal%,Extensions
) else if %choice_ext%==n (
    set addlocal=%addlocal%
) else (
    goto extensions
)

:kivy
set /p choice_kivy="Install Kivy? y/n"
if %choice_kivy%==y (
    set installkivy=1
) else if %choice_kivy%==n (
    set installkivy=0
    goto nokivy
) else (
    goto kivy
)
set /p choice_master="Install kivy-master? y/n"
if %choice_master%==y (
    set stable=0
)
set /p choice_gst="Install gstreamer? y/n"
if %choice_gst%==y (
    set gstreamer=1
)
set /p choice_dsgn="Install Kivy Designer? y/n"
if %choice_dsgn%==y (
    set designer=1
)

set /p choice_shrt="Make shortcuts? y/n"
if %choice_shrt%==y (
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
    if %admin%==0 (
        copy "%~dp0py%pyversion%.msi" "%~dp0py%pyversion%_.msi" >nul
        msiexec.exe /a "%~dp0py%pyversion%.msi" /qb /L*V "%~dp0msi.log" ALLUSERS=0 TARGETDIR="%~dp0kivy" CURRENTDIRECTORY="%~dp0" %addlocal%
        for /f "tokens=*" %%f in ('dir /b "%~dp0kivy"') do move "%~dp0kivy\%%f" "%~dp0%%f" >nul
    ) else (
        msiexec.exe /i "%~dp0py%pyversion%.msi" /qb /L*V "%~dp0msi.log" ALLUSERS=0 TARGETDIR="%~dp0" CURRENTDIRECTORY="%~dp0" %addlocal%
    )
) else (
    if exist "%~dp0py%pyversion%.amd64.msi" (
        echo Installer is already downloaded!
    ) else (
        bitsadmin.exe /transfer "GetPythonMSI" "https://www.python.org/ftp/python/%pyversion%/python-%pyversion%.amd64.msi" "%~dp0py%pyversion%.amd64.msi"
        echo Installing...
    )
    if %admin%==0 (
        copy "%~dp0py%pyversion%.msi" "%~dp0py%pyversion%_.msi" >nul
        msiexec.exe /a "%~dp0py%pyversion%.amd64.msi" /qb /L*V "%~dp0msi.log" ALLUSERS=0 TARGETDIR="%~dp0kivy" CURRENTDIRECTORY="%~dp0" %addlocal%
        for /f "tokens=*" %%f in ('dir /b "%~dp0kivy"') do move "%~dp0kivy\%%f" "%~dp0%%f" >nul
    ) else (
        msiexec.exe /i "%~dp0py%pyversion%.amd64.msi" /qb /L*V "%~dp0msi.log" ALLUSERS=0 TARGETDIR="%~dp0" CURRENTDIRECTORY="%~dp0" %addlocal%
    )
)
if %admin%==0 (
    del /q "%~dp0py%pyversion%.msi"
    move /y "%~dp0py%pyversion%_.msi" "%~dp0py%pyversion%.msi" >nul
)
goto check

:uninstall
set /p choice_uninstall="Uninstall? y/n"
set /p choice_pipcache="Remove cached pip files? y/n"
set /p choice_dist="Remove dist folder? y/n"
if %arch%==win32 (
    if not exist "%~dp0py%pyversion%.msi" (
        bitsadmin.exe /transfer "GetPythonMSI" "https://www.python.org/ftp/python/%pyversion%/python-%pyversion%.msi" "%~dp0py%pyversion%.msi"
    )
    if %choice_uninstall%==y (
        if %admin%==0 (
            attrib +r +a *.bat
            for /f "delims=" %%i in ('dir /b') do (rmdir "%%i" /s/q || del "%%i" /s/q)
            attrib -r -a *.bat
        ) else (
            msiexec.exe /x "%~dp0py%pyversion%.msi" /qb
        )
    ) else (goto end)
) else (
    if not exist "%~dp0py%pyversion%.amd64.msi" (
        bitsadmin.exe /transfer "GetPythonMSI" "https://www.python.org/ftp/python/%pyversion%/python-%pyversion%.amd64.msi" "%~dp0py%pyversion%.amd64.msi"
    )
    if %choice_uninstall%==y (
        if %admin%==0 (
            attrib +r +a *.bat
            for /f "delims=" %%i in ('dir /b') do (rmdir "%%i" /s/q || del "%%i" /s/q)
            attrib -r -a *.bat
        ) else (
            msiexec.exe /x "%~dp0py%pyversion%.amd64.msi" /qb
        )
    ) else (goto end)
)
if not exist "%~dp0python.exe" (
    del /q "%~dp0config.kivyinstaller"
    del /q "%~dp0extrapath.kivyinstaller"
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
if %choice_pipcache%==y (
    if exist "%localappdata%\pip" (
        rmdir /s /q "%localappdata%\pip"
    ) else (
        rmdir /s /q "%userprofile%\Local Settings\Application Data\pip"
    )
)
if %choice_dist%==y (
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
echo.
echo Extra install:
echo   getdesigner             Install Kivy Designer (python -m designer)
echo   getgcc                  Install GNU Compiler Collection (mingw32-make, gcc)
echo   getmsvc                 Opens a link for downloading Visual C++ Build Tools
echo.
echo ExtraPATH:
echo   Write new PATH as it is. Separate with ; . No quotes, no ; at the end.
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
    if !designer!==1 (
        python -m pip install https://github.com/kivy/kivy-designer/zipball/master
    )
    goto kivyend
)
mkdir "%~dp0whls"
echo.import os,glob,sys,re,requests,wget,datetime,shutil> "%~dp0getnightly.py"
echo.import os.path as op; import datetime as dt>> "%~dp0getnightly.py"
echo.fid = {'cp27_win32':'Kivy-%master%.dev0-cp27-cp27m-win32.whl',>> "%~dp0getnightly.py"
echo.       'cp34_win32':'Kivy-%master%.dev0-cp34-cp34m-win32.whl',>> "%~dp0getnightly.py"
echo.       'cp35_win32':'Kivy-%master%.dev0-cp35-cp35m-win32.whl',>> "%~dp0getnightly.py"
echo.       'cp27_win_amd64':'Kivy-%master%.dev0-cp27-cp27m-win_amd64.whl',>> "%~dp0getnightly.py"
echo.       'cp34_win_amd64':'Kivy-%master%.dev0-cp34-cp34m-win_amd64.whl',>> "%~dp0getnightly.py"
echo.       'cp35_win_amd64':'Kivy-%master%.dev0-cp35-cp35m-win_amd64.whl'}>> "%~dp0getnightly.py"
>>"%~dp0getnightly.py" echo.y = '{:%%d%%m%%Y}'.format(dt.datetime.now()-dt.timedelta(days=1))
echo.file_id = fid['%cpwhl%_%arch%']>>"%~dp0getnightly.py"
echo.file_name = 'Kivy-%master%.dev0_'+y+'-%cpwhl%-%cp%-%arch%.whl'>> "%~dp0getnightly.py"
echo.link = 'https://kivy.org/downloads/appveyor/kivy/'+file_id>> "%~dp0getnightly.py"
echo.p = op.dirname(op.abspath(__file__))+'\\whls\\'+file_name.replace('%cp%','none')>> "%~dp0getnightly.py"
echo.try:>>"%~dp0getnightly.py"
echo.    wget.download(link,p)>> "%~dp0getnightly.py"
echo.except:>>"%~dp0getnightly.py"
echo.    with open(p,'wb') as f:>>"%~dp0getnightly.py"
echo.        import ssl>>"%~dp0getnightly.py"
echo.        import urllib.request as ulib>>"%~dp0getnightly.py"
echo.        f.write(ulib.urlopen(link,context=ssl._create_unverified_context()).read())>>"%~dp0getnightly.py"
echo.print('\nWheel downloaded...')>> "%~dp0getnightly.py"
echo.root=op.dirname(op.abspath(sys.executable))>> "%~dp0getnightly.py"
echo.whl=op.basename(max(glob.glob(root+'/whls/*.[Ww][Hh][Ll]*'),key=op.getctime))>>"%~dp0getnightly.py"
echo.new='Kivy-%master%.dev0-%cpwhl%-none-%arch%.whl'>> "%~dp0getnightly.py"
echo.shutil.copy2(root+'\\whls\\'+whl,root+'\\whls\\'+new)>> "%~dp0getnightly.py"
python "%~dp0getnightly.py"
if not defined DEBUG (del "%~dp0getnightly.py")
if %first%==0 (
    if exist "%~dp0whls\Kivy-%master%.dev0-%cpwhl%-none-%arch%.whl" (
        python -m pip uninstall -y kivy
        python -m pip install "%~dp0whls\Kivy-%master%.dev0-%cpwhl%-none-%arch%.whl"
    ) else (
        echo No nightly wheel is available yet!
    )
) else (
    python -m pip install "%~dp0whls\Kivy-%master%.dev0-%cpwhl%-none-%arch%.whl"
)
del /q "%~dp0whls\Kivy-%master%.dev0-%cpwhl%-none-%arch%.whl"

:kivyend
del /q "%~dp0msi.log"
set PATH=%~dp0;%~dp0Tools;%~dp0Scripts;%~dp0share\sdl2\bin;%~dp0Lib\idlelib;%PATH%
echo Running touchtracer demo...
>"%~dp0error.txt" python -c "exec(\"try:\n    import kivy;\nexcept ImportError:\n    print('unsuccessful');\")"
find /c "unsuccessful" "%~dp0error.txt"
del /q "%~dp0error.txt"
if not %errorlevel%==1 (
    if not defined DEBUG (
        start python "%~dp0share\kivy-examples\demo\touchtracer\main.py"
    )
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
    (echo admin=%admin%) >> "%~dp0config.kivyinstaller"
    if not exist "%~dp0extrapath.kivyinstaller" (
        type nul > "%~dp0extrapath.kivyinstaller"
    )
) else (
    echo Kivy was not installed properly!
)

:mkshortcuts
if !shortcuts!==1 (
    (echo @echo off) > "%taskbar%\Kivy%shrtct%.bat"
    (echo if "%%~1"=="" ^() >> "%taskbar%\Kivy%shrtct%.bat"
    (echo     cd "%~dp0") >> "%taskbar%\Kivy%shrtct%.bat"
    (echo     start "" call "%~dp0%~n0.bat") >> "%taskbar%\Kivy%shrtct%.bat"
    (echo ^) else ^() >> "%taskbar%\Kivy%shrtct%.bat"
    (echo     cd "%~dp0") >> "%taskbar%\Kivy%shrtct%.bat"
    (echo     start "" call "%~dp0%~n0.bat" "%%~1") >> "%taskbar%\Kivy%shrtct%.bat"
    (echo ^)) >> "%taskbar%\Kivy%shrtct%.bat" && type "%taskbar%\Kivy%shrtct%.bat" > "%sendto%\Kivy%shrtct%.bat"
)
goto end

:rmshortcuts
del /q "%sendto%\Kivy%shrtct%.bat"
del /q "%taskbar%\Kivy%shrtct%.bat"
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
) else if [%1]==[getdesigner] (
    python -m pip install -I -U https://github.com/kivy/kivy-designer/zipball/master
    goto end
) else if [%1]==[getgcc] (
    python -m pip install -I -U -i https://pypi.anaconda.org/carlkl/simple mingwpy
    start "" "https://kivy.org/docs/installation/installation-windows.html#use-development-kivy"
    goto end
) else if [%1]==[getmsvc] (
    start "" "http://landinghub.visualstudio.com/visual-cpp-build-tools"
    start "" "https://kivy.org/docs/installation/installation-windows.html#msvc"
    goto end
) else if [%1]==[help] (
    goto help
)
set /p extrapath=<"%~dp0extrapath.kivyinstaller"
if defined extrapath (
    set PATH=%extrapath%;%~dp0;%~dp0Tools;%~dp0Scripts;%~dp0share\sdl2\bin;%~dp0Lib\idlelib;!PATH!
) else (
    set PATH=%~dp0;%~dp0Tools;%~dp0Scripts;%~dp0share\sdl2\bin;%~dp0Lib\idlelib;!PATH!
)
echo PATH:
echo %PATH%
if [%1]==[] goto console
echo.
echo Running "python.exe %*"
python %*
if not %errorlevel%==0 (goto end)

:end
pause
exit

:console
echo.
echo ###############################################################################
@if not defined DEBUG_CONSOLE (echo off)
python -c "import sys; print('.'.join(str(x) for x in sys.version_info[:3]))" > temp.txt
set /p python_version=<temp.txt
del temp.txt
start "" /min /wait python.exe -c "import kivy;f=open('temp.txt','w');f.write(kivy.__version__);f.close()"
set /p kivy_version=<temp.txt
del temp.txt
python -c "exec(\"try:\n    import os.path as o,glob,re,datetime,sys;    p=o.dirname(o.abspath(sys.executable));    m=re.findall('(\d{8})', o.basename(max(glob.glob(p+'/whls/*.[Ww][Hh][Ll]*'), key=o.getctime))[:-4])[0];    print(m[:2]+datetime.date(1900, int(m[2:4]), 1).strftime('%%B')[:3]+m[4:]);\nexcept:\n    pass\")">t
set /p wheel_version=<t
del t
echo - KivyInstaller: %installerversion%
echo - Python:        %python_version%
echo - Kivy:          %kivy_version%
echo - Wheel:         %wheel_version%
echo - Update Kivy:   %~n0 update or %~n0 updatemaster
echo - Examples:      share\kivy-examples
echo - Launch:        %~n0 main.py or python main.py
echo - Pack:          %~n0 pack "<path>"
echo - Uninstall:     %~n0 uninstall
echo ###############################################################################
echo.
cmd
exit

:pack
if not [%1]==[pack] (
    pause
    exit
)
for /f %%a in ("%2") do for %%b in ("%%~dpa\.") do set n=%%~nxb
for /f %%a in ("%2") do for %%b in ("%%~dpa") do set d=%%b
echo Collecting data...
python -m PyInstaller --debug --name "%n%" "%2"
echo Editing .spec file...
set d=%d:\=\\\\%
set f=from kivy.deps import sdl2, glew\na = 
set t=a.datas,*[Tree(p) for p in (sdl2.dep_bins + glew.dep_bins)],
:: %d:"=% strips double-quotes
python -c "o=open;f=o('%n%.spec');t=f.read();f.close();f=o('%n%.spec','w');f.write(t.replace('\na = ','%f%').replace('a.datas,','%t%').replace('T(exe,','T(exe,Tree(\'%d:"=%\'),'));f.close();"
echo Packaging...
python -m PyInstaller "%n%.spec"
del /q "%~dp0%n%.spec"
goto end
