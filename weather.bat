@if (@a==@b) @end /*

:: batch script portion

@echo off

setlocal

set "url=https://p.ya.ru/kryvyi-rih"

for %%I in ("%url%") do cscript /nologo /e:jscript "%~f0" "%url%"

goto :EOF

:: JScript portion */

function die(txt) {
    WSH.StdErr.WriteLine(txt.split(/\r?\n/).join(' '));
    WSH.Quit(1);
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

var res = HTMLDoc.getElementsByClassName("today-forecast")[0].innerText + ", " +HTMLDoc.getElementsByClassName("temperature-wrapper")[0].innerText.replace("\n", "").replace("\r", "").replace("\n", "").replace("\r", "").replace("\u2009\u02DA", " \u00B0").replace("м/с", "метра в секунду");

WSH.Echo(res);
