rem @echo off

rem chcp 1251 >nul

for /f "delims=" %%A in ('weather.bat') do call say_ru.bat "%%A"
