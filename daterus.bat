@echo off
:: format: dd.mm.yyyy
:: ��������� �������� DOS (866)

rem echo %date%

set /a y=%date:~6,4%&set /a m=1%date:~3,2%-100&set /a d=1%date:~0,2%-100
set /a i=(%y%-1901)*365 + (%y%-1901)/4 + %d% + (!(%y% %% 4))*(!((%m%-3)^&16))
set /a i=(%i%+(%m%-1)*30+2*(!((%m%-7)^&16))-1+((65611044^>^>(2*%m%))^&3))%%7+1
::  (igor_andreev)
for /f "tokens=%i% delims=/" %%a in ('
echo/�����������/�������/�����/�������/�������/�������/�����������') do set "w=%%a"
for /f "tokens=%m% delims=/" %%a in ('
ECHO/������/�������/�����/������/���/����/����/�������/��������/�������/������/�������/') do set "mmm=%%a"
echo ������� %w%, %d% %mmm% %y% ����