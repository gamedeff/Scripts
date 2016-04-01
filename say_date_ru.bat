rem @echo off

chcp 1251 >nul

rem for /f "delims=" %%A in ('datemonthrus.bat') do call say_ru.bat %%A

for /f "delims=" %%A in ('daterus.bat') do call say_ru.bat "%%A"


