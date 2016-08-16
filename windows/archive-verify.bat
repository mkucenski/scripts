@echo off

set src=%1%
set dst=%2%
set tmp=H:\Temp\archive-verify

call :fcivAdd
call :archive
call :extractTemp
call :fcivVerify
call :deleteTemp

exit /b

:fcivAdd
pushd %src%
mkdir fciv
del /Q fciv.xml fciv.err .\fciv\fciv.xml .\fciv\fciv.err 2>> .\fciv\fciv.log
fciv -add .\ -r -md5 -xml .\fciv\fciv.xml 2>> .\fciv\fciv.log
move /Y fciv.err .\fciv\ 2>> .\fciv\fciv.log 2>> .\fciv\fciv.log
popd
exit /b

:fcivVerify
pushd %tmp%
fciv -v -md5 -xml .\fciv\fciv.xml 2>> .\fciv\fciv.log
popd
exit /b

:archive
del /Q %dst%
7z a -t7z -mx9 -bd %dst% %src%\* | find /V "ing  " 2>> .\fciv\7z.log
exit /b

:extractTemp
rmdir /S /Q %tmp%
mkdir %tmp%
pushd %tmp%
7z x %dst% | find /V "ing  " 2>> .\fciv\7z.log
echo %tmp%
popd
exit /b

:deleteTemp
rmdir /S /Q %tmp% 2>> .\fciv\7z.log
exit /b