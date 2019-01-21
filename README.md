# WindowsScriptsForOH

These are Windows .bat files that can aid our installing & testing our installs of Windows OpenHAB 2 & related programs (like Mosquitto MQTT broker). Download the files to where you can find them & double click a file to run it.  Screens will progressively give you information (like what changes the .bat makes to your computer) & instructions.

MosquittoTest5.bat only tests your computer for a running & working Mosquitto service.

InstallMosquittoB.bat will download files from this GitHub & attempt to install a fairly recent version of Windows Mosquitto.  If that does not work, download 3 Microsoft Visual C++ Redistributable install files from another repository on this GitHub. Starting with the 2010 install file, run each file (but cancel if told the computer already has that package). Once finished with all 3 files, run InstallMosquittoB.bat again.
