@echo off

.\tools\bas2tap.exe -a10 .\cards\bigdeal\carddemo.bas .\cards\bigdeal\carddemo_bas.tap
.\tools\sjasmplus.exe --lst=./cards/obj/bigdeal.list --zxnext=cspect ./cards/bigdeal/src/main.asm
