@echo off

set src=%~f1%
set logdst=%~f2%
echo Source: %src%
echo Log Dest: %logdst%

call :fcivAdd

exit /b

:fcivAdd
echo :fcivAdd
pushd "%logdst%"
fciv -add "%src%" -r -md5 -xml "%logdst%\fciv.xml" 2>> "%logdst%\fciv.log"
popd
exit /b