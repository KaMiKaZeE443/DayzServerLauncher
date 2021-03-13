@echo off
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:::::::::::::::::::::::::::::::CHECK SERVER:::::::::::::::::::::::::::::::
:::::::::::::-DO NOT EDIT UNLESS YOU KNOW WHAT YOU WARE DOING-::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
goto checkServer
::This checks whether or not the server is running.
:checkServer
tasklist /fi "imagename eq DayZServer_x64.exe" 2>NUL | find /i /n "DayZServer_x64.exe">NUL
if "%ERRORLEVEL%"=="0" goto loopserver
echo DayZ Server is not running, taking care of it..
goto checkDZSALModServer
 
::This makes sure the processes are dead before starting.
:killServer
taskkill /f /im DayZServer_x64.exe
taskkill /f /im DZSALModServer.exe
goto start
 
::This checks whether or not the Mod Server is running.
:checkDZSALModServer
tasklist /fi "imagename eq DZSALModServer.exe" 2>NUL | find /i /n "DZSALModServer.exe">NUL
if "%ERRORLEVEL%"=="0" goto loopserver
echo DZSAL Mod Server is not running, taking care of it..
goto killServer
 
::This checks every 10 seconds that the server is running
:loopServer
FOR /L %%s IN (10,-1,0) DO (
    echo Server is running. Checking again in %%s seconds...
    timeout 1 >nul
    cls
)
goto checkserver
 
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:::::::::::::::::::::::::::::: START SERVER ::::::::::::::::::::::::::::::
:::::::::::::::::::::::::-EDIT THESE VALUES BELOW-::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
 
:start
::Server name (This is only for the CMD window name not your actual servers name)
set serverName=WhateverYouWant
::Server files location (Do not remove the quotation marks)
set serverLocation="C:\Path\To\Your\Server\Folder"
::Server Port (Default is 2302 you can make this whatever you want, don't forget to forward the port if you need to.)
set serverPort=2302
::Server config
set serverConfig=serverDZ.cfg
::Logical CPU cores to use (Equal or less than available)
set serverCPU=8
:: Limit Server FPS (Limits the servers ticks per second)
set serverFPS=200
::Profile Name (This is where your mod settings and logs will go)
set Profile=ProfileNameHere
:: Battleye Path (This will be in your server profile name you chose above.)
set battleyepath=C:\Path\To\Your\Battleye\Folder\
::Mods (Last mod doesn't have ; )
set ModList=@ExampleMod1;@ExampleMod2;@ExampleMod3
::Server Side Mods (Last mod doesn't have ; )
set ServerMods=@ExampleMod1;@ExampleMod2;@ExampleMod3
 
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::::::::::-DO NOT EDIT BELOW UNLESS YOU KNOW WHAT YOU WARE DOING-:::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::Sets title for terminal (DONT edit)
title %serverName% batch
::DayZServer location (DONT edit)
cd "%serverLocation%"
echo (%time%) %serverName% started.
::Launch parameters 
start "DayZ Server" /min "DZSALModServer.exe" -config=%serverConfig% -port=%serverPort% -cpuCount=%serverCPU% -BEpath=%battleyepath% -profiles=%Profile% -netLog -limitFPS=%serverFPS% -serverMod=%ServerMods% -mod=%ModList%
::Allow a small amount of time for apps to launch
timeout 10
::This makes sure the server is still running and will auto restart it if its not running anymore.
goto loopserver
