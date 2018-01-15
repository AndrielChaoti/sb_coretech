@echo off

set SBPATH="C:\Users\AndrielChaoti\Desktop\Important Stuff\Starbound\mods\weaponupgradetable\"

rmdir /S /Q %SBPATH%

xcopy /E /I .\src\*.* %SBPATH%
TIMEOUT /T 5
