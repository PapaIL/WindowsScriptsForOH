@ECHO OFF
REM  ^^ Silence printing of all batch file commands

REM By papa, a script to install Mosquitto message service for Windows
REM     Includes downloading & installing the installer & extra .dll files that are needed

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

REM determine version of powershell on this computer in order to use right download method later
for /f "skip=3 tokens=2 delims=:" %%A in ('powershell -command "get-host"') do (
	set /a n=!n!+1
     set c=%%A
    if !n!==1 set PSVersion=!c!
  )
set PSVersion=!PSVersion: =!
set partVs=%PSVersion:.=&rem %

REM create the script that will be elevated to copy needed .dll files into the C:\Program Files (x86)\mosquitto\ mosquitto program folder
call :make_copyMQTT.bat

echo:
echo Mosquitto MQTT Message Service is often needed
echo      for Home Automation projects.
echo  It handles messaging between devices and OpenHAB.
echo:
echo  Installing Mosquitto on Windows can be challenging, matching a good install .exe 
echo     with installing the right versions of extra .dll files that Mosquitto needs.
echo:
echo      If you want details of what seems to work, go to:
echo   https://github.com/PapaIL/WindowsMosquittoFiles/blob/master/README.md

echo:

echo     The following script, %me%, is by papa,
ECHO      of Proboards DIY Home Automation at 
ECHO    http://homeautomation.proboards.com/
ECHO:

ECHO:
echo     %me% automates what worked for papa to install Mosquitto
echo:
echo          and it might help you succeed ...
echo:

rem create the file that will help test mosquitto at the end
call :make_pub.bat

pause

cls
echo:
echo:

set "service=mosquitto"

ECHO:
  ECHO   In the upcoming pop up permission window, please click "Yes"
  ECHO:
  ECHO       for attempting to stop any %service% service
  
  ECHO         that is currently installed and running.
ECHO:

pause

cls
echo:
echo:
REM Works
SET "svc=stop !service!"
powershell -command "&{start-process -verb RunAs 'net' $env:svc}"

pause

echo:

REM If needed, create work folder to hold downloaded files
if not exist "C:\~PapaFiles" mkdir "C:\~PapaFiles"

rem path to the RAW folder of the git project
SET "gitRaw=https://github.com/PapaIL/WindowsMosquittoFiles/raw/master/"

REM start downloading files into work folder C:\~PapaFiles
SET "File=README.md"
SET "destFolder=C:\~PapaFiles\"
call :FromTo

SET "File=libeay32.dll"
call :FromTo

SET "File=pthreadVC2.dll"
call :FromTo

SET "File=ssleay32.dll"
call :FromTo

SET "File=vcruntime140.dll"
call :FromTo

SET "File=libcrypto-1_1.dll"
call :FromTo

SET "File=libssl-1_1.dll"
call :FromTo

SET "File=msvcr120.dll"
call :FromTo

rem download version 1.4.15 of mosquitto installer
SET "File=mosquitto-1.4.15a-install-win32.exe"
call :FromTo

REM wait about 5 secs to be sure the files are downloaded & ready to be used
PING localhost -n 6 >NUL

rem Does the mosquitto installer .exe exist in the folder for downloads?
SET "sd=C:\~PapaFiles\mosquitto-1.4.15a-install-win32.exe"
if not exist "!sd!" (
  ECHO:
  ECHO Exiting because the expected Mosquitto installer !sd! does not exist.
  ECHO      Please find & run the Mosquitto install program.
  ECHO:

  EXIT /B
    )

cls
ECHO:
ECHO:
ECHO  Getting ready for the FIRST run to install Mosquitto message service ...
ECHO:
ECHO     When the installer window asks permission "to make changes in your device,"
ECHO 		 please click [YES] 
ECHO:

REM wait about 5 secs
PING localhost -n 6 >NUL

ECHO:
ECHO:

ECHO    Then in upcoming screens of the Mosquitto installer's window ...
ECHO:
ECHO    without your making any changes, left mouse click:
ECHO        [next]   [next]   [next]   [install]  [Finish]
ECHO:
ECHO  If the installer reports errors, just click [ok] for each.
ECHO:
ECHO    A later SECOND run of the install should finish without errors.
ECHO:

