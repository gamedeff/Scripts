@if (@a==@b) @end /*

:: batch script portion

@echo off

chcp 65001 >nul

setlocal

set /a y=%date:~6,4%&set /a m=1%date:~3,2%-100&set /a d=1%date:~0,2%-100
set /a i=(%y%-1901)*365 + (%y%-1901)/4 + %d% + (!(%y% %% 4))*(!((%m%-3)^&16))
set /a i=(%i%+(%m%-1)*30+2*(!((%m%-7)^&16))-1+((65611044^>^>(2*%m%))^&3))%%7+1
::  (igor_andreev)
for /f "tokens=%i% delims=/" %%a in ('
echo/Понедельник/Вторник/Среда/Четверг/Пятница/Суббота/Воскресенье') do set "w=%%a"

for /f "delims=" %%A in ('cscript /nologo /e:jscript "%~f0" "%date%"') do echo Сегодня %w%, %%A

goto :EOF

:: JScript portion */

function die(txt) {
    WSH.StdErr.WriteLine(txt.split(/\r?\n/).join(' '));
    WSH.Quit(1);
}

var x=new ActiveXObject("MSXML2.ServerXMLHTTP");
x.open("POST", "http://udarenieru.ru/desktop_1/ajax/datum.php", false);
x.setRequestHeader('User-Agent','XMLHTTP/1.0');
x.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
x.send('datum=' + WSH.Arguments(0) + '&decl=0');
var timeout = 60;
for (var i = 20 * timeout; x.readyState != 4 && i >= 0; i--) {
    if (!i) die("Timeout error.");
    WSH.Sleep(50)
};

//if (!x.responseXML.hasChildNodes) die(x.responseText);

WSH.Echo(eval("unescape('" + x.responseText.substring(x.responseText.indexOf('"c":"<span>') + 11).replace('<\\/span>"}', "") + "');"));
