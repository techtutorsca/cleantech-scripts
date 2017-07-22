rem ------------------------
rem AUTOCLEAN-STARTCLEAN.BAT
rem ------------------------

@echo off
chcp 65001
:: BatchGotAdmin 
:-------------------------------------
REM  --> Check for permissions
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"

REM --> If error flag set, we do not have admin.
if '%errorlevel%' NEQ '0' (
    echo Requesting administrative privileges...
    goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    echo UAC.ShellExecute "%~s0", "", "", "runas", 1 >> "%temp%\getadmin.vbs"

    "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
    if exist "%temp%\getadmin.vbs" ( del "%temp%\getadmin.vbs" )
    pushd "%CD%"
    CD /D "%~dp0"
:--------------------------------------

color 4f
    mode 100,35
	title TechTutor's Clean Up Script - Start Clean
 
    SETLOCAL EnableDelayedExpansion
	
	cls
	
	set horiz_line=-
	set dash=-
	
	for /L %%i in (0,1,88) do (
		set horiz_line=-!horiz_line!
	)
	
	echo %horiz_line%
	echo TechTutor's Clean Up Script - Start Clean
	echo %horiz_line%
	echo,

	echo Don't press any key until BootTimer is finished. Don't forget to write down the reported number!
	pause
	cls & color 1f

	echo Command running: set workingdir=c:%HOMEPATH%\Desktop\techtemp
	set workingdir=c:%HOMEPATH%\Desktop\techtemp
	echo Command running: cd %workingdir%
	cd %workingdir%
	echo,

	:echostrings
	echo -----------------------
	echo Client Info:
	echo Last Name: %1
	echo First name: %2
	echo Date: %3
	echo AV needed?: %4
	echo -----------------------
	echo,

	pause & color 6f

	echo if EXIST autoclean-adw goto :PCD
	pause
	if EXIST autoclean-adw goto :PCD
	echo if NOT EXIST autoclean-startclean goto :noflagfile
	pause
	if NOT EXIST autoclean-startclean goto :noflagfile
	echo if EXIST autoclean-startclean goto :adw
	pause
	if EXIST autoclean-startclean goto :adw
	
	:noflagfile
	color 1f
	echo at :noflagfile
	rem creating autoclean-start 'flag' file for next scripts to test for sucessful completion of this script
	echo copy /y NUL autoclean-startclean >NUL
	echo,
	copy /y NUL autoclean-startclean >NUL
	pause
	:goto adw

	rem Might not need this logic... But, leave in for now.
	:flagfile
	color 6f
	echo at :flagfile
	set /i /p interruptedq=Flag file exists. Did we have to restart before Tron was complete? (y/n): 
	if /i %interruptedq%==y color 1f & goto :starttron
	if /i %troncomplete%==n color 1f & goto :starttron
	goto :flagfile

	:adw
	echo at :adw
	echo Launching ADWCLeaner... NOTE: Will request reboot after a clean.
	echo Command: move %workingdir%\Tron\tron\resources\stage_9_manual_tools\adwcleaner*.exe %workingdir%\adwcleaner.exe
	move %workingdir%\Tron\tron\resources\stage_9_manual_tools\adwcleaner*.exe %workingdir%\adwcleaner.exe


	echo Command: START "" /WAIT %workingdir%\adwcleaner.exe
	START "" /WAIT %workingdir%\adwcleaner.exe
	echo,
	copy /y NUL autoclean-adw >NUL

	:PCD
	echo Command running: del autoclean-adw
	del autoclean-adw
	echo,

	echo Launching PC Decrapifier.....
	echo START "" /WAIT "%workingdir%\pc-decrapifier.exe"
	START "" /WAIT "%workingdir%\pc-decrapifier.exe"
	color 6f
	echo ---------------------------------------------------------
	echo Please use PC Decrapifier to analyze and remove bloatware
	echo ---------------------------------------------------------
	pause
	color 1f

	rem Removing autoclean-start flag file
	echo del autoclean-start
	echo,
	del autoclean-start

	rem Swapping startup batch files
	echo del "C:%HOMEPATH%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\autoclean-startcleantemp.bat"
	del "C:%HOMEPATH%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\autoclean-startcleantemp.bat"

	rem Save current shell key first...
	echo Command running: reg export "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Winlogon\Shell" %workingdir%\SavedShell.reg
	reg export "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Winlogon\Shell" %workingdir%\SavedShell.reg
	echo Comand running: echo %workingdir%\autoclean-tron.bat %1 %2 %3 %4>C:\autoclean-trontemp.bat
	echo %workingdir%\autoclean-tron.bat %1 %2 %3 %4>C:\autoclean-trontemp.bat
	echo Command running: reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v Shell /t REG_SZ /d "explorer.exe,c:\autoclean-trontemp.bat"
	reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v Shell /t REG_SZ /d "explorer.exe,c:\autoclean-trontemp.bat"
	pause

	bcdedit /set {default} safeboot network

	color 6f
	echo --------------------
	echo Preparing to reboot.
	echo -------------------- 
	echo,
	echo If tron does not start after reboot,
	echo please launch Tron using autoclean-tron.bat
	echo from the techtemp directory on the Desktop
	echo,
	pause

	shutdown /r /t 0