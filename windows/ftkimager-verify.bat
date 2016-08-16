@echo off

set image=%1%
set log=%2%
echo Image: %image%
echo Log: %log%

call :ftkimager

exit /b

:ftkimager
echo BEGIN: %DATE% >> %log%

echo Image: %image% >> %log%
echo Log: %log% >> %log%
"C:\Program Files (x86)\AccessData\ftkimager\ftkimager.exe" --print-info %image% 2>NUL
"C:\Program Files (x86)\AccessData\ftkimager\ftkimager.exe" --print-info %image% >> %log% 2>NUL
"c:\Program Files (x86)\AccessData\ftkimager\ftkimager.exe" --verify --quiet --no-sha1 %image% >> %log% 2>&1

echo END: %DATE% >> %log%
echo. >> %log%
exit /b