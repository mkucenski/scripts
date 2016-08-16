@echo off

set src=%1%
set dst=%2%
echo Source: %src%
echo Dest: %dst%

call :fcivAdd
call :robocopy
call :fcivVerify

exit /b

:fcivAdd
echo :fcivAdd
pushd %src%
mkdir fciv
del /Q fciv.xml fciv.err .\fciv\fciv.xml .\fciv\fciv.err
fciv -add .\ -r -md5 -xml .\fciv\fciv.xml 2>> .\fciv\fciv.log
move /Y fciv.err .\fciv\
popd
exit /b

:fcivVerify
echo :fcivVerify
pushd %dst%
fciv -v -md5 -xml .\fciv\fciv.xml 2>> .\fciv\fciv.log
popd
exit /b

:robocopy
echo :robocopy
pushd %src%
mkdir robocopy
robocopy /E /J /LOG+:%src%\robocopy\robocopy.log %src% %dst%
copy %src%\robocopy\robocopy.log %dst%\robocopy\
popd
exit /b