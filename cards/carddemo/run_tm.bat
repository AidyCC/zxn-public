@echo off

CALL .\cards\carddemo\build.bat

IF '%ERRORLEVEL%' == '0' (

.\CSpect3_0_15_2\CSpect.exe -28 -w3 -brk -basickeys .\cards\nex\carddemo_tm.nex
) ELSE (
	echo "Build error(s), can not run."
)
