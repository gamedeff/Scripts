rem @echo off

chcp 1251 >nul

for /f "delims=" %%A in ('my_currency.bat') do call say_ru.bat "%%A"


