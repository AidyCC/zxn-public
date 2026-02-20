@echo off

CALL .\cards\bigdeal\build.bat

IF '%ERRORLEVEL%' == '0' (
copy /b .\cards\bigdeal\carddemo_bas.tap+.\cards\bin\cards.tap .\cards\bin\carddemo.tap
.\tools\hdfmonkey put .\CSpect3_0_15_2\cspect-next-1gb.img .\cards\bin\carddemo.tap \

.\CSpect3_0_15_2\CSpect.exe -28 -w3 -brk -mmc=.\CSpect3_0_15_2\cspect-next-1gb.img -nextrom -basickeys
) ELSE (
	echo "Build error(s), can not run."
)
