KivyInstaller
=============

<img align="right" height="256" src="https://raw.githubusercontent.com/KeyWeeUsr/KivyInstaller/master/logo.png"/>

<a href="http://kivyinstaller.readthedocs.io/en/master/" target="_blank">
<img src="https://img.shields.io/badge/docs-master-brightgreen.svg" /></a>
<a href="https://ci.appveyor.com/project/KeyWeeUsr/KivyInstaller" target="_blank">
<img src="https://ci.appveyor.com/api/projects/status/bjusk0ueobr6d30x?svg=true" /></a>

_It ships Kivy right to you!_

Everyone can mess things up even with simple installation or update. In
version `1.8.0` there was a batch file for making things easier for beginners
or regular users, but this file disappeared as the wheel came in. KivyInstaller
is inspired by this `kivy.bat` file from old portable package with multiple new
functions.

Read the [docs](http://kivyinstaller.readthedocs.io/en/master/) or watch
a [video](https://youtu.be/ch_ILDBEaok) and find more features!

1. Create a folder for your Python and place `kivy.bat` inside.
   You can do so directly from the command line with:

        mkdir python
        bitsadmin /transfer "GetBatch" "https://git.io/vDDjn" "%cd%\kivy.bat"
        cd python

2. Run `kivy.bat`, select your Python and Kivy versions, wait.

3. Enjoy!
