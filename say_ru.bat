:speak
@echo off 
chcp 1251 >nul
setlocal enableDelayedExpansion
set "toSay=%~1"
mshta "javascript:code(close((v=new ActiveXObject('SAPI.SpVoice')).GetVoices()&&v.Speak('<lang langid="419"><volume level="3">!toSay!</volume></lang>')))"
endLocal
