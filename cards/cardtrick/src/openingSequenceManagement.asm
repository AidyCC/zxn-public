openingSequence
    LD        BC,0x020D
    LD        DE,0x0001
    CALL      drawCard
    LD        BC,0x170D
    LD        DE,0x0002
    CALL      drawCard
    LD        A,10
    CALL      waitForFrames
    LD        DE,0x40D0 - 26/2
    LD        HL,welcomeString
    LD        B,26
    CALL      prntFadingString
    LD        A,10
    CALL      waitForFrames
    LD        DE,0x40D0 - 22/2
    LD        HL,amazingString
    LD        B,22
    CALL      prntFadingString
    LD        A,5
    CALL      waitForFrames
    LD        DE,0x40D0 - 22/2
    LD        HL,pressEnterString
    LD        B,22
    CALL      prntStringDblHgt
    CALL      waitForEnter
    RET

welcomeString
    DEFM    BLUE_INK, "Welcome To The Card Trick!"
amazingString
    DEFM    BLUE_INK, "Prepare To Be Amazed !"
pressEnterString
    DEFM    FLASH | WHITE_PAPER | BLUE_INK, " Press Enter To Start "