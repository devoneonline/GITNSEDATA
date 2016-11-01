echo on
set rptdt=%date:~0,2%%date:~3,2%%date:~-4%
set basepath=%~dp0

cd C:\Program Files (x86)\ibm\cognos\c10\webapps\utilities\trigger

NET START "IBM COGNOS"
call trigger.bat http://localhost:9300/p2pd/servlet/dispatch NSEDAILY
CD %basepath%

set num=0
:checkexist
IF NOT EXIST "%~dp0\Outputs\NSEDAILY-en-us.pdf" if %num% LEQ 24 (
ECHO.
ECHO Waiting 20 Sec for Report output...... times (%num%^)
ECHO.
TIMEOUT /t 20 /nobreak
set /a num+=1
GOTO checkexist
)
call Mail.vbs
move /y %~dp0\Outputs\NSEDAILY-en-us.pdf %~dp0\Outputs\NSEDAILY_%rptdt%.pdf


echo COMPLETED
ECHO.
ECHO.
timeout 500

