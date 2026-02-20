@echo off

.\tools\sjasmplus.exe -DZXN_CARDS_LIB --lst=./cards/obj/carddemo.list --zxnext=cspect ./cards/carddemo/src/main.asm

IF '%ERRORLEVEL%' == '0' (
	.\tools\sjasmplus.exe -DZXN_CARDS_TILEMAP_LIB --lst=./cards/obj/carddemo_tm.list --zxnext=cspect ./cards/carddemo/src/main.asm
)