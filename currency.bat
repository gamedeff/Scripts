@if (@a==@b) @end /*

:: batch script portion

@echo off

setlocal

for /f "delims=" %%A in ('cscript /nologo /e:jscript "%~f0" %*') do echo.%%A

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

function get_xml(url)
{
	return get_obj(url).responseXML;
}

function get_by(s, list, ti, i1, i2)
{
	var HTMLDoc = new ActiveXObject("HTMLFile");
	HTMLDoc.write(list);

	var currency_table = HTMLDoc.getElementsByTagName("table")[ti].getElementsByTagName("tr");

	for (var i = 0; i < currency_table.length; i++) {
		if(currency_table[i].childNodes[i1] && currency_table[i].childNodes[i1].innerText.contains(s))
			return currency_table[i].childNodes[i2].innerText;
	}

	return "Unknown currency"
}

function get_currency_name_morph(str, a, w, currency_list, currency_frac_list)
{
	var n = str.replace(" " + WSH.Arguments(a), "").split('=')[w].trim().split('.');
	var u = [ get_by(WSH.Arguments(a), currency_list, 0, 2, 0).toLowerCase(), get_by(WSH.Arguments(a), currency_frac_list, 1, 6, 8).toLowerCase() ];

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
			var xml = get_xml("http://api.morpher.ru/WebService.asmx/Propis?n=" + n[i] + "&unit=" + u[i]);

			r[i] = xml.getElementsByTagName('И')[0].text + " " + 
				   xml.getElementsByTagName('И')[1].text;
		}
	}

	return r.join(" ");
}

var currency_list = get("https://ru.wikipedia.org/wiki/Список_знаков_валют");
var currency_frac_list = get("https://ru.wikipedia.org/wiki/Список_существующих_валют");

var res_first;
var res_text = new Array(WSH.Arguments.length - 1);

for(var a = 1; a < WSH.Arguments.length; a++)
{
	var HTMLDoc = new ActiveXObject("HTMLFile");
	HTMLDoc.write(get("https://www.google.com/finance/converter?a=1&from=" + WSH.Arguments(0) + "&to=" + WSH.Arguments(a)));

	var res = HTMLDoc.getElementById("currency_converter_result").innerText;

	//WSH.Echo(res);

	if(a == 1)
		res_first = get_currency_name_morph(res, 0, 0, currency_list, currency_frac_list);

	res_text[a - 1] = get_currency_name_morph(res, a, 1, currency_list, currency_frac_list);
}

WSH.Echo(strConv(res_first + " - " + res_text.join(" или "), "ibm866", "windows-1251"));
