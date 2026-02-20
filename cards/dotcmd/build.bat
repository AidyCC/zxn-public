@echo off

.\tools\bas2tap.exe -a10 .\cards\dotcmd\carddemo.bas .\cards\bin\carddemo_bas.tap
.\tools\sjasmplus.exe --lst=./cards/obj/dotcmd.list --zxnext=cspect ./cards/dotcmd/src/main.asm