@echo off

set src=%1%
set dst=%2%
echo Source: %src%
echo Dest: %dst%

call :robocopy

exit /b

:robocopy
echo :robocopy
pushd %dst%
mkdir robocopy
robocopy /R:3 /W:10 /S /Z /J /MT:4 /XC /XO /XN /LOG+:.\robocopy\robocopy.log %src% %dst%
popd
exit /b