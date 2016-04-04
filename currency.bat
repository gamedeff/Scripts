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

if(!String.prototype.contains) {
	String.prototype.contains = function(it) { return this.indexOf(it) != -1; };
}

function die(txt) {
	WSH.StdErr.WriteLine(txt.split(/\r?\n/).join(' '));
	WSH.Quit(1);
}

function get_currency_name_by_symbol(currency_symbol)
{
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
		if(currency_table[i].childNodes[2].innerText.contains(currency_symbol))
			return currency_table[i].childNodes[0].innerText;
	}

	return "Unknown currency"
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

//WSH.Echo(res);

var res_text = new Array(WSH.Arguments.length);

for(var a = 0; a < WSH.Arguments.length; a++)
{
	var n = res.replace(" " + WSH.Arguments(a), "").split('=')[a].trim().split('.');
	var u = [ get_currency_name_by_symbol(WSH.Arguments(a)).toLowerCase(), "копейка" ];

	// better use https://github.com/javadev/moneytostr-russian/tree/master/src/main/js

	var r = new Array(n.length);

	for(var i = 0; i < n.length; i++)
	{
		if(i == 1)
			n[i] = n[i].substr(0, 2);

		if(n[i] == "1" && i == 0)
		{
			r[i] = u[i];
		}
		else
		{
			x.open("GET", "http://api.morpher.ru/WebService.asmx/Propis?n=" + n[i] + "&unit=" + u[i], false);
			x.setRequestHeader('User-Agent','XMLHTTP/1.0');
			x.send('');
			for (var k = 20 * timeout; x.readyState != 4 && k >= 0; k--) {
				if (!k) die("Timeout error.");
				WSH.Sleep(50)
			};

			if (!x.responseXML.hasChildNodes)
				die(x.responseText);

			r[i] = x.responseXML.getElementsByTagName('И')[0].text + " " + 
				   x.responseXML.getElementsByTagName('И')[1].text;
		}
	}

	res_text[a] = r.join(" ");
}

WSH.Echo(res_text.join(" - "));
