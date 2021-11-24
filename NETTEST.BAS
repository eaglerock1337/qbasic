'The Internet Simulator v2.0 by Peter Marks
'This Net program will give a good heaping helping of fun!
'Original incomplete version - July 1, 1998
'Version 2.0 - November 21st, 2021

CONST rows = 15
CONST delay = 6

DECLARE SUB Lineout ()
DECLARE SUB Pause (ticks)

DIM SHARED slowbaud AS INTEGER
slowbaud = 1

DIM SHARED lines$(rows)

RESTORE Screens

FOR x = 1 TO rows
    READ lines$(x)
NEXT x

CLS
PRINT "300 baud lineout": PRINT
Lineout

SLEEP 2
CLS

PRINT "2400 baud lineout": PRINT
slowbaud = 0
Lineout

END

100 REM Initialize
' Variables go here.
' Multiplier for terminal speed (defaults to 5)

1000 REM Main Menu
' Instructions, Save/Load, Enter Sim, or Quit.

2000 REM CPM Emulator
' Literally emulate CP/M enought for basic shit.

' Commands:
' A: - Switch to A: Disk - Contains CPM and program, disk full
' B: - Switch to B: Disk - Contains
' DIR - List Directory

3000 REM V-TEE 100
' The Video Terminal Emulator Emulator
' What a great name for a program.

' Improvements to include:
' ISP Beta Program - Faster network transmission and display times
' Terminal Proxy - Connect through other servers
' Color Terminal Support - Download illegally
' Favorites - Address book for servers found on the Internet

4000 REM HACCBBS
' The Hacker and Computing Connoisseur Bulletin Board System.
' I know how to name shit.

' News - Recent news (find link to NASA Public Gateway)
'

5000 REM NETSERV Customer Services Portal
' For customers of the Network Services Corporation.
' Which you're not, so go 'way. Shoo.

6000 REM NASA Public Gateway
' Your tax dollars paid for this.

7000 REM NASA CPN
' NASA's Classified Private Network

8000 REM NASA X-PLOD-3
' The X-Series Probe Launcer and Orbiting Director, version 3.
' IMB's latest model

9000 REM Data Blocks
' Your one-stop shop for all the datums.

'PRINT
'PRINT "********************************************************************************"
'PRINT "* WELCOME TO THE NASA LAUNCH PREPARATION SYSTEM!           GUEST LEVEL SECURITY*"
'PRINT "********************************************************************************"
'PRINT "* 1) GET INFO ON THE SPACE SHUTTLE LAUNCH   2) INPUT CODE FOR HIGHER ATHORITY  *"
'PRINT "********************************************************************************"
'PRINT
'
'PRINT
'PRINT
'PRINT "********************************************************************************"
'PRINT "* WELCOME TO THE NASA LAUNCH PREPARATION SYSTEM!           TOP SECRET SECURITY *"
'PRINT "********************************************************************************"
'PRINT "* 1) CHECK SATELLITE                                                           *"
'PRINT "* 2) CHECK SPACE SHUTTLE                                                       *"
'PRINT "* 3) CHECK BOOSTER ROCKETS                                                     *"
'PRINT "* 4) CHECK MAIN CONTROLS                                                       *"
'PRINT "* 5) CHECK FUEL TANK                                                           *"
'PRINT "* 6) ACTIVATE EBS SYSTEM                                                       *"
'PRINT "* 7) ACTIVATE HES SYSTEM                                                       *"
'PRINT "* 8) ACTIVATE LAUNCH PREPARATION...                                            *"
'PRINT "* 9) RETURN TO GUEST LEVEL SECURITY                                            *"
'PRINT "********************************************************************************"
'PRINT
'PRINT "          Enter number of choice here -----> ";
'INPUT B

Defaults:
DATA 1, 2, 3, 4, 5

Events:
DATA "event", 1, 2, 3, "value"

Screens:
DATA "********************************************************************************"
DATA "* WELCOME TO THE NASA LAUNCH PREPARATION SYSTEM!           TOP SECRET SECURITY *"
DATA "********************************************************************************"
DATA "* 1) CHECK SATELLITE"
DATA "* 2) CHECK SPACE SHUTTLE"
DATA "* 3) CHECK BOOSTER ROCKETS"
DATA "* 4) CHECK MAIN CONTROLS"
DATA "* 5) CHECK FUEL TANK"
DATA "* 6) ACTIVATE EBS SYSTEM"
DATA "* 7) ACTIVATE HES SYSTEM"
DATA "* 8) ACTIVATE LAUNCH PREPARATION..."
DATA "* 9) RETURN TO GUEST LEVEL SECURITY"
DATA "********************************************************************************"
DATA ""
DATA "          Enter number of choice here -----> "

SUB Lineout
    sound$ = "T255MSMFO4L64A-"
    IF slowbaud THEN sound$ = "T255MSMFO5L64EO4A-P64"

    FOR i = 1 TO rows
        outpt$ = lines$(i)
        FOR j = 1 TO LEN(outpt$)
            char$ = MID$(outpt$, j, 1)
            PRINT char$;
            IF char$ <> " " THEN PLAY sound$
            Pause (1)
        NEXT j
        PRINT
        Pause (5)
    NEXT i
END SUB

SUB Pause (ticks)
    iter = delay * ticks
    IF slowbaud THEN iter = iter * 5
    FOR k = 1 TO iter
    NEXT k
END SUB

