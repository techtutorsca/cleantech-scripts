:: ------------------
:: Autoclean-Tron.bat
:: ------------------

@echo off
:: BatchGotAdmin 
:-------------------------------------
::  --> Check for permissions
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"

:: --> If error flag set, we do not have admin.
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
    color 1f
    mode 100,35
	title CleanTech - Tron
 
    SETLOCAL EnableDelayedExpansion
	
	cls
	
	set horiz_line=-
	set dash=-
	
	for /L %%i in (0,1,88) do (
		set horiz_line=-!horiz_line!
	)
	
	echo %horiz_line%
	echo CleanTech - Tron Stage
	echo %horiz_line%
	echo,
	
	set "workingdir=C:\CleanTechTemp"
	echo cd "C:\CleanTechTemp"
	cd "C:\CleanTechTemp"

	tac_debugmode=rem nothing to see here

	:echostrings
		color E0
		echo -----------------------
		echo Client Info:
		echo Last Name: %tac_lastname%
		echo First name: %tac_firstname%
		echo Date: %tac_FormattedDate%
		echo AV needed?: %no%
		echo Offline?: 
		echo -----------------------
		echo,

		set tac_lastname=%tac_lastname%
		set tac_firstname=%tac_firstname%
		set tac_FormattedDate=%tac_FormattedDate%
		set tac_offline=

		set "clientdir=%tac_workingdir%\%tac_lastname%-%tac_firstname%-%tac_FormattedDate%"


	echo Adding flags to text file
		echo "Tron Flags = %tac_lastname% %tac_firstname% %tac_FormattedDate% %no% %5 " >> %tac_workingdir%\CT-flags.txt
		echo,

	color 1f

	:nir
		%tac_workingdir%\nircmd\nircmd.exe win min process explorer.exe

			:reboot-prep
		echo Ensuring next boot is in normal mode...
		echo bcdedit /deletevalue {default} safeboot
		bcdedit /deletevalue {default} safeboot
		echo,

		:putshellback
		echo Removing trontemp batch file...
		del %tac_workingdir%\autoclean-trontemp.bat

		"C:\Program Files (x86)\TeamViewer\TeamViewer.exe" &

	echo Command running: reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v Shell /t REG_SZ /d explorer.exe /f
	reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v Shell /t REG_SZ /d explorer.exe /f
	%tac_debugmode%


		:: echo "Command running: REG IMPORT /f "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" "%clientdir%\PreStartClean-Winlogon.reg""
		:: REG IMPORT /f "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" "%clientdir%\PreStartClean-Winlogon.reg" /f
		pause

		echo Setting next stage batch file
		echo %tac_workingdir%\autoclean-finish.bat %tac_lastname% %tac_firstname% %tac_FormattedDate% %no% %5 >"%HOMEPATH%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\autoclean-finishtemp.bat"
		%tac_debugmode%

	:starttron
		echo Starting Tron...
		%tac_workingdir%\Tron\tron\Tron.bat -a -str -sdc
		echo,

	:: THIS IS NOT WORKING AS INTENDED RIGHT NOW -- if NOT exist "%tac_workingdir%\Tron\tron\resources\tron_stage.txt" (


		shutdown /r /t 0
	::	) else shutdown /r /t 0