::Author: KeyWeeUsr @ https://github.com/KeyWeeUsr
::Version: 3.6
::Inspired by kivy.bat file for kivy1.8.0
::To reset file just delete "config.kivyinstaller"
::Bitsadmin is available since winXP SP2
::If it is not available, download and install to C:\Windows
::https://www.microsoft.com/en-us/download/details.aspx?id=18546
@if not defined DEBUG (echo off)
if not defined cp2 (set cp2=cp27)
if not defined cp3 (set cp3=cp34)
if not defined py2 (set py2=2.7.13)
if not defined py3 (set py3=3.4.4)
if not defined master (set master=1.10.1)
set xp=0
set cp=0
set first=1
set admin=1
set cpwhl=0
set stable=1
set arch=win32
set pyversion=0
set gstreamer=0
set installkivy=1
set installerversion=3.6
set kilog=[KivyInstaller]
setlocal ENABLEDELAYEDEXPANSION
title = KivyInstaller %installerversion%
set sendto=%appdata%\Microsoft\Windows\SendTo
set taskbar=%appdata%\Microsoft\Internet Explorer\Quick Launch
set addlocal=ADDLOCAL^=DefaultFeature,PrivateCRT,TclTk,Documentation,Tools,Testsuite
set py35addlocal=Shortcuts=0 Include_launcher=0 Include_pip=0
set pyFTP=https://www.python.org/ftp/python/

:: Return version without installation
if [%1]==[version] (
    echo %installerversion%
    exit
)

:: Set downloader
if [%SHELL%]==[/bin/bash] (
    set down=kiwget.exe
) else (
    set down=bitsadmin.exe
)

ver | find "5.1" >nul && set xp=1
if %xp%==1 (
    set sendto=%userprofile%\SendTo
)

echo ###############################################################################
echo KivyInstaller v%installerversion%
echo Author: KeyWeeUsr @ https://github.com/KeyWeeUsr
echo.
echo Report issues @ https://github.com/KeyWeeUsr/KivyInstaller/issues
echo ###############################################################################

echo %kilog% Looking for config file...
if exist "%~dp0config.kivyinstaller" (
    echo %kilog% Config file found, setting variables...
    set first=0
    for /f "delims=" %%z in ('type "%~dp0config.kivyinstaller"') do set %%z
) else (
    echo %kilog% Config file not found, running installation...
    set first=1
)

if %py3% geq 3.5.0 (
   set pyext=.exe
) else (
   set pyext=.msi
)

if not %first%==1 (
    goto installed
)
if %processor_architecture%==AMD64 (
    set /p arch32="64bit environment detected! Create 32bit instead? y/n"
)
if [%arch32%]==[n] (
    set arch=win_amd64
)
if exist "%~dp0python.exe" (
    echo %kilog% Python is already installed!
    echo %kilog% - To continue with kivy installation choose "y"
    echo %kilog% - To uninstall choose "n"
    set /p kivycontinue="Continue with kivy installation? y/n"
    if !kivycontinue!==n (
        goto uninstall
    )
)

:privileges
set /p choice_privileges="Install Python globally (requires admin)? y/n"
if %choice_privileges%==y (
    goto version
) else if %choice_privileges%==n (
    set admin=0
) else (
    goto privileges
)

:version
set /p choice_python="Choose the Python version! 2/3"
if %choice_python%==2 (
    set pyversion=%py2%
    set cp=%cp2%m
    set cpwhl=%cp2%
    set shrtct=%cp2:~2%
    set pyext=.msi
) else if %choice_python%==3 (
    set pyversion=%py3%
    set cp=%cp3%m
    set cpwhl=%cp3%
    set shrtct=%cp3:~2%
) else (
    goto version
)

:extensions
set /p choice_ext="Register Python extensions (.py, .pyc, ...)? y/n"
if %choice_ext%==y (
    set addlocal=%addlocal%,Extensions
    set py35addlocal=%py35addlocal% AssociateFiles=1
) else if %choice_ext%==n (
    set addlocal=%addlocal%
    set py35addlocal=%py35addlocal% AssociateFiles=0
) else (
    goto extensions
)

:kivy
set /p choice_kivy="Proceed with Kivy installation? y/n"
if %choice_kivy%==y (
    set installkivy=1
) else if %choice_kivy%==n (
    set installkivy=0
    goto nokivy
) else (
    goto kivy
)
set /p choice_master="Install the latest development version? y/n"
if %choice_master%==y (
    set stable=0
)
set /p choice_gst="Install GStreamer? y/n"
if %choice_gst%==y (
    set gstreamer=1
)
set /p choice_dsgn="Install Kivy Designer? y/n"
if %choice_dsgn%==y (
    set designer=1
)

set /p choice_shrt="Make shortcuts (taskbar + send to)? y/n"
if %choice_shrt%==y (
    set shortcuts=1
)

:nokivy
if !kivycontinue!==y (
    goto check
)
:: needs fixing for webinstallers
if %arch%==win32 (
    if exist "%~dp0py%pyversion%!pyext!" (
        echo %kilog% Installer is already downloaded!
    ) else (
        echo %kilog% Downloading Python installer...
        if !pyext!==.exe (
            if %admin%==0 (
                %down% /transfer "GetPython%pyversion%-webinstall!pyext!" ^
                "%pyFTP%%pyversion%/python-%pyversion%-webinstall!pyext!" ^
                "%~dp0py%pyversion%-webinstall!pyext!"
            ) else (
                %down% /transfer "GetPython%pyversion%!pyext!" ^
                "%pyFTP%%pyversion%/python-%pyversion%!pyext!" ^
                "%~dp0py%pyversion%!pyext!"
            )
        ) else (
            %down% /transfer "GetPython%pyversion%!pyext!" ^
            "%pyFTP%%pyversion%/python-%pyversion%!pyext!" ^
            "%~dp0py%pyversion%!pyext!"
        )
        echo %kilog% Installing...
    )
    if %admin%==0 (
        copy "%~dp0py%pyversion%!pyext!" "%~dp0py%pyversion%_!pyext!" >nul
        if !pyext!==.msi (
            msiexec.exe /a "%~dp0py%pyversion%.msi" /qb /L*V "%~dp0msi.log" ^
            ALLUSERS=0 TARGETDIR="%~dp0kivy" CURRENTDIRECTORY="%~dp0" %addlocal%
            for /f "tokens=*" %%f in ('dir /b "%~dp0kivy"') do move "%~dp0kivy\%%f" "%~dp0%%f" >nul
        ) else if !pyext!==.exe (
            "%~dp0py%pyversion%-webinstall.exe" /quiet /layout "%~dp0\_installers"
            msiexec.exe /a "%~dp0\_installers\core.msi" TARGETDIR="%~dp0"
            msiexec.exe /a "%~dp0\_installers\dev.msi" TARGETDIR="%~dp0"
            msiexec.exe /a "%~dp0\_installers\doc.msi" TARGETDIR="%~dp0"
            msiexec.exe /a "%~dp0\_installers\exe.msi" TARGETDIR="%~dp0"
            msiexec.exe /a "%~dp0\_installers\lib.msi" TARGETDIR="%~dp0"
            msiexec.exe /a "%~dp0\_installers\tcltk.msi" TARGETDIR="%~dp0"
            msiexec.exe /a "%~dp0\_installers\test.msi" TARGETDIR="%~dp0"
            msiexec.exe /a "%~dp0\_installers\tools.msi" TARGETDIR="%~dp0"
            del /q "%~dp0\core.msi"
            del /q "%~dp0\dev.msi"
            del /q "%~dp0\doc.msi"
            del /q "%~dp0\exe.msi"
            del /q "%~dp0\lib.msi"
            del /q "%~dp0\tcltk.msi"
            del /q "%~dp0\test.msi"
            del /q "%~dp0\tools.msi"
            rmdir /s /q "%~dp0_installers"
        )
    ) else (
        if !pyext!==.msi (
            msiexec.exe /i "%~dp0py%pyversion%.msi" /qb /L*V "%~dp0msi.log" ^
            ALLUSERS=0 TARGETDIR="%~dp0" CURRENTDIRECTORY="%~dp0" %addlocal%
        ) else if !pyext!==.exe (
            "%~dp0py%pyversion%.exe" /quiet /log "%~dp0msi.log" ^
            DefaultJustForMeTargetDir="%~dp0" InstallAllUsers=0 %py35addlocal%
        )
    )
) else (
    set amdext=.amd64
    if !pyext!==.exe (
        set amdext=-amd64
    )
    if exist "%~dp0py%pyversion%!amdext!!pyext!" (
        echo %kilog% Installer is already downloaded!
    ) else (
        if !pyext!==.exe (
            if %admin%==0 (
                %down% /transfer ^
                "GetPython%pyversion%!amdext!-webinstall!pyext!" ^
                "%pyFTP%%pyversion%/python-%pyversion%!amdext!-webinstall!pyext!" ^
                "%~dp0py%pyversion%!amdext!-webinstall!pyext!"
            ) else (
                %down% /transfer ^
                "GetPython%pyversion%!amdext!!pyext!" ^
                "%pyFTP%%pyversion%/python-%pyversion%!amdext!!pyext!" ^
                "%~dp0py%pyversion%!amdext!!pyext!"
            )
        ) else (
            %down% /transfer "GetPython%pyversion%!amdext!!pyext!" ^
            "%pyFTP%%pyversion%/python-%pyversion%!amdext!!pyext!" ^
            "%~dp0py%pyversion%!amdext!!pyext!"
        )
        echo %kilog% Installing...
    )
    if %admin%==0 (
        copy "%~dp0py%pyversion%!amdext!.msi" "%~dp0py%pyversion%_!amdext!.msi" >nul
        if !pyext!==.msi (
            msiexec.exe /a "%~dp0py%pyversion%!amdext!.msi" /qb /L*V "%~dp0msi.log" ^
            ALLUSERS=0 TARGETDIR="%~dp0kivy" CURRENTDIRECTORY="%~dp0" %addlocal%
            for /f "tokens=*" %%f in ('dir /b "%~dp0kivy"') do move "%~dp0kivy\%%f" "%~dp0%%f" >nul
        ) else if !pyext!==.exe (
            "%~dp0py%pyversion%!amdext!-webinstall.exe" /quiet /layout "%~dp0\_installers"
            msiexec.exe /a "%~dp0\_installers\core.msi" TARGETDIR="%~dp0"
            msiexec.exe /a "%~dp0\_installers\dev.msi" TARGETDIR="%~dp0"
            msiexec.exe /a "%~dp0\_installers\doc.msi" TARGETDIR="%~dp0"
            msiexec.exe /a "%~dp0\_installers\exe.msi" TARGETDIR="%~dp0"
            msiexec.exe /a "%~dp0\_installers\lib.msi" TARGETDIR="%~dp0"
            msiexec.exe /a "%~dp0\_installers\tcltk.msi" TARGETDIR="%~dp0"
            msiexec.exe /a "%~dp0\_installers\test.msi" TARGETDIR="%~dp0"
            msiexec.exe /a "%~dp0\_installers\tools.msi" TARGETDIR="%~dp0"
            del /q "%~dp0\core.msi"
            del /q "%~dp0\dev.msi"
            del /q "%~dp0\doc.msi"
            del /q "%~dp0\exe.msi"
            del /q "%~dp0\lib.msi"
            del /q "%~dp0\tcltk.msi"
            del /q "%~dp0\test.msi"
            del /q "%~dp0\tools.msi"
            rmdir /s /q "%~dp0_installers"
        )
    ) else (
        if !pyext!==.msi (
            msiexec.exe /i "%~dp0py%pyversion%!amdext!.msi" /qb /L*V "%~dp0msi.log" ^
            ALLUSERS=0 TARGETDIR="%~dp0" CURRENTDIRECTORY="%~dp0" %addlocal%
        ) else if !pyext!==.exe (
            "%~dp0py%pyversion%!amdext!.exe" /quiet /log "%~dp0msi.log" ^
            DefaultJustForMeTargetDir="%~dp0" InstallAllUsers=0 %py35addlocal%
        )
    )
)
if %admin%==0 (
    del /q "%~dp0py%pyversion%!pyext!"
    move /y "%~dp0py%pyversion%_!pyext!" "%~dp0py%pyversion%!pyext!" >nul
    del /q "%~dp0py%pyversion%!amdext!!pyext!"
    move /y "%~dp0py%pyversion%_!amdext!!pyext!" "%~dp0py%pyversion%!amdext!!pyext!" >nul
)
goto check

:uninstall
set /p choice_uninstall="Uninstall the whole environment? y/n"
set /p choice_pipcache="Remove cached pip files? y/n"
set /p choice_dist="Remove PyInstaller dist folder (if any)? y/n"
if %arch%==win32 (
    if not exist "%~dp0py%pyversion%!pyext!" (
        %down% /transfer "GetPython%pyversion%!pyext!" ^
        "%pyFTP%%pyversion%/python-%pyversion%!pyext!" ^
        "%~dp0py%pyversion%!pyext!"
    )
    if %choice_uninstall%==y (
        if %admin%==0 (
            attrib +r +a *.bat
            for /f "delims=" %%i in ('dir /b') do (rmdir "%%i" /s/q || del "%%i" /s/q)
            attrib -r -a *.bat
        ) else (
            if !pyext!==.msi (
                msiexec.exe /x "%~dp0py%pyversion%.msi" /qb
            ) else if !pyext!==.exe (
                "%~dp0py%pyversion%.exe" /uninstall
            )
        )
    ) else (goto end)
) else (
    set amdext=.amd64
    if !pyext!==.exe (
        set amdext=-amd64
    )
    if not exist "%~dp0py%pyversion%%amdext%!pyext!" (
        %down% /transfer "GetPython%pyversion%%amdext%!pyext!" ^
        "%pyFTP%%pyversion%/python-%pyversion%%amdext%!pyext!" ^
        "%~dp0py%pyversion%%amdext%!pyext!"
    )
    if %choice_uninstall%==y (
        if %admin%==0 (
            attrib +r +a *.bat
            for /f "delims=" %%i in ('dir /b') do (rmdir "%%i" /s/q || del "%%i" /s/q)
            attrib -r -a *.bat
        ) else (
            if !pyext!==.msi (
                msiexec.exe /x "%~dp0py%pyversion%%amdext%.msi" /qb
            ) else if !pyext!==.exe (
                "%~dp0py%pyversion%%amdext%.msi" /uninstall
            )
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
:: Download GitHub's raw output
echo %kilog% Checking for updates...
%down% /transfer "GetKivyInstaller" "https://git.io/vDDjn" "%~dp0_update_kivy.bat"

:: UNIX to WIN EOL (GitHub raw provides \n) with MORE /P
type "%~dp0_update_kivy.bat" | more /p > "%~dp0update_kivy.bat"
del "%~dp0_update_kivy.bat"

:: Find the installer's version - fixed to the 2nd line
:: -> strip "::Version: "(11)
set /a line=0
for /f "delims=" %%l in ('type "%~dp0update_kivy.bat"') do (
    set /a line=line+1
    if !line! equ 2 (
        set updateversion=%%l
        set updateversion=!updateversion:~11!
    )
)

if %installerversion% lss %updateversion% (
    echo %kilog% You are using KivyInstaller version %installerversion%!
    echo %kilog% - New version %updateversion% is available!
    if %onlycheck%==1 (
        echo %kilog% - To install new version use - %~n0 batupdate
        del "%~dp0update_kivy.bat"
        goto console
    )
) else if %installerversion%==%updateversion% (
    echo %kilog% Your version is up to date!
    del "%~dp0update_kivy.bat"
    goto console
)

:: echo F for file
:: After update an exit is needed, otherwise a cached file is used!
echo %kilog% Backing up the original file...
echo F | xcopy /y "%~dp0%~n0.bat" "%~dp0backup_kivy.bat"
echo %kilog% Updating...
(echo Y | xcopy "%~dp0update_kivy.bat" "%~dp0%~n0.bat") ^
& del "%~dp0update_kivy.bat" & echo Done & exit

:help
echo.
echo KivyInstaller v%installerversion%
echo.
echo Usage:
echo   %~n0 [options]
echo.
echo   ^<file^>                   Run python(.py) file
echo   update                   Update kivy wheel to the latest stable
echo   updatemaster             Update kivy wheel to the latest nightly-build
echo   batcheck                 Check for new KivyInstaller version only
echo   batupdate                Check for new KivyInstaller version and update
echo   remove                   Uninstall kivy only
echo   uninstall                Uninstall kivy, python and leave only %~n0.bat
echo   mkshortcuts              Create shortcuts for SendTo and TaskBar
echo   rmshortcuts              Remove shortcuts for SendTo and TaskBar
echo   pack "<abs path to .py>" Quick packaging with pyinstaller
echo   version                  Prints version of the KivyInstaller
echo   help                     Show this
echo.
echo Optional:
echo   idle                     Python text editor with syntax highlighting
echo   pyinstaller              Executable packager for Python programs
echo.
echo Extra install:
echo   getdesigner              Install Kivy Designer (python -m designer)
echo   getgcc                   Install GNU Compiler Collection (mingw32-make, gcc)
echo   getmsvc                  Open an URL for Visual C++ Build Tools
echo.
echo ExtraPATH:
echo   Write new PATH as it is. Separate with ; . No quotes, no ; at the end.
goto end

:check
if defined DEBUG (type "%~dp0msi.log")
if exist "%~dp0python.exe" (
    echo %kilog% Python is installed!
    echo %kilog% Installing pip...
    "%~dp0python.exe" -m ensurepip
)
if %installkivy%==0 (
    goto end
)
echo %kilog% Preparing Python for Kivy...
"%~dp0python.exe" -m pip install --upgrade pip wheel setuptools
set packurl=--extra-index-url https://kivy.org/downloads/packages/simple/
set packages=docutils pygments pypiwin32 requests wget kivy.deps.sdl2 kivy.deps.glew ^
pyinstaller
if %gstreamer%==1 (
    "%~dp0python.exe" -m pip install %packages% kivy.deps.gstreamer %packurl%
) else (
    "%~dp0python.exe" -m pip install %packages% %packurl%
)
"%~dp0python.exe" -m pip install -I https://kivy.org/downloads/appveyor/kivy/Kivy_examples-%master%.dev0-py2.py3-none-any.whl
if %stable%==1 (
    "%~dp0python.exe" -m pip uninstall -y kivy
    "%~dp0python.exe" -m pip install kivy
    if !designer!==1 (
        "%~dp0python.exe" -m pip install https://github.com/kivy/kivy-designer/zipball/master
    )
    goto kivyend
)
mkdir "%~dp0whls"

:: Download nightly wheels from kivy.org FTP [PY]
echo.import os,glob,sys,re,requests,wget,datetime,shutil> "%~dp0getnightly.py"
echo.import os.path as op; import datetime as dt>> "%~dp0getnightly.py"
echo.k = 'Kivy-%master%.dev0-'>> "%~dp0getnightly.py"
echo.w32 = '-win32.whl'>> "%~dp0getnightly.py"
echo.a64 = '-win_amd64.whl'>> "%~dp0getnightly.py"
echo.fid = {>> "%~dp0getnightly.py"
echo.    'cp27_win32': k + 'cp27-cp27m' + w32,>> "%~dp0getnightly.py"
echo.    'cp34_win32': k + 'cp34-cp34m' + w32,>> "%~dp0getnightly.py"
echo.    'cp35_win32': k + 'cp35-cp35m' + w32,>> "%~dp0getnightly.py"
echo.    'cp36_win32': k + 'cp36-cp36m' + w32,>> "%~dp0getnightly.py"
echo.    'cp27_win_amd64': k + 'cp27-cp27m' + a64,>> "%~dp0getnightly.py"
echo.    'cp34_win_amd64': k + 'cp34-cp34m' + a64,>> "%~dp0getnightly.py"
echo.    'cp35_win_amd64': k + 'cp35-cp35m' + a64,>> "%~dp0getnightly.py"
echo.    'cp36_win_amd64': k + 'cp36-cp36m' + a64>> "%~dp0getnightly.py"
echo.}>> "%~dp0getnightly.py"
:: escape % here
echo.y = '{:%%d%%m%%Y}'.format(>> "%~dp0getnightly.py"
echo.    dt.datetime.now() - dt.timedelta(days=1)>> "%~dp0getnightly.py"
echo.)>> "%~dp0getnightly.py"
echo.file_id = fid['%cpwhl%_%arch%']>>"%~dp0getnightly.py"
echo.file_name = 'Kivy-%master%.dev0_'>> "%~dp0getnightly.py"
echo.file_name += y + '-%cpwhl%-%cp%-%arch%.whl'>> "%~dp0getnightly.py"
echo.link = 'https://kivy.org/downloads/appveyor/kivy/'>> "%~dp0getnightly.py"
echo.link += file_id>> "%~dp0getnightly.py"
echo.p = op.join(>> "%~dp0getnightly.py"
echo.    op.dirname(op.abspath(__file__)),>> "%~dp0getnightly.py"
echo.    'whls', file_name.replace('%cp%', 'none')>> "%~dp0getnightly.py"
echo.)>> "%~dp0getnightly.py"
echo.try:>>"%~dp0getnightly.py"
echo.    wget.download(link, p)>> "%~dp0getnightly.py"
echo.except:>>"%~dp0getnightly.py"
echo.    with open(p, 'wb') as f:>>"%~dp0getnightly.py"
echo.        import ssl>>"%~dp0getnightly.py"
echo.        import urllib.request as ulib>>"%~dp0getnightly.py"
echo.        f.write(ulib.urlopen(>>"%~dp0getnightly.py"
echo.            link,>>"%~dp0getnightly.py"
echo.            context=ssl._create_unverified_context()>>"%~dp0getnightly.py"
echo.        ).read())>>"%~dp0getnightly.py"
echo.print('\nWheel downloaded...')>> "%~dp0getnightly.py"
echo.root = op.dirname(op.abspath(sys.executable))>> "%~dp0getnightly.py"
echo.whl = op.basename(max(>>"%~dp0getnightly.py"
echo.    glob.glob(root + '/whls/*.[Ww][Hh][Ll]*'),>>"%~dp0getnightly.py"
echo.    key=op.getctime>>"%~dp0getnightly.py"
echo.))>>"%~dp0getnightly.py"
echo.new = 'Kivy-%master%.dev0-%cpwhl%-none-%arch%.whl'>> "%~dp0getnightly.py"
echo.shutil.copy2(>> "%~dp0getnightly.py"
echo.    op.join(root, 'whls', whl),>> "%~dp0getnightly.py"
echo.    op.join(root, 'whls', new)>> "%~dp0getnightly.py"
echo.)>> "%~dp0getnightly.py"

"%~dp0python.exe" "%~dp0getnightly.py"
if not defined DEBUG (del "%~dp0getnightly.py")

if %first%==0 (
    if exist "%~dp0whls\Kivy-%master%.dev0-%cpwhl%-none-%arch%.whl" (
        "%~dp0python.exe" -m pip uninstall -y kivy
        "%~dp0python.exe" -m pip install "%~dp0whls\Kivy-%master%.dev0-%cpwhl%-none-%arch%.whl"
    ) else (
        echo %kilog% No nightly wheel is available yet!
    )
) else (
    "%~dp0python.exe" -m pip install "%~dp0whls\Kivy-%master%.dev0-%cpwhl%-none-%arch%.whl"
)
if !designer!==1 (
    "%~dp0python.exe" -m pip install https://github.com/kivy/kivy-designer/zipball/master
)
del /q "%~dp0whls\Kivy-%master%.dev0-%cpwhl%-none-%arch%.whl"

:kivyend
if not defined DEBUG (
    del /q "%~dp0msi.log"
)
set PATH=%~dp0;%~dp0Tools;%~dp0Scripts;%~dp0share\sdl2\bin;%~dp0Lib\idlelib;%PATH%

:: Check if Kivy can be imported, presume it can't
set has_error=1
"%~dp0python.exe" -c "import kivy" && set has_error=0

if %has_error%==0 (
    if not defined DEBUG (
        echo %kilog% Running touchtracer demo...
        "%~dp0python.exe" "%~dp0share\kivy-examples\demo\touchtracer\main.py"
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
    echo %kilog% Configuration created in "%~dp0config.kivyinstaller"
) else (
    echo %kilog% Kivy was not installed properly!
    pause
    exit /B 1
)

:mkshortcuts
:: Create a launcher that triggers kivy.bat remotely [BAT]
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
    "%~dp0python.exe" -m pip uninstall -y kivy
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
    "%~dp0python.exe" -m pip install -I -U https://github.com/kivy/kivy-designer/zipball/master
    goto end
) else if [%1]==[getgcc] (
    "%~dp0python.exe" -m pip install -I -U -i https://pypi.anaconda.org/carlkl/simple mingwpy
    start "" "https://kivy.org/docs/installation/installation-windows.html#use-development-kivy"
    goto end
) else if [%1]==[getmsvc] (
    %down% /transfer "GetVC++" "http://go.microsoft.com/fwlink/?LinkId=691126" "%~dp0visualcppbuildtools_full.exe"
    start %cd%\visualcppbuildtools_full.exe
    start "" "https://git.io/vyyhO"
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
echo %kilog% Running "python.exe %*"
"%~dp0python.exe" %*
if not %errorlevel%==0 (goto end)

:end
pause
exit

:console
echo.
echo ###############################################################################
@if not defined DEBUG (echo off)
"%~dp0python.exe" -c "import sys; print('.'.join(str(x) for x in sys.version_info[:3]))" > t
set /p python_version=<t
set kv_imp=import kivy;f=open('t','w');f.write(kivy
start "" /min /wait "%~dp0python.exe" -c "%kv_imp%.__version__);f.close()"
set /p kivy_version=<t
start "" /min /wait "%~dp0python.exe" -c "%kv_imp%.__date__);f.close()"
set /p wheel_version=<t
del t
echo - KivyInstaller: %installerversion%
echo - Python:        %python_version%
echo - Kivy:          %kivy_version%
echo - Wheel:         %wheel_version%
echo - Update Kivy:   %~n0 update or %~n0 updatemaster
echo - Examples:      share\kivy-examples
echo - Launch:        %~n0 main.py or python main.py
echo - Pack:          %~n0 pack "<abs path to .py>"
echo - Uninstall:     %~n0 uninstall
echo ###############################################################################
echo.
cmd
exit

:pack
:: Package simple Kivy apps (Standard library + Kivy+GLEW+ANGLE+SDL2+GST) [PY]
if not [%1]==[pack] (
    pause
    exit
)

:: Expected: kivy pack "%cd%\share\kivy-examples\demo\touchtracer\main.py"

:: Get .py name, fullpath folder, parent folder (for app name), then build
echo.import os, sys, subprocess> "%~dp0kvpack.py"
echo.from os.path import join, split>> "%~dp0kvpack.py"
echo.folder, main_name = split(sys.argv[1])>> "%~dp0kvpack.py"
echo.name = os.path.split(folder)[-1]>> "%~dp0kvpack.py"
echo.print(os.environ['kilog'] + ' Collecting data...')>> "%~dp0kvpack.py"
echo.subprocess.call([>> "%~dp0kvpack.py"
echo.    r'%~dp0python.exe', '-m', 'PyInstaller', '-y',>> "%~dp0kvpack.py"
echo.    '--debug', '--name', name, join(folder, main_name)>> "%~dp0kvpack.py"
echo.])>> "%~dp0kvpack.py"
echo.print(os.environ['kilog'] + ' Editing .spec file...')>> "%~dp0kvpack.py"
echo.gl = "from kivy.deps.glew import dep_bins as gl">> "%~dp0kvpack.py"
echo.sd = "from kivy.deps.sdl2 import dep_bins as sd">> "%~dp0kvpack.py"
echo.gs = (>> "%~dp0kvpack.py"
echo.    "try:\n    ">> "%~dp0kvpack.py"
echo.    "from kivy.deps.gstreamer import dep_bins as gs\n">> "%~dp0kvpack.py"
echo.    "except ImportError:\n    ">> "%~dp0kvpack.py"
echo.    "gs = []\n">> "%~dp0kvpack.py"
echo.)>> "%~dp0kvpack.py"
echo.ag = (>> "%~dp0kvpack.py"
echo.    "try:\n    ">> "%~dp0kvpack.py"
echo.    "from kivy.deps.angle import dep_bins as ag\n">> "%~dp0kvpack.py"
echo.    "except ImportError:\n    ">> "%~dp0kvpack.py"
echo.    "ag = []">> "%~dp0kvpack.py"
echo.)>> "%~dp0kvpack.py"
echo.try:>> "%~dp0kvpack.py"
echo.    import kivy.deps.gstreamer>> "%~dp0kvpack.py"
echo.except ImportError:>> "%~dp0kvpack.py"
echo.    gst = []>> "%~dp0kvpack.py"
echo.try:>> "%~dp0kvpack.py"
echo.    import kivy.deps.angle>> "%~dp0kvpack.py"
echo.except ImportError:>> "%~dp0kvpack.py"
echo.    ang = []>> "%~dp0kvpack.py"
echo.imp = '\n'.join([gl, sd, gs, ag, 'a = '])>> "%~dp0kvpack.py"
echo.t = "a.datas, *[Tree(p) for p in (gl + sd + gs + ag)],">> "%~dp0kvpack.py"
echo.with open(name + '.spec') as f:>> "%~dp0kvpack.py"
echo.    cont = f.read()>> "%~dp0kvpack.py"
echo.n = cont.replace('\na = ', imp).replace('a.datas,', t)>> "%~dp0kvpack.py"
echo.n = n.replace("T(exe,", "T(exe, Tree(r'"+folder+"'),")>> "%~dp0kvpack.py"
echo.with open(name + '.spec', 'w') as f:>> "%~dp0kvpack.py"
echo.    f.write(n)>> "%~dp0kvpack.py"
echo.print(os.environ['kilog'] + ' Packaging...')>> "%~dp0kvpack.py"
echo.subprocess.call([>> "%~dp0kvpack.py"
echo.    r'%~dp0python.exe', '-m', 'PyInstaller',>> "%~dp0kvpack.py"
echo.    name + '.spec', '-y'>> "%~dp0kvpack.py"
echo.])>> "%~dp0kvpack.py"
echo.print(os.environ['kilog'] + ' Done.')>> "%~dp0kvpack.py"

"%~dp0python.exe" "%~dp0kvpack.py" %2

if not defined DEBUG (del "%~dp0kvpack.py")
goto end
