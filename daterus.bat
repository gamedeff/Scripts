@if (@a==@b) @end /*

:: batch script portion

@echo off

setlocal

chcp 1251 >nul

set /a y=%date:~6,4%&set /a m=1%date:~3,2%-100&set /a d=1%date:~0,2%-100
set /a i=(%y%-1901)*365 + (%y%-1901)/4 + %d% + (!(%y% %% 4))*(!((%m%-3)^&16))
set /a i=(%i%+(%m%-1)*30+2*(!((%m%-7)^&16))-1+((65611044^>^>(2*%m%))^&3))%%7+1
::  (igor_andreev)
for /f "tokens=%i% delims=/" %%a in ('
echo/Понедельник/Вторник/Среда/Четверг/Пятница/Суббота/Воскресенье') do set "w=%%a"

for /f "delims=" %%A in ('cscript /nologo /e:jscript "%~f0" "%date%"') do echo Сегодня %w%, %%A

goto :EOF

:: JScript portion */

if(!String.prototype.trim) {
	String.prototype.trim = function() {
		return this.replace(/^\s+|\s+$/g,'');
		}
}

if(!String.prototype.contains) {
	String.prototype.contains = function(it) { return this.indexOf(it) != -1; };
}

if(!String.prototype.replaceAll) {
	String.prototype.replaceAll = function(search, replacement) {
		var target = this;
		return target.split(search).join(replacement);
	}
}

function strConv(txt, sourceCharset, destCharset)
{
    with(new ActiveXObject("ADODB.Stream"))
    {
        type=2, mode=3, charset=destCharset;
        open();
        writeText(txt);
        position=0, charset=sourceCharset;
        return readText();
    }
}

function die(txt) {
    WSH.StdErr.WriteLine(txt.split(/\r?\n/).join(' '));
    WSH.Quit(1);
}

function get_obj(url)
{
	var x = new ActiveXObject("MSXML2.ServerXMLHTTP");
	x.open("GET", url, false);
	x.setRequestHeader('User-Agent','XMLHTTP/1.0');
	x.send('');
	var timeout = 60;
	for (var i = 20 * timeout; x.readyState != 4 && i >= 0; i--) {
		if (!i) die("Timeout error.");
		WSH.Sleep(50)
	};

	//if (!x.responseXML.hasChildNodes) die(x.responseText);

	return x;
}

function get(url)
{
	return get_obj(url).responseText;
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

var b = eval("unescape('" + x.responseText.substring(x.responseText.indexOf('"b":"<span>') + 11).split('<\\/span>",')[0] + "');").slice(0, -8);
var c = eval("unescape('" + x.responseText.substring(x.responseText.indexOf('"c":"<span>') + 11).replace('<\\/span>"}', "") + "');");

var w = get("https://ru.m.wikipedia.org/wiki/" + b.replace(" ", "_"));

//WSH.Echo(strConv(w,"ibm866","windows-1251"));

var HTMLDoc = new ActiveXObject("HTMLFile");

HTMLDoc.write(w);

WSH.Echo(strConv(HTMLDoc.getElementsByTagName("p")[1].innerText.replaceAll("года", "го-да").replace(b, c),"ibm866","windows-1251"));

var headline = HTMLDoc.getElementsByTagName("ul");//HTMLDoc.getElementsByClassName("mw-headline");

for(var i = 0; i < headline.length; i++) {
	if(headline[i])// && headline[i].innerText.contains("1 Праздники"))
	{
		var a = headline[i];
		//WSH.Echo(strConv(a.innerText,"ibm866","windows-1251"));

		for(var k = 0; k < a.childNodes.length; k++) {
			//if(a.childNodes[k])
				//WSH.Echo(strConv(a.childNodes[k].innerText,"ibm866","windows-1251"));
		}
	}
}

//WSH.Echo(strConv(a[0].innerText,"ibm866","windows-1251"));

//WSH.Echo(strConv(eval("unescape('" + x.responseText.substring(x.responseText.indexOf('"c":"<span>') + 11).replace('<\\/span>"}', "") + "');"),"ibm866","windows-1251"));
