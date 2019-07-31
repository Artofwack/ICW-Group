@Echo Off

::Force closes process is running
taskkill /IM iexplore.exe /f

::Delete IE Cookies
del /q /s C:\Users\%username%\AppData\Roaming\Microsoft\Windows\Cookies
del /q /s C:\Users\%username%\AppData\Roaming\Microsoft\Windows\Cookies\low\*
del /q /s "C:\Users\%username%\AppData\Local\Microsoft\Windows\Temporary Internet Files\*"

::Set Access data sources across domains to Enable
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\2" /v 1406 /t REG_DWORD /d 00000000 /f

:::PROD, the following report URL needs to be added:  https://wccert.icwgrp.com
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\icwgrp.com\wccert" /v https /t REG_DWORD /d 00000002 /f


::This sets IE Advanced Settings to check Enable Integrated Windows Authentication
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v EnableNegotiate /t REG_DWORD /d 00000001 /f

::Message popup
::msg "%username%" SIMS will now open. Please attempt to use Cert within the Reserves Module. If you continue to ::experience issues with Cert please take a screenshot of the error and email it to servicedesk@icwgroup.com.

::Start IE and automatically load SIMS
start iexplore https://lb-simsweb-prd.icwgrp.com/simsauth/default.aspx

End
