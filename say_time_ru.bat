rem @echo off

setlocal EnableDelayedExpansion

for /f "delims=" %%A in ('timerus.bat') do (
    set "z=%%A"
    set z=!z:"='!
call say_ru.bat "!z!"
)


