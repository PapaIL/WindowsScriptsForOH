@ECHO OFF
REM  ^^ Silence printing of all batch file commands

REM Clear the screen
cls

REM  variable %me% =name of the script (without file extension).
SET me=%~n0

REM  SETLOCAL = don’t clobber existing variables after script exits.
REM ENABLEEXTENSIONS turns on helpful command processor extensions
SETLOCAL ENABLEEXTENSIONS
REM  delayedExpansion uses ! instead of % & evaluates at execution time, not parse time
REM    so variables work as desired in IF statements
setlocal EnableDelayedExpansion
REM  command line argument variables are * %0: the name of the script/program as called on the command line; always a non-empty value * %1: the first command line argument; empty if no arguments were provided
REM  variable %parent% = parent path to script. can use variable to make fully qualified filepaths to other files in the script's directory.
SET parent=%~dp0

echo parent= !parent!
echo:

call :make_pub.bat

echo:
echo This Windows batch file, !me!, by papa
echo   makes no changes in your computer,
echo  except to create the small Pub.bat file.
echo:
echo !me! tests your mosquitto MQTT message service
echo:
echo by subscribing to all messages on an arbitrary "house" topic
echo:
echo   then using Pub.bat (created by !me!)
echo:
echo to publish a message to the "house" topic.
echo:

echo        If successful, you should see ...
echo  "Your Mosquitto MQTT Message Service is working"
echo:
echo:

pause

ECHO:

REM execute the created Pub.bat that will publish to this file's mqtt subscription topic
rem worked in windows 7 & windows 10
rem start cmd.exe /c !parent!Pub.bat
start cmd.exe /c "!parent!Pub.bat"

REM subscribe to all messages with the house topic
"C:\Program Files (x86)\mosquitto\mosquitto_sub" -h 127.0.0.1 -t house/#

echo:
pause

EXIT /B

REM create .bat file that will publish to this file's mqtt subscription
:make_pub.bat

REM Create the Pub.bat file & create the first line
ECHO @ECHO OFF >Pub.bat
REM Append blank line to the file
ECHO: >>Pub.bat

REM batch line to publish test message to the "house" topic
ECHO "C:\Program Files (x86)\mosquitto\mosquitto_pub" -h 127.0.0.1 -m "     Yay, your Mosquitto MQTT Message Service is working" -t house/test -d >>Pub.bat
ECHO: >>Pub.bat

REM kill mosquitto subscription program so the batch will end with a command prompt
ECHO Taskkill /IM mosquitto_sub.exe /F >>Pub.bat

EXIT /B