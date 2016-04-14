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
	var n = str.replace(" " + a, "").split('=')[w].trim().split('.');
	var u = [ get_by(a, currency_list, 0, 2, 0).toLowerCase(), get_by(a, currency_frac_list, 1, 6, 8).toLowerCase() ];

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


//var gas = get("http://www.oil-price.net/widgets/natural_gas_text/gen.php?lang=ru").replaceAll("document.writeln('", "").replaceAll("');", "").replaceAll("\\/", "/");
var commodities = get("http://www.oil-price.net/COMMODITIES/gen.php?lang=en").replaceAll("document.writeln('", "").replaceAll("');", "").replaceAll("\\/", "/");

var HTMLDoc = new ActiveXObject("HTMLFile");

//HTMLDoc.write(eval(gas));
HTMLDoc.write(commodities);

var res = [];
var names = [ "Crude Oil", "Natural Gas", "Gasoline", "", "Gold", "Silver", "Copper" ];
var names_ru = [ "Нефть", "Природный газ", "Бензин", "", "Зо-лото", "Серебро", "Медь" ];

for (var i = 0; i < names.length; i++) {
	if(names[i])
		res[i] = HTMLDoc.getElementsByTagName("td")[i*3 + 0].innerText.trim().replace(names[i], names_ru[i]) + " - " + get_currency_name_morph(HTMLDoc.getElementsByTagName("td")[i*3 + 1].innerText, "USD", 0, currency_list, currency_frac_list) + " (" + HTMLDoc.getElementsByTagName("td")[i*3 + 2].innerText.trim().replace(".", ",") + "%)";
}

 
 //WSH.Echo(res);

WSH.Echo(strConv(res.join("\n"), "ibm866", "windows-1251"));
