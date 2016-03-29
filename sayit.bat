rem @echo off

call say_date_ru.bat

call say_time_ru.bat

chcp 866 >nul

call say_weather_ru.bat





rem for /f "delims=_" %%A in ('call weather.bat') do call say_ru.bat "%%A"

rem chcp 1251 >nul

rem for /f "delims=" %%A in ('datemonthrus.bat') do >nul chcp 866& call say_ru.bat %%A

rem chcp 65001 >nul

rem for /f "delims=" %%A in ('^>nul chcp 1251^& call weather.bat') do call say_ru.bat "%%A"

rem >nul chcp 65001& call say_ru.bat "%%A"
