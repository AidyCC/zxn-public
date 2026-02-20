@echo off

CALL .\cards\dotcmd\build.bat

IF '%ERRORLEVEL%' == '0' (
.\tools\hdfmonkey put .\CSpect3_0_15_2\cspect-next-1gb.img .\cards\dot\CARD dot
.\tools\hdfmonkey put .\CSpect3_0_15_2\cspect-next-1gb.img .\cards\bin\carddemo_bas.tap \

.\CSpect3_0_15_2\CSpect.exe -28 -w3 -brk -mmc=.\CSpect3_0_15_2\cspect-next-1gb.img -nextrom -basickeys
) ELSE (
	echo "Build error(s), can not run."
)
