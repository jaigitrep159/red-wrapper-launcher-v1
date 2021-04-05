:: Launcher made by Jaime, original lvm mod clone by: RedFireAnimations.

title RedWrapper Launcher v1 (Launching...)

::::::::::::::::::::
:: Initialization ::
::::::::::::::::::::

:: Stop commands from spamming stuff, cleans up the screen
@echo off && cls

:: Lets variables work or something idk im not a nerd
SETLOCAL ENABLEDELAYEDEXPANSION

::::::::::::::::::::::
:: Dependency Check ::
::::::::::::::::::::::

:: Preload variables
set NEEDTHEDEPENDERS=n
set ADMINREQUIRED=n
set FLASH_DETECTED=n
set FLASH_CHROMIUM_DETECTED=n
set BROWSER_TYPE=chrome

:: Flash Player
if exist "!windir!\SysWOW64\Macromed\Flash\*pepper.exe" set FLASH_CHROMIUM_DETECTED=y
if exist "!windir!\System32\Macromed\Flash\*pepper.exe" set FLASH_CHROMIUM_DETECTED=y
	if !FLASH_CHROMIUM_DETECTED!==n (
		echo Flash for Chrome could not be found.
		echo:
		set NEEDTHEDEPENDERS=y
		set ADMINREQUIRED=y
		set FLASH_DETECTED=n
		goto flash_checked
	) else (
		echo Flash is installed.
		echo:
		set FLASH_DETECTED=y
		goto flash_checked
	)
)
:flash_checked

::::::::::::::::::::::::
:: Dependency Install ::
::::::::::::::::::::::::

if !NEEDTHEDEPENDERS!==y (
	echo:
	echo Installing missing dependencies...
	echo:
) else (
	goto skip_dependency_install
)

title Installing dependencies...

:: Preload variables
set INSTALL_FLAGS=ALLUSERS=1 /norestart
set SAFE_MODE=n
if /i "!SAFEBOOT_OPTION!"=="MINIMAL" set SAFE_MODE=y
if /i "!SAFEBOOT_OPTION!"=="NETWORK" set SAFE_MODE=y
set CPU_ARCHITECTURE=what
if /i "!processor_architecture!"=="x86" set CPU_ARCHITECTURE=32
if /i "!processor_architecture!"=="AMD64" set CPU_ARCHITECTURE=64
if /i "!PROCESSOR_ARCHITEW6432!"=="AMD64" set CPU_ARCHITECTURE=64

:: Check for admin if installing Flash or Node.js
:: Skipped in Safe Mode, just in case anyone is running Wrapper in safe mode... for some reason
:: and also because that was just there in the code i used for this and i was like "eh screw it why remove it"
if !ADMINREQUIRED!==y (
	if !VERBOSEWRAPPER!==y ( echo Checking for Administrator rights... && echo:)
	if /i not "!SAFE_MODE!"=="y" (
		fsutil dirty query !systemdrive! >NUL 2>&1
		if /i not !ERRORLEVEL!==0 (
			color cf
			echo:
			cls
			echo ERROR
			echo:
			if !FLASH_DETECTED!==n (
				echo Wrapper: Inline needs to install Flash.
			)
			echo To do this, it must be started with Admin rights.
			echo:
			echo Close this window and re-open RedWrapper Launcher as an Admin.
			echo ^(right-click windows-open.bat and click "Run as Administrator"^)
			echo:
			if !DRYRUN!==y (
				echo ...yep, dry run is going great so far, let's skip the exit
				pause
				goto postadmincheck
			)
			pause
			exit
		)
	)
	if !VERBOSEWRAPPER!==y ( echo Admin rights detected. && echo:)
)
:postadmincheck

:: Flash Player
if !FLASH_DETECTED!==n (
	:start_flash_install
	echo Installing Flash Player...
		set BROWSER_TYPE=chrome && if !VERBOSEWRAPPER!==y ( echo Chromium-based browser picked. && echo:) && goto escape_browser_ask
	)

	:escape_browser_ask
	echo To install Flash Player, the script must kill any currently running web browsers.
	echo Please make sure any work in your browser is saved before proceeding.
	echo The script will not continue until you press a key.
	echo:
	pause
	echo:

	:: Summon the Browser Slayer
	for %%i in (firefox,palemoon,iexplore,microsoftedge,chrome,chrome64,opera,brave) do (
			 taskkill /f /im %%i.exe /t >nul
			 wmic process where name="%%i.exe" call terminate >nul
		)
	:lurebrowserslayer
	echo:

		echo Starting Flash for Chrome installer...
		if not exist "%~dp0\utilities\installers\flash_windows_chromium.msi" (
			echo ...erm. Bit of an issue there actually. The installer doesn't exist.
			echo A normal copy of this should have come with one.
			echo You may be able to find a copy on this website:
			echo https://helpx.adobe.com/flash-player/kb/archived-flash-player-versions.html
			echo Although Flash is needed, the script will continue.
			pause
		) else (
			msiexec /i "%~dp0\utilities\installers\flash_windows_chromium.msi" !INSTALL_FLAGS! /quiet
		)
	echo Flash has been installed.
	echo:
)
:after_flash_install

:: Alert user to restart Wrapper without running as Admin
if !ADMINREQUIRED!==y (
	color 20
	if !VERBOSEWRAPPER!==n ( cls )
	echo:
	echo Dependencies needing Admin now installed^^!
	echo:
	echo The script no longer needs Admin rights,
	echo please restart normally by double-clicking.
	echo:
	echo If you saw this from running normally,
	echo The script should continue normally after a restart.
	
)
color 0f
echo All dependencies now installed^^!
echo:

:skip_dependency_install

::::::::::::::::::::::
:: Starting Wrapper ::
::::::::::::::::::::::

title Loading...

:: Open Wrapper in preferred browser
	echo Opening RedWrapper Inline using included Chromium...
	pushd utilities\ungoogled-chromium
	start chrome.exe --user-data-dir=the_profile --app=https://redfirewrapper.herokuapp.com/html/list.html
	popd