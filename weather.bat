@if (@a==@b) @end /*

:: batch script portion

@echo off

setlocal

set "url=https://p.ya.ru/kryvyi-rih"

rem chcp 1251 >nul
for /f "delims=" %%A in ('cscript /nologo /e:jscript "%~f0" "%url%"') do >nul chcp 1251& echo.%%A

rem for %%I in ("%url%") do >nul chcp 1251& cscript /nologo /e:jscript "%~f0" "%url%"

goto :EOF

:: JScript portion */

function die(txt) {
    WSH.StdErr.WriteLine(txt.split(/\r?\n/).join(' '));
    WSH.Quit(1);
}

//utf8 to 1251 converter (1 byte format, RU/EN support only + any other symbols) by drgluck
function utf8_decode (aa) {
    var bb = '', c = 0;
    for (var i = 0; i < aa.length; i++) {
        c = aa.charCodeAt(i);
        if (c > 127) {
            if (c > 1024) {
                if (c == 1025) {
                    c = 1016;
                } else if (c == 1105) {
                    c = 1032;
                }
                bb += String.fromCharCode(c - 848);
            }
        } else {
            bb += aa.charAt(i);
        }
    }
    return bb;
}

var x=new ActiveXObject("MSXML2.ServerXMLHTTP");
x.open("GET", WSH.Arguments(0), false);
x.setRequestHeader('User-Agent','XMLHTTP/1.0');
x.send('');
var timeout = 60;
for (var i = 20 * timeout; x.readyState != 4 && i >= 0; i--) {
    if (!i) die("Timeout error.");
    WSH.Sleep(50)
};

//if (!x.responseXML.hasChildNodes) die(x.responseText);

var HTMLDoc = new ActiveXObject("HTMLFile");
HTMLDoc.write(x.responseText);

var res = HTMLDoc.getElementsByClassName("today-forecast")[0].innerText + ", " +HTMLDoc.getElementsByClassName("temperature-wrapper")[0].innerText.replace("\n", "").replace("\r", "").replace("\n", "").replace("\r", "").replace("\u2009\u02DA", " \u00B0");

WSH.Echo(res.replace("/с", " в секунду"));
