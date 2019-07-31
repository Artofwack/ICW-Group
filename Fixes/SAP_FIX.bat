@echo off

:: Place Services file in correct filepath
xcopy /s/y "\\sancfsino1.icwgrp.com\sap\SAPGUI_730\SAP_logon_fix\services" "C:\Windows\System32\drivers\etc\services"

:: Place INI file in correct filepath
xcopy /s/y "\\sancfsino1.icwgrp.com\sap\SAPGUI_730\SAP_logon_fix\saplogon.ini" "%USERPROFILE%\AppData\Roaming\SAP\Common\saplogon.ini"