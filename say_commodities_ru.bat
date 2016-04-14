rem @echo off

chcp 1251 >nul

for /f "delims=" %%A in ('commodities.bat') do call say_ru.bat "%%A"


