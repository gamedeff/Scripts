@echo off

chcp 1251 >nul

echo Курсы валют:

call currency.bat USD UAH RUB
call currency.bat EUR UAH