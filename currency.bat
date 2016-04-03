@if (@a==@b) @end /*

:: batch script portion

@echo off

setlocal

for /f "delims=" %%A in ('cscript /nologo /e:jscript "%~f0" "%~1" "%~2"') do echo.%%A

goto :EOF

:: JScript portion */

if(!String.prototype.trim) {
	String.prototype.trim = function() {
		return this.replace(/^\s+|\s+$/g,'');
		}
}

function die(txt) {
	WSH.StdErr.WriteLine(txt.split(/\r?\n/).join(' '));
	WSH.Quit(1);
}

function get_currency_name_by_symbol(currency_symbol) {
	var x = new ActiveXObject("MSXML2.ServerXMLHTTP");
	x.open("GET", "https://ru.wikipedia.org/wiki/Список_знаков_валют", false);
	x.setRequestHeader('User-Agent','XMLHTTP/1.0');
	x.send('');
	var timeout = 60;
	for (var i = 20 * timeout; x.readyState != 4 && i >= 0; i--) {
		if (!i) die("Timeout error.");
		WSH.Sleep(50)
	};

	var HTMLDoc = new ActiveXObject("HTMLFile");
	HTMLDoc.write(x.responseText);

	var currency_table = HTMLDoc.getElementsByTagName("table")[0].getElementsByTagName("tr");

	for (var i = 0; i < currency_table.length; i++) {
		if(currency_table[i].childNodes[2].innerText == currency_symbol)
			return currency_table[i].childNodes[0].innerText;
	}
}

var x = new ActiveXObject("MSXML2.ServerXMLHTTP");
x.open("GET", "https://www.google.com/finance/converter?a=1&from=" + WSH.Arguments(0) + "&to=" + WSH.Arguments(1), false);
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

var res = HTMLDoc.getElementById("currency_converter_result").innerText;

while(res.charCodeAt(res.length-1) == 32) {
	res = res.substr(0, res.length-1);
}

WSH.Echo(res);

var n = res.replace(" " + WSH.Arguments(1), "").replace(/^0+|0+$/g, "").split('=')[1].trim().split('.');
var u = [ get_currency_name_by_symbol(WSH.Arguments(1)), "копейка" ];

// better use https://github.com/javadev/moneytostr-russian/tree/master/src/main/js

var r = new Array(2);

for (var i = 0; i < n.length; i++) {
	x.open("GET", "http://api.morpher.ru/WebService.asmx/Propis?n=" + n[i] + "&unit=" + u[i], false);
	x.setRequestHeader('User-Agent','XMLHTTP/1.0');
	x.send('');
	for (var k = 20 * timeout; x.readyState != 4 && k >= 0; k--) {
		if (!k) die("Timeout error.");
		WSH.Sleep(50)
	};

	if (!x.responseXML.hasChildNodes)
		die(x.responseText);

	r[i] = x.responseXML.getElementsByTagName('И')[0].text + " " + x.responseXML.getElementsByTagName('И')[1].text;
}

WSH.Echo(r.join(" "));
