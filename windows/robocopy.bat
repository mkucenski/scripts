@echo off

set src=%1%
set dst=%2%
echo Source: %src%
echo Dest:   %dst%

pushd %dst%
robocopy /R:3 /W:10 /S /Z /J /MT:4 /E /TEE /LOG+:.\robocopy.log %src% %dst%
popd

pause

exit /b
