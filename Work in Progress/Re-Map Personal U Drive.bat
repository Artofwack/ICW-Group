SET user=%{[environment]::username}%

net use x: /delete
net use x: \\sancfs001.icwgrp.com\icwusers$\%user% /persistent:yes