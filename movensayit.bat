@echo off

nircmd.exe mutesysvolume 0
rem nircmd.exe setsysvolume 6000

rem nircmd.exe setcursor 1910 0
rem nircmd.exe wait 1000
rem nircmd.exe movecursor 10 0
rem nircmd.exe wait 1000
rem nircmd.exe movecursor 0 10

nircmd.exe sendkeypress lwin+c

call sayit1.bat
call sayit2.bat

rem nircmd.exe setsysvolume 0
nircmd.exe mutesysvolume 1
