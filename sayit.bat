@echo off

setlocal EnableDelayedExpansion

set "txt="
set NL=.^


chcp 1251 >nul

for /f "delims=" %%A in ('daterus.bat') do set "txt=%%A"


chcp 866 >nul

for /f "delims=" %%A in ('timerus.bat') do (
    set "z=%%A"
    set z=!z:"='!
    set "txt=!txt!!NL!!z!"
)


chcp 866 >nul

for /f "delims=" %%A in ('weather.bat') do set "txt=!txt!!NL!%%A"


chcp 1251 >nul

for /f "delims=" %%A in ('my_currency.bat') do set "txt=!txt!!NL!%%A"



for /f "delims=" %%A in ('commodities.bat') do set "txt=!txt!!NL!%%A"


say_ru.bat "!txt!"