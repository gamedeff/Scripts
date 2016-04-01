@if (@a==@b) @end /*

:: batch script portion

@echo off

setlocal

for /f "delims=" %%A in ('cscript /nologo /e:jscript "%~f0"') do echo.%%A

goto :EOF

:: JScript portion */

var speech = new ActiveXObject("SAPI.SpVoice");
if ( speech == null ) WSH.Echo("Speech not installed. Exit");
var voices = speech.GetVoices();
if ( voices.Count == 0 ) { WSH.Echo("Voices not installed. Exit."); WSH.Quit(0); }
WSH.Echo("Voices available: " + voices.Count);
for ( var i = 0; i < voices.Count; ++i) WSH.Echo(voices.Item(i).GetDescription());
WSH.Echo("Current Voice: " + speech.Voice.GetDescription());
