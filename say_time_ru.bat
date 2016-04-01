@if (@a==@b) @end /*

:: batch script portion

@echo off

setlocal

chcp 1251 >nul

rem set HH=%TIME: =0%
rem set HH=%HH:~0,2%

set HH=%time:~0,2%
if "%HH:~,1%"=="0" set HH=%HH:~1,2%
set MI=%time:~3,2%
if "%MI:~,1%"=="0" set MI=%MI:~1,2%

say_ru.bat "“екущее врем€: <rate absspeed="3"><emph>%HH%<t1><hr></emph> часов <emph>%MI%<t1><min> минут</emph></rate>"

for /f "delims=" %%A in ('cscript /nologo /e:jscript "%~f0" "%HH%" "%MI%"') do echo.%%A

goto :EOF

:: JScript portion */

function declOfNum(number, titles)  
{  
    cases = [2, 0, 1, 1, 1, 2];  
    return titles[ (number%100>4 && number%100<20)? 2 : cases[(number%10<5)?number%10:5] ];  
}

var res = "“екущее врем€: <rate absspeed="3"><emph>" + WSH.Arguments(0) + "<t1><hr></emph> " + declOfNum(WSH.Arguments(0),['час','часа','часов']) + "<emph>" + WSH.Arguments(1) + "<t1><min> " + declOfNum(WSH.Arguments(1),['минута','минуты','минут']) + "</emph></rate>";

WSH.Echo(res);