ECHO   Press any key to start the Mosquitto installer, first run.
PAUSE >nul

rem the mosquitto installer exists, run it
start !sd!

REM wait about 9 secs
PING localhost -n 10 >NUL

ECHO:
ECHO:
ECHO:
ECHO    Only after you click the installer's [Finish] button ...
ECHO:
ECHO        press any key to continue.
ECHO:
PAUSE >nul

cls
ECHO:
ECHO:
ECHO        In the upcoming window, please click [YES]
ECHO to permit needed .dll files to copy into the mosquitto program folder.
ECHO:

pause

rem works from unelevated batch file to copy downloaded dll files to C:\Program Files (x86)\mosquitto\!!!
powershell -command "&{start-process -verb RunAs 'copyMQTT'}"

cls
ECHO:
ECHO:
ECHO      Needed  .dll files should be installed.
ECHO:
ECHO        Checking one of them as an example ...
ECHO:

rem pause

REM wait about 5 secs to be sure the files are copied & ready to be used
PING localhost -n 6 >NUL

  ECHO:

  ECHO   Install of Mosquitto's extra .dll files was
If exist "C:\Program Files (x86)\mosquitto\libeay32.dll" (
  ECHO       probably successful because %me%
    ECHO  looked and found the one example .dll file was copied.
  ECHO:
  
  ) else (
  ECHO       NOT SUCCESSFUL.
  )
  echo:
  
pause

cls
ECHO:
ECHO:
ECHO  Getting ready for the SECOND run to install Mosquitto message service ...
ECHO:
ECHO     When the installer window asks permission "to make changes in your device,"
ECHO 		 please click [YES] 
ECHO:

REM wait about 5 secs
PING localhost -n 6 >NUL

ECHO:
ECHO:

ECHO    Again in upcoming screens of the Mosquitto installer's window ...
ECHO:
ECHO    without your making any changes, left mouse click:
ECHO       [next]   [next]   [next]   [install]  [Finish]
ECHO:
ECHO:

ECHO   Press any key to start the Mosquitto installer, second run.
PAUSE >nul

rem run the mosquitto installer for the second and we hope final time
start !sd!

REM wait about 9 secs
PING localhost -n 10 >NUL

ECHO:
ECHO:
ECHO:
ECHO    Only after you click the installer's [Finish] button ...
ECHO:
ECHO        press any key to continue.
ECHO:
PAUSE >nul

cls
echo:
echo:

set "service=mosquitto"

ECHO:
  ECHO   In the upcoming pop up permission window, please click "Yes"
  ECHO:
  ECHO       for attempting to start the %service% service.
  ECHO:

pause

REM Works
SET "svc=start !service!"
powershell -command "&{start-process -verb RunAs 'net' $env:svc}"

cls
echo:
echo:

ECHO  Mosquitto service should be installed and running.
ECHO:
ECHO:
ECHO  Let's wait a few seconds and then we'll test Mosquitto service.

REM wait about 9 secs
PING localhost -n 10 >NUL

ECHO:
ECHO:
ECHO  Press any key to test that Mosquitto service is working

pause >nul
ECHO:
ECHO:

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

ECHO      %me% script has finished.
ECHO:

EXIT /B

EXIT /B

rem ========================================
rem End of main program, start of functions to be called

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

:make_copyMQTT.bat

