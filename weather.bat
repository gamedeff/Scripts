@if (@a==@b) @end /*

:: batch script portion

@echo off
setlocal

set "url=https://p.ya.ru/kryvyi-rih"

rem for %%a in ('cscript /nologo /e:jscript "%~f0" "%url%" ^|^| goto :EOF') do echo %%a

for %%I in ("%url%") do cscript /nologo /e:jscript "%~f0" "%url%"

rem // end main runtime
goto :EOF

goto :EOF

:: JScript portion */

function checkXml (url) {
   var prefix = 'Msxml2';
   var versions = [ '3.0'];//, '4.0', '5.0', '6.0'];
   var ids = ['XMLHTTP', 'ServerXMLHTTP'];
   var result = [];
   for (var i = 0; i < versions.length; i++) {
     var version = versions[i];
     for (var j = 0; j < ids.length; j++) {
       var id = ids[j];
       var programId = prefix + '.' + id + '.' + version;
       result.push('Requesting ' + url + ' with ' + programId + ':');
       try {
         var httpRequest = new ActiveXObject(programId);
         httpRequest.open('GET', url, false);
         httpRequest.send(null);
         result.push('HTTP status code: ' + httpRequest.status + ' ' + 
httpRequest.statusText);
         if (httpRequest.responseXML && 
httpRequest.responseXML.parseError.errorCode == 0) {
           result.push('responseXML serialized:');
           result.push(httpRequest.responseXML.xml);
         }
       }
       catch (e) {
         result.push('Error ' + e.message + ' with ' + programId);
       }
       result.push('\r\n');
     }
   }
   return result.join('\r\n');
}

   for (var i = 0; i < WScript.Arguments.length; i++) {
     //WScript.Echo(checkXml(WScript.Arguments(i)));
   }

function die(txt) {
    WSH.StdErr.WriteLine(txt.split(/\r?\n/).join(' '));
    WSH.Quit(1);
}

function getElementByXpath(path) {
  return document.evaluate(path, document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null).singleNodeValue;
}

var normalize = function(a){
		// clean up double line breaks and spaces
		if(!a) return "";
		return a.replace(/ +/g, " ")
				.replace(/[\t]+/gm, "")
				.replace(/[ ]+$/gm, "")
				.replace(/^[ ]+/gm, "")
				.replace(/\n+/g, "\n")
				.replace(/\n+$/, "")
				.replace(/^\n+/, "")
				.replace(/\nNEWLINE\n/g, "\n\n")
				.replace(/NEWLINE\n/g, "\n\n"); // IE
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

WSH.Echo(HTMLDoc.getElementsByClassName("temperature-wrapper")[0].innerText.replace("\n", "").replace("\r", "").replace("\n", "").replace("\r", ""));

//var res = HTMLDoc.getElementsByTagName('div')[0].text();
//var res = getElementByXpath('.//node()[@class="today-forecast"]');
var res = HTMLDoc.getElementsByClassName("today-forecast")[0].innerText;

WSH.Echo(res);

// Note: These dom nodes are appropriate for getLiveWeatherRSS.aspx and
// getLiveCompactWeatherRSS.aspx.  For parsing other feeds, change the
// root XPath node appropriately.
var dom = x.responseXML;//, dom = dom.selectSingleNode('.//node()[@class="today-forecast"]');

//div class="temperature-wrapper"

//WSH.Echo(dom.join('\n'));
