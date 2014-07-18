@echo off
REM ---------------------------------------------------------------------------------------
REM Batch file used to convert a Lua file to a C file, such as "init.lua".
REM ---------------------------------------------------------------------------------------


REM Validate arguments. If incorrect, then echo out how to use this batch file.
if "%~1"=="" goto OnShowCommandLineHelp
if "%~2"=="" goto OnShowCommandLineHelp
if "%~3"=="" goto OnShowCommandLineHelp
if "%~4"=="" goto OnShowCommandLineHelp
if "%~5"=="" goto OnShowCommandLineHelp
if NOT "%~6"=="" goto OnShowCommandLineHelp


REM Log that we're now attempting to generate a C++ file from Lua.
echo Generating C file for %3


REM Delete the last generated C++ file and *.lu file.
del "%~4\%~n3.c"
del "%~2\%~n3.lu"

REM Compile the Lua script to byte code and generate a C file for it.

if ERRORLEVEL 1 goto OnError

if EXIST "%~dp0\..\rcc.lua" (
	echo Using luac.exe to create bytecodes
	"%1\lua.exe" "%~dp0\..\rcc.lua" -c "%1" "-O%~5" -o "%~2\%~n3.lu" "%3"
	if ERRORLEVEL 1 goto OnError
	"%1\lua.exe" "%~dp0\..\lua2c.lua" "%~2\%~n3.lu" %~n3 "%~4\%~n3.c"
	if ERRORLEVEL 1 goto OnError
	goto:eof
) else (
	echo Using lua.exe to create bytecodes
	"%1\lua.exe" "%~dp0\..\..\shared\bin\lua2c.lua" "%3" %~n3 "%~4\%~n3.c"
	if ERRORLEVEL 1 goto OnError
	goto:eof	
)

:OnShowCommandLineHelp
echo Compiles a Lua file to byte code and then generates a C++ file containing
echo that byte code and a function for executing it.
echo.
echo Usage:    LuaToCppFile.bat [LuaAppPath] [IntermediatePath] [SourceFile] [TargetPath]
echo   [LuaAppPath]       The path to the lua.exe and luac.exe files.
echo   [IntermediatePath] Path to where temporary files are built to.
echo   [SourceFile]       The Lua path\file name to be converted.
echo   [TargetPath]       The path to where the C file should be created.
echo   [Configuration]    Debug or Release
exit /b 1

:OnError
echo Failed to generate C file for %3
exit /b 1
