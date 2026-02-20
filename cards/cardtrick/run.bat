@echo off

CALL .\cards\cardtrick\build.bat

IF '%ERRORLEVEL%' == '0' (
.\CSpect3_0_15_2\CSpect.exe -28 -w3 -brk -60 .\cards\nex\cardtrick.nex
) ELSE (
	echo "Build error(s), can not run."
)
