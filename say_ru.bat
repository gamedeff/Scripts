@set @x=0/*!&&@set @x=
@echo off
chcp 1251 >nul
setlocal enableDelayedExpansion
set "toSay=%~1"
echo.!toSay!
@ %windir%\System32\cscript.exe //nologo //e:javascript "%~dpnx0" "!toSay!"
endLocal
@goto :eof */

(v=new ActiveXObject('SAPI.SpVoice')).GetVoices()&&v.Speak('<lang langid="419"><volume level="3">' + WSH.Arguments(0) + '</volume></lang>');
