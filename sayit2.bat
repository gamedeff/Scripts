@echo off

setlocal EnableDelayedExpansion

set "txt="
set NL=.^


chcp 866 >nul

for /f "delims=" %%A in ('weather.bat') do set "txt=!txt!%%A"


chcp 1251 >nul

for /f "delims=" %%A in ('my_currency.bat') do set "txt=!txt!!NL!%%A"



for /f "delims=" %%A in ('commodities.bat') do set "txt=!txt!!NL!%%A"


say_ru.bat "!txt!"