echo off

xcopy "c:\users\%username%\Desktop" "\\sancfs001.icwgrp.com\icwusers$\%username%\Win10-Backup\Desktop" /D /E /C /R /H /I /K /Y

::xcopy "c:\Documents and settings\%username%\Favorites" "\\sancfs001.icwgrp.com\%username%\Win10-Backup\Favorites" /D /E /C /R /H /I /K /Y