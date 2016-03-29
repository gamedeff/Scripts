rem @echo off

chcp 1251 >nul

rem for /F %%i in ('time /t') do speak.exe %1 "%%i"

rem for /F "delims=" %%i in ('time ^<nul ^| cmd /q /v:on /c "set/p .=&echo(!.!"') do say_ru.bat "%%i"

rem set HH=%TIME: =0%
rem set HH=%HH:~0,2%

set HH=%time:~0,2%
if "%HH:~,1%"=="0" set HH=%HH:~1,2%
set MI=%time:~3,2%
if "%MI:~,1%"=="0" set MI=%MI:~1,2%

say_ru.bat "Текущее время: <rate absspeed="3"><emph>%HH%<t1><hr></emph> часов <emph>%MI%<t1><min></emph> минут</rate>"