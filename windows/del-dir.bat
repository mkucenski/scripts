@echo off

set dst=
set areyousure=

for %%I in ("%1%") do (
	set dst="%%~fI"
)
echo Dest: %dst%

set /P areyousure="Are you sure you want to completely delete <%dst%> (Y/[N])?"
if /I "%areyousure%" NEQ "Y" goto end
call :del-dir
goto end

:del-dir
echo :del-dir
pushd "%TMP%"
mkdir "del-dir"
robocopy /MIR "del-dir" "%dst%"
rmdir "%dst%"
popd
goto :EOF

:end
exit /b