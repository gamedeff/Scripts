@Echo Off

For /F "Tokens=1,2 Skip=1" %%i In ('WMIC Path Win32_LocalTime Get Month^,Year') Do If Not "%%j"=="" Set $Month=%%i&Set $Year=%%j
For /F "Tokens=%$Month% Delims=," %%i In ("������,�������,����,������,���,����,����,������,��������,�������,������,�������") Do Set $MonthName=%%i

Set /A $Season = ($Month-$Month/12*12)/3+1
Set /A $MonthInSeason = $Month-$Month/12*12-(%$Season%-1)*3+1
For /F "Tokens=%$MonthInSeason% Delims=," %%i In ("������,������,������") Do Set $MonthInSeasonName=%%i
For /F "Tokens=%$Season% Delims=," %%i In ("����,����*�,����,�����") Do Set $SeasonGenitive=%%i

Echo "�� ����� %$MonthName% - %$MonthInSeasonName% ����� %$SeasonGenitive%"