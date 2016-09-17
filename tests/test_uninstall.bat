set DEBUG=1
set choice_pipcache=y
set choice_dist=y

:: set 'choice_uninstall' with pipe to silence other 'set /p'
(echo y)|kivy uninstall
