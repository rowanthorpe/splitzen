@echo off

rem tail.cmd: minimal "tail" command in Windows batch script
rem  part of Splitzen package (see below)
rem
rem Splitzen: Drag-n-Drop splitting and rejoining
rem           for files, with checksum integrity checking
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

rem TODO: check deleting trailing blank lines problem (Fix=insert character,trim on output?)
rem TODO: remove need for temp file when using "-n +x"

set retval=0
verify OTHER 2>nul
setlocal enableextensions enabledelayedexpansion
if ERRORLEVEL 1 (
	echo # tail: requires cmd.exe with extensions capability>&2
	goto die
)
set scriptname=%~n0
if not "%1"=="-n" goto die
if "%2"=="" goto die
set skiplinearg=%~2
set withtempfile=yes
if "%skiplinearg:~0,1%"=="+" set withtempfile=no
if "%withtempfile%"=="no" goto notempfile
for /f "tokens=1,2,3 delims=/" %%i in ("%date%") do set datestamp=%%k%%j%%i
for /f "tokens=1,2,3,4 delims=:,." %%i in ("%time: =0%") do set timestamp=%%i%%j%%k%%l
call set tempfile=%cd%\%scriptname%-%datestamp%%timestamp%.tmp
copy /y nul "%tempfile%" > nul 2>&1
set /a lastline=0
if "%3"=="" goto fromstdin
for /f "tokens=* delims=" %%a in ('findstr /e /v /n "$$#MARKER#MARKER#MARKER#$$" "%3"') do (
	>> "%tempfile%" echo.%%a
	set /a lastline+=1
)
goto madetemp
:fromstdin
for /f "tokens=* delims=" %%a in ('findstr /e /v /n "$$#MARKER#MARKER#MARKER#$$"') do (
	>> "%tempfile%" echo.%%a
	set /a lastline+=1
)
:madetemp
call set sourcefile=%tempfile%
goto calculatearg
:notempfile
set sourcefile=%~3
:calculatearg
if "%skiplinearg:~0,1%"=="+" (
	set /a skiplines=%skiplinearg:~1%-1
	goto donearg
)
if "%skiplinearg:~0,1%"=="-" (
	set /a skiplines=%lastline%%skiplinearg%
	goto donearg
)
set /a skiplines=%lastline%-%skiplinearg%
:donearg
if %skiplines% lss 0 set /a skiplines=0
if "%withtempfile%"=="yes" (
	if %skiplines% gtr %lastline% set /a skiplines=%lastline%
	if %skiplines% equ 0 (
		for /f "tokens=* delims=" %%a in (%sourcefile%) do (
			if "%%a"=="" ( echo. ) else ( 
				for /f "tokens=1,* delims=:" %%i in ("%%a") do echo.%%j
			)
		)
	) else (
		for /f "skip=%skiplines% tokens=* delims=" %%a in (%sourcefile%) do (
			if "%%a"=="" ( echo. ) else (
				for /f "tokens=1,* delims=:" %%i in ("%%a") do echo.%%j
			)
		)
	)
) else (
	if "%sourcefile%"=="" (
		if %skiplines% equ 0 (
			for /f "tokens=* delims=" %%a in ('findstr /e /v "$$#MARKER#MARKER#MARKER#$$"') do echo.%%a
		) else (
			for /f "skip=%skiplines% tokens=* delims=" %%a in ('findstr /e /v "$$#MARKER#MARKER#MARKER#$$"') do echo.%%a
		)
	) else (
		if %skiplines% equ 0 (
			for /f "tokens=* delims=" %%a in (%sourcefile%) do echo.%%a
		) else (
			for /f "skip=%skiplines% tokens=* delims=" %%a in (%sourcefile%) do echo.%%a
		)
	)
)
goto exit
:die
set retval=1
:exit
if "%withtempfile%"=="yes" del "%tempfile%" || set retval=1
endlocal
exit /b %retval%
