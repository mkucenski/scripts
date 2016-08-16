@echo off

FOR %%X IN (%*) DO (
	del "C:\Windows\System32\%%X"
)