REM Create the copyMQTT.bat file with the first line
ECHO copy "C:\~PapaFiles\README.md" "C:\Program Files (x86)\mosquitto\">copyMQTT.bat
REM Append blank line to the file
ECHO: >>copyMQTT.bat
ECHO copy "C:\~PapaFiles\pthreadVC2.dll" "C:\Program Files (x86)\mosquitto\">>copyMQTT.bat
ECHO: >>copyMQTT.bat
ECHO copy "C:\~PapaFiles\vcruntime140.dll" "C:\Program Files (x86)\mosquitto\">>copyMQTT.bat
ECHO: >>copyMQTT.bat
ECHO copy "C:\~PapaFiles\ssleay32.dll" "C:\Program Files (x86)\mosquitto\">>copyMQTT.bat
ECHO: >>copyMQTT.bat
ECHO copy "C:\~PapaFiles\libeay32.dll" "C:\Program Files (x86)\mosquitto\">>copyMQTT.bat
ECHO: >>copyMQTT.bat
ECHO copy "C:\~PapaFiles\libcrypto-1_1.dll" "C:\Program Files (x86)\mosquitto\">>copyMQTT.bat
ECHO: >>copyMQTT.bat
ECHO copy "C:\~PapaFiles\libssl-1_1.dll" "C:\Program Files (x86)\mosquitto\">>copyMQTT.bat
ECHO: >>copyMQTT.bat
ECHO copy "C:\~PapaFiles\msvcr120.dll" "C:\Program Files (x86)\mosquitto\">>copyMQTT.bat
ECHO: >>copyMQTT.bat

EXIT /B

rem set up copy from downloaded web file to local file. Call sets File & destFolder
:FromTo

cls
rem (from) web file to download
SET "sf=!gitRaw!!File!"
rem SET "sf=https://github.com/PapaIL/WindowsMosquittoFiles/archive/master.zip"

rem destination file to create on local computer, including path
SET "df=!destFolder!!File!"
rem SET "df=!destFolder!master.zip"

SET "sd=!df!"

rem if ok, download the file to its destination directory
rem call :DownOrNot
call :DownIt

EXIT /B

:DownOrNot
REM if the local file already exists, ask to overwrite it
echo       !df!
call :CkFolderFile "This ^^ file " "exists and a download will overwrite it." "does not exist yet." "        This download will install a new !File!."

rem 0 means file exists locally & choosing download will overwrite
rem 1 means file does not exist locally yet
IF !FLAG3! EQU 1 (
	call :DownIt
) else (
	call :RUsure "Do you want to overwrite !File! with a new copy? "
   IF !choice! EQU Y call :DownIt
   )   

EXIT /B %ERRORLEVEL%

:RUsure
 
 REM wait about 2 secs to debounce
PING localhost -n 1 >NUL

REM  Get specific key input into !choice!. /i case insensitive
SET "choice="
:again
	echo:
    echo %~1
	echo:
   echo     Please enter Y for Yes or N for No
   echo:
   set answer=
   set /p answer="____[Y]es or [N]o ? "
    if /i "%answer:~,1%" EQU "Y" (
	 SET "choice=Y"
			EXIT /B
	) else (
         SET "choice=N"
			EXIT /B
		)
 goto again
 
 EXIT /B

:DownIt

rem replaces any existing file with the same name
echo:
echo downloading from !sf!
echo      downloading to !df!
echo:

REM wait about 3 secs for above message to be seen
PING localhost -n 2 >NUL

rem choose download code based on this computer's powershell version
if !partVs! GTR 2 call :DownIt3
if !partVs! LSS 3 call :DownIt2

EXIT /B

:DownIt2

REM powershell download for powershell version less than 3.  partVs holds whole number part of version
rem echo partVs= !partVs!

PowerShell (New-Object System.Net.WebClient).DownloadFile($env:sf,$env:df)
)

EXIT /B

:DownIt3

REM powershell download for powershell version greater than 2.  partVs holds whole number part of version
rem echo partVs= !partVs!

rem works: tells .Net to use TLS1.2 security protocol to avoid download glitches, then downloads
Powershell -command "&{$tls12 = [Enum]::ToObject([Net.SecurityProtocolType], 3072); [Net.ServicePointManager]::SecurityProtocol = $tls12;Invoke-WebRequest -uri $env:sf -outfile $env:df -verbose}"

EXIT /B

 
:CkFolderFile

rem checks if the sd folder or file exists & sets a flag accordingly
IF EXIST !sd! (
REM flag that file or folder was found, so no error
SET "FLAG3=0"

ECHO:
ECHO  - %~1 %~2

 ) ELSE (
REM flag that file or folder was NOT FOUND, so error
SET "FLAG3=1"

ECHO:
ECHO  - %~1 %~3
ECHO:
ECHO %~4
)

EXIT /B