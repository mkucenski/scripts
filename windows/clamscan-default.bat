@echo off

set scandir=%1%
set log=%2%

echo ------------------------------------------------------------------------------- >> %log%
date /t >> %log%
time /t >> %log%
echo ------------------------------------------------------------------------------- >> %log%
clamscan --version >> %log%
echo ------------------------------------------------------------------------------- >> %log%
sigtool --info="C:\Program Files\ClamAV\database\bytecode.cvd" >> %log%
echo ------------------------------------------------------------------------------- >> %log%
sigtool --info="C:\Program Files\ClamAV\database\daily.cvd" >> %log%
echo ------------------------------------------------------------------------------- >> %log%
sigtool --info="C:\Program Files\ClamAV\database\main.cvd" >> %log%
echo ------------------------------------------------------------------------------- >> %log%
echo Initiating scan on "%scandir%": >> %log%
clamscan --bell --log=%log% --recursive --allmatch=yes --infected --stdout %scandir%
echo ------------------------------------------------------------------------------- >> %log%
date /t >> %log%
time /t >> %log%
echo ------------------------------------------------------------------------------- >> %log%
