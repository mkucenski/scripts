@echo off

set src=%1%
set dst=%2%
echo Source: %src%
echo Dest:   %dst%

:: /R:n		number of Retries on failed copies: default 1 million.
:: /W:n		Wait time between retries: default is 30 seconds.
:: /S		copy Subdirectories, but not empty ones.
:: /Z		copy files in restartable mode.
:: /J		copy using unbuffered I/O (recommended for large files).
:: /MT[:n] 	Do multi-threaded copies with n threads (default 8).
::		n must be at least 1 and not greater than 128.
::		This option is incompatible with the /IPG and /EFSRAW options.
::		Redirect output using /LOG option for better performance.
:: /E 		copy subdirectories, including Empty ones.
:: /LOG+:file	output status to LOG file (append to existing log).

pushd %dst%
robocopy /R:3 /W:10 /S /Z /J /MT:4 /E /LOG+:.\robocopy.log %src% %dst%
popd

pause

exit /b
