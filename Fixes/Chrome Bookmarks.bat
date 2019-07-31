:: Copy Bookmarks file from previous chrome version location to new
:: apolanco 4/25/18

@echo off
xcopy /y "c:\users\%user_name%\appdata\Roaming\Chrome\Data\Default\Bookmarks"  "C:\Users\%user_name%\AppData\Local\Google\Chrome\User Data\Default\Bookmarks"