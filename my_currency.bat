@echo off

chcp 1251 >nul

echo Курс валют:

call currency.bat USD UAH RUB
call currency.bat EUR UAH