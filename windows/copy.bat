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
robocopy /R:3 /W:10 /E /J /LOG+:.\robocopy\robocopy.log /TEE %src% %dst%
popd
exit /b