@echo off

setlocal EnableDelayedExpansion

set "txt="
set NL=.^


chcp 866 >nul

for /f "delims=" %%A in ('timerus.bat') do (
    set "z=%%A"
    set z=!z:"='!
    set "txt=!z!"
)


chcp 1251 >nul

for /f "delims=" %%A in ('daterus.bat') do set "txt=!txt!!NL!%%A"


say_ru.bat "!txt!"