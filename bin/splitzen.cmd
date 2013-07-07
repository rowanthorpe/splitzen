@echo off

rem splitzen.cmd: file splitter in Windows batch script
rem  part of Splitzen package (see below)
rem
rem Splitzen: Drag-n-Drop splitting and rejoining
rem           for files, with file integrity checking
rem
rem  (c) Copyright 2010-2011,2013 Rowan Thorpe <rowan _at_ rowanthorpe [dot] com>
rem
rem    This program is free software: you can redistribute it and/or modify
rem    it under the terms of the GNU Affero General Public License as published by
rem    the Free Software Foundation, either version 3 of the License, or
rem    (at your option) any later version.
rem
rem    This program is distributed in the hope that it will be useful,
rem    but WITHOUT ANY WARRANTY; without even the implied warranty of
rem    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
rem    GNU Affero General Public License for more details.
rem
rem    You should have received a copy of the GNU Affero General Public License
rem    along with this program.  If not, see <http://www.gnu.org/licenses/>.

set retval=0
verify OTHER 2>nul
setlocal enableextensions enabledelayedexpansion
if ERRORLEVEL 1 (
	echo # splitzen: requires cmd.exe with extensions capability>&2
	goto die
)

set localconfname=%~n0-%COMPUTERNAME%.conf
set localconf=%~dp0%localconfname%
set debug=0
if exist "%localconf%" for /f "tokens=* delims=" %%a in ('findstr /i /b "debug=yes\>" %localconf%') do set debug=1
set interactive=1
set scriptname=%~nx0
set scriptdir=%~dp0
set funclevel=0
set funcname=main
set inthedir=0
set argname=
set argdir=
set defwholefile=
set wholefile=
set wholefileclean=
set isbinchecksum=0
set numsplitfiles=
set expectednumsplitfiles=
set response=
set respfirstletter=

call :dbgmsg "starting script"
call :parseoptions %*
if %ERRORLEVEL% equ 2 (
	call :usage
	goto return
)
if %ERRORLEVEL% equ 1 (
	call :usage>&2
	call :errmsg "problem parsing options"
	goto die
)
call :setdefaults || (
	call :errmsg "problem setting defaults"
	goto die
)
call :argexists || (
	call :confexists || (
		call :writeconf || (
			call :errmsg "problem writing config file"
			goto die
		)
	)
	goto return
)
call :confexists || (
	call :writeconf || (
		call :errmsg "problem writing config file"
		goto die
	)
)
call :askreset || goto endresetconf
call :writeconf || (
	call :errmsg "problem writing config file"
	goto die
)
:endresetconf
call :confhasmingwdir || goto endfindmingw
call :findmingw || (
	call :errmsg "problem finding MinGW directory"
	goto die
)
:endfindmingw
call :readconf || (
	call :errmsg "problem reading config file"
	goto die
)
call :askcustomise || goto endcustomise
call :customisesettings || (
	call :errmsg "problem customising settings"
	goto die
)
call :askwriteconf || goto endcustomise
call :writeconf || (
	call :errmsg "problem writing config file"
	goto die
)
:endcustomise
call :extractvars || (
	call :errmsg "problem extracting variables"
	goto die
)
call :argisvalid || (
	call :errmsg "file argument seems invalid or nonexistent"
	goto die
)
call :enterdir || (
	call :errmsg "problem entering data directory"
	goto die
)
call :prefixmatch || (
	call :split || (
		call :errmsg "problem splitting file"
		goto die
	)
	goto return
)
call :join || (
	call :errmsg "problem joining splitfiles"
	goto die
)
goto return

:parseoptions
set /a funclevel+=1
set funcname=parseoptions
call :dbgmsg "entering %funcname%"
:parseloop
if "%1"=="--" (
	shift
	goto endparseloop
)
if "%1"=="--non-interactive" (
	set interactive=0
	shift
	goto parseloop
)
if "%1"=="-X" goto showsource
if "%1"=="--showsource" goto showsource
if "%1"=="-h" goto exit
if "%1"=="--help" goto exit
if "%1"=="--usage" goto exit
if "%1:~0,1%"=="-" goto die
:endparseloop
set argname=%~nx1
set argdir=%~dp1
goto return

:usage
set /a funclevel+=1
set funcname=usage
call :dbgmsg "entering %funcname%"
call :msg "" "Usage: %scriptname% [OPTIONS] [file to split|any one of the splitfiles]" "       * all splitfiles will be joined in order" "       * with no arguments creates/edits config then exits" "" "OPTIONS:" "  --non-interactive : Don't prompt. Assume defaults." "  -h|--help|--usage : This message." "  -X|--showsource   : Show source of this script." "  --                : End options." "" "Configuration file: splitzen-[your computer name].conf (in same directory as splitzen.cmd)" ""
goto return

:showsource
type %~dpnx0
goto return

:setdefaults
set /a funclevel+=1
set funcname=setdefaults
call :dbgmsg "entering %funcname%"
set mingwdir=
set prefix=splitfile_
set splitfilesize=4608k
set checksumtype=sha1
set unixroot=%%mingwdir%%
set splitexec=%%unixroot%%split.exe
set sumexec=%%unixroot%%%%checksumtype%%sum.exe
set headexec=%%scriptdir%%bin\head.cmd
set tailexec=%%scriptdir%%bin\tail.cmd
goto return

:argexists
set /a funclevel+=1
set funcname=argexists
call :dbgmsg "entering %funcname%"
if "%argdir%%argname%"=="" goto die
goto return

:confexists
set /a funclevel+=1
set funcname=confexists
call :dbgmsg "entering %funcname%"
if exist "%localconf%" goto return
goto die

:askreset
set /a funclevel+=1
set funcname=askreset
call :dbgmsg "entering %funcname%"
if %interactive% neq 0 set /p response=Would you like to reset the configuration file to factory defaults? [y/N]: 
set respfirstletter=%response:~0,1%
set response=
if /i "%respfirstletter%"=="y" goto return
goto die

:writeconf
set /a funclevel+=1
set funcname=writeconf
call :dbgmsg "entering %funcname%"
echo # Splitzen configuration file>"%localconf%" || goto die
echo #  %%mingwdir%% is replaced by the script after searching standard locations for a match>>"%localconf%" || goto die
echo #  %%scriptdir%% is replaced by the name of the directory the splitzen.cmd script is in>>"%localconf%" || goto die
echo.>>"%localconf%" || goto die
for %%i in (prefix splitfilesize checksumtype unixroot splitexec sumexec headexec tailexec debug) do (
    for /f "tokens=1,2 delims==" %%n in ('set %%i') do (
        echo %%n=%%o>>"%localconf%"|| goto die
    )
)
goto return

:confhasmingwdir
set /a funclevel+=1
set funcname=confhasmingwdir
call :dbgmsg "entering %funcname%"
for /f "tokens=1,2* delims== eol=#" %%i in (%localconf%) do (
    if "%%j"=="%%mingwdir%%" (
        call :dbgmsg "found [%%%%mingwdir%%%%] in config"
        goto return
    )
)
goto die

:findmingw
set /a funclevel+=1
set funcname=findmingw
call :dbgmsg "entering %funcname%"
if exist "%scriptdir%bin\split.exe" (
	set mingwdir=%scriptdir%bin\
	goto foundmingw
)
if exist "%ProgramFiles(x86)%\GnuWin32\bin\split.exe" (
	set mingwdir=%ProgramFiles(x86)%\GnuWin32\bin\
	goto foundmingw
)
if exist "%ProgramFiles%\GnuWin32\bin\split.exe" (
	set mingwdir=%ProgramFiles%\GnuWin32\bin\
	goto foundmingw
)
if exist "C:\MinGW\bin\split.exe" (
	set mingwdir=C:\MinGW\bin\
	goto foundmingw
)
if exist "%ProgramFiles(x86)%\MinGW\bin\split.exe" (
	set mingwdir=%ProgramFiles(x86)%\MinGW\bin\
	goto foundmingw
)
if exist "%ProgramFiles%\MinGW\bin\split.exe" (
	set mingwdir=%ProgramFiles%\MinGW\bin\
	goto foundmingw
)
goto die
:foundmingw
call :dbgmsg "found [%mingwdir%] dir"
goto return

:readconf
set /a funclevel+=1
set funcname=readconf
call :dbgmsg "entering %funcname%"
for /f "tokens=1,2 delims== eol=#" %%i in ('findstr /r "^prefix= ^splitfilesize= ^checksumtype= ^unixroot= ^splitexec= ^sumexec= ^headexec= ^tailexec= ^debug=" "%localconf%"') do (
    set %%i=%%j
)
goto return

:askcustomise
set /a funclevel+=1
set funcname=askcustomise
call :dbgmsg "entering %funcname%"
if %interactive% neq 0 set /p response=Would you like to customise settings? [y/N]: 
set respfirstletter=%response:~0,1%
set response=
if /i "%respfirstletter%"=="y" goto return
goto die

:customisesettings
set /a funclevel+=1
set funcname=customisesettings
call :dbgmsg "entering %funcname%"
call :msg "NB: when joining files prefix must be set to match the splitfiles' prefixes"
for %%i in (prefix splitfilesize checksumtype unixroot splitexec sumexec headexec tailexec debug) do (
    for /f "tokens=1,2 delims==" %%n in ('set %%i') do (
        set /p response=Set %%n [hit enter for "%%o"]: 
        if not "!response!"=="" set %%n=!response!
        set response=
        set %%n
    )
)
goto return

:askwriteconf
set /a funclevel+=1
set funcname=askwriteconf
call :dbgmsg "entering %funcname%"
if %interactive% neq 0 set /p response=Save these new settings as defaults? [y/N]: 
set respfirstletter=%response:~0,1%
set response=
if /i "%respfirstletter%"=="y" goto return
goto die

:extractvars
set /a funclevel+=1
set funcname=extractvars
call :dbgmsg "entering %funcname%"
for %%i in (prefix splitfilesize checksumtype unixroot splitexec sumexec headexec tailexec debug) do (
    for /f "tokens=1,2 delims==" %%n in ('set %%i') do (
        call set %%n=%%o
    )
)
goto return

:argisvalid
set /a funclevel+=1
set funcname=argisvalid
call :dbgmsg "entering %funcname%"
if "%argdir%"=="" goto die
if "%argname%"=="" goto die
if not exist "%argdir%%argname%" goto die
goto return

:enterdir
set /a funclevel+=1
set funcname=enterdir
call :dbgmsg "entering %funcname%"
pushd "%argdir%" || goto die
set inthedir=1
goto return

:prefixmatch
set /a funclevel+=1
set funcname=prefixmatch
call :dbgmsg "entering %funcname%"
set #=%argname%
:prefixmatchloop
if "%#%"=="%prefix%" (
	goto return
)
if not "%#%"=="" (
	set #=%#:~0,-1%
	goto prefixmatchloop
)
goto die

:join
set /a funclevel+=1
set funcname=join
call :dbgmsg "entering %funcname%"
call :msg "* Joining [%prefix%#####] files" "Will test %checksumtype% checksums for [%prefix%#####] files"
if %interactive% neq 0 call :msg "Will request to input the joined file name"
call :msg "Will remove any preexisting joined file" "Will join [%prefix%#####] files to joined file" "Will test %checksumtype% checksum for joined file" "NB: the joined file is removed and created in the same directory as the splitfiles and checksum file!"
set response=
if %interactive% neq 0 set /p response=Continue? [Y/n]: 
set respfirstletter=%response:~0,1%
if /i "%respfirstletter%"=="n" (
	call :dbgmsg "aborted by user"
	goto return
)
call :dbgmsg "joining files"
if not exist "checksums.%checksumtype%" (
	call :dbgmsg "the [checksums.%checksumtype%] file is missing"
	goto die
)
call :dbgmsg "[checksums.%checksumtype%] exists"
for /f "tokens=1,2,3 delims=/" %%i in ("%date%") do set datestamp=%%k%%j%%i
for /f "tokens=1,2,3,4 delims=:,." %%i in ("%time: =0%") do set timestamp=%%i%%j%%k%%l
call set tempfile=%scriptname%-%datestamp%%timestamp%.tmp
copy /y nul "%tempfile%" > nul 2>&1
dir "%prefix%?????" /b | find /v /c "" >"%tempfile%" || goto die
set /p numsplitfiles= <"%tempfile%" || goto die
"%tailexec%" -n +2 "checksums.%checksumtype%" | find /v /c "" >"%tempfile%" || goto die
set /p expectednumsplitfiles= <"%tempfile%" || goto die
del "%tempfile%" || goto die
set tempfile=
set datestamp=
set timestamp=
if not "%numsplitfiles%"=="%expectednumsplitfiles%" (
	call :dbgmsg "there are a different number of [%prefix%#####] files than expected"
	goto die
)
call :dbgmsg "The number of [%prefix%#####] files match those listed"
"%tailexec%" -n +2 "checksums.%checksumtype%" | "%sumexec%" -c -w - >nul || (
	call :dbgmsg "the [%prefix%#####] files do not match their %checksumtype% checksums"
	goto die
)
call :dbgmsg "the [%prefix%#####] files match their %checksumtype% checksums"
for /f "tokens=1,*" %%i in ('call "%headexec%" -n 1 "checksums.%checksumtype%" ') do (
	set wholefilechecksum=%%i
	set defwholefile=%%j
)
if "%defwholefile:~0,1%"=="*" (
	set isbinchecksum=1
	set defwholefile=%defwholefile:~1%
)
:getfilenameloop
rem FIXME: this interactive stuff dies for some random reason
rem if %interactive% neq 0 call :msg "Enter joined filename (without leading directories" "- if in doubt hit enter to use [%defwholefile%])"
rem if %interactive% neq 0 set /p wholefile=: 
rem if "%wholefile%"=="" (
	set wholefile=%defwholefile%
rem ) else (
rem 	set wholefileclean=%wholefile%
rem 	set wholefileclean=%wholefileclean:\=%
rem 	set wholefileclean=%wholefileclean:/=%
rem 	if not "%wholefileclean%"=="%wholefile%" (
rem 		call :msg "NB: Must enter a filename only (no directory path)"
rem 		goto getfilenameloop
rem 	)
rem 	set wholefileclean=
rem )
if exist "%wholefile%" (
	del "%wholefile%" || (
		call :dbgmsg "error removing old [%wholefile%] file"
		goto die
	)
	call :dbgmsg "removed old [%wholefile%] file"
)
copy /B "%prefix%?????" /B "%wholefile%" >nul || (
	call :dbgmsg "error joining [%prefix%#####] files"
	goto die
)
call :dbgmsg "joined [%prefix%#####] files"
if "%isbinchecksum%"=="1" (
	echo %wholefilechecksum% *%wholefile% | "%sumexec%" -c -w - >nul
) else (
	echo %wholefilechecksum% %wholefile% | "%sumexec%" -c -w - >nul
)
if %ERRORLEVEL% neq 0 (
	call :dbgmsg "the created [%wholefile%] file does not match its %checksumtype% checksum"
	goto die
)
call :dbgmsg "the created [%wholefile%] file matches its %checksumtype% checksum"
goto return

:split
set /a funclevel+=1
set funcname=split
call :dbgmsg "entering %funcname%"
set wholefile=%argname%
call :msg "* Splitting [%wholefile%] file" "Will remove any preeexisting [%prefix%#####] files" " and [checksums.%checksumtype%] file" "Will split [%wholefile%] to [%prefix%#####] files" "Will create a [checksums.%checksumtype%] file" "NB: the splitfiles and checksum file are removed and created in the same directory as the original!"
set response=
if %interactive% neq 0 set /p response=Continue? [Y/n]: 
set respfirstletter=%response:~0,1%
if /i "%respfirstletter%"=="n" (
	call :dbgmsg "aborted by user"
	goto finish
)
call :dbgmsg "splitting file"
if exist "%prefix%?????" (
	del "%prefix%?????" || (
		call :dbgmsg "error removing old [%prefix%#####] files"
		goto die
	)
    call :dbgmsg "removed old [%prefix%#####] files"
)
if exist "checksums.%checksumtype%" (
	del "checksums.%checksumtype%" || (
		call :dbgmsg "error removing old [checksums.%checksumtype%] file"
		goto die
	)
    call :dbgmsg "removed old [checksums.%checksumtype%] file"
)
"%splitexec%" -b %splitfilesize% -d -a 5 "%wholefile%" %prefix% || (
	call :dbgmsg "error creating [%prefix%#####] files"
	goto die
)
call :dbgmsg "created [%prefix%#####] files"
"%sumexec%" -b "%wholefile%">"checksums.%checksumtype%"|| (
	call :dbgmsg "error creating [checksums.%checksumtype%] file"
	goto die
)
"%sumexec%" -b "%prefix%?????">>"checksums.%checksumtype%"|| (
	call :dbgmsg "error creating [checksums.%checksumtype%] file"
	goto die
)
call :dbgmsg "created [checksums.%checksumtype%] file"
goto return

:msg
for %%i in (%*) do (
	if "%%~i"=="" (
		echo.
	) else (
		echo %%~i
	)
)
goto :EOF

:errmsg
for %%i in (%*) do (
	if "%%~i"=="" (
		echo.>&2
	) else (
		echo %%~i>&2
	)
)
goto :EOF

:dbgmsg
if %debug% equ 1 (
	for %%i in (%*) do (
        echo # %~n0: %%~i>&2
	)
)
goto :EOF

:exit
set retval=2
goto return
:die
set retval=1
:return
if %funclevel% equ 0 (
	if %inthedir% equ 1 popd
	call :dbgmsg "exiting script"
	if %interactive% neq 0 pause
	if %retval% equ 2 (
		endlocal
		exit /b 0
	) else (
		endlocal
		exit /b %retval%
	)
) else (
	call :dbgmsg "leaving %funcname%"
	set funcname=main
	set /a funclevel-=1
	if %retval% equ 2 (
		set retval=0
		exit /b 2
	)
	if %retval% equ 1 (
		set retval=0
		exit /b 1
	)
    exit /b 0
)
