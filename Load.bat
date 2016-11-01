echo on
cd C:\Users\HOME\Downloads\NSEDATA
set deldt=%date:~0,2%%date:~3,2%%date:~-4%
set delurl=https://www.nseindia.com/archives/equities/mto/MTO_%deldt%.DAT
SET "delFILENAME=%~dp0Download.csv"

Set mm=%date:~3,2%
If "%mm%" == "1" Set mmm=JAN
If "%mm%" == "2" Set mmm=FEB
If "%mm%" == "3" Set mmm=MAR
If "%mm%" == "4" Set mmm=APR
If "%mm%" == "5" Set mmm=MAY
If "%mm%" == "6" Set mmm=JUN
If "%mm%" == "7" Set mmm=JUL
If "%mm%" == "8" Set mmm=AUG
If "%mm%" == "9" Set mmm=SEP
If "%mm%" == "10" Set mmm=OCT
If "%mm%" == "11" Set mmm=NOV
If "%mm%" == "12" Set mmm=DEC
Set bhavdt=%date:~0,2%%mmm%%date:~-4%

Set bhurl=https://www.nseindia.com/content/historical/EQUITIES/2016/%mmm%/cm%bhavdt%bhav.csv.zip
SET "bhFILENAME=%~dp0bhavcopy.zip"

del %~dp0bhavcopy.zip
del %~dp0Download.csv
del %~dp0Download2.csv
del %~dp0cm%bhavdt%bhav.csv.zip
del %~dp0Delivery.csv
del %~dp0Daily.csv
del  %~dp0temp1.csv
del  %~dp0temp2.csv


:: Download & Process Delivery
bitsadmin.exe /transfer "Downloading.... Delivery File..." "%delurl%" "%delFILENAME%"

type Download.csv | find /v "Security Wise"  |find /v "MTO" |find /v "Trade Date" |find /v "Record Type"> temp.csv
echo Record Type,Sr No,Name of Security,Series,Quantity Traded,Deliverable Quantity(gross across client level),% of Deliverable Quantity to Traded Quantity >Delivery.csv
type temp.csv >> Delivery.csv
del temp.csv
del Download.csv

:: Download  & Process Bhavcopy

bitsadmin.exe /transfer "Downloading.... Bhav Copy File..." "%bhurl%" "%bhFILENAME%"
"C:\Program Files\WinRAR\winrar.exe" x %bhFILENAME% *.* %~dp0

ren %~dp0cm%bhavdt%bhav.csv Download2.csv
del %~dp0bhavcopy.zip


type Download2.csv | find /v "SYMBOL,SERIES,OPEN,HIGH,LOW,CLOSE,LAST,PREVCLOSE,TOTTRDQTY,TOTTRDVAL,TIMESTAMP,TOTALTRADES,ISIN," > temp2.csv
echo SYMBOL,SERIES,OPEN,HIGH,LOW,CLOSE,LAST,PREVCLOSE,TOTTRDQTY,TOTTRDVAL,TIMESTAMP,TOTALTRADES,ISIN, >Daily.csv
type  temp2.csv >>Daily.csv

del temp2.csv
del Download2.csv

:: Run SSIS Package

"C:\Program Files (x86)\Microsoft SQL Server\120\DTS\Binn\DTExec.exe" /f "C:\Users\HOME\Downloads\NSEDATA\ETL\NSEDATA\NSEDATA\Package.dtsx"

