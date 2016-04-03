@set @x=0/*!&&@set @x=
@ %windir%\System32\cscript.exe //nologo //e:javascript "%~dpnx0" %*
@goto :eof */

var xmlhttp = new ActiveXObject('Microsoft.XMLHTTP');
xmlhttp.open('GET', 'http://ifconfig.me/ip', false);
xmlhttp.send();
 
var ip = xmlhttp.responseText;

WScript.Echo(ip);

WScript.Quit();