'The Internet Simulator v2.0 by Peter Marks
'This Net program will give a good heaping helping of fun!
'Original incomplete version - July 1, 1998
'Version 2.0 - November 21st, 2021


' Constants
CONST tickspeed% = 6
CONST disksize% = 360

' Subroutine Declarations
DECLARE SUB Lineout (lines$(), numlines%)
DECLARE SUB Pause (ticks%)
DECLARE SUB Delay (ticks%)
DECLARE SUB Disk (seconds%)

' Global Variables
DIM SHARED cpmdisk$             ' Current CP/M Disk Drive
DIM SHARED cpmfiles$(12)        ' The list of files on the B: drive
DIM SHARED cpmfilenum%          ' Number of files on B: drive
DIM SHARED cpmspace%            ' Available B: drive space in KB
DIM SHARED slowbaud%            ' If the terminal runs at 300 baud


Initialize:

' Initialize Global Variables
ERASE cpmfiles$
cpmdisk$ = "A"
cpmfilenum% = 0
cpmspace% = disksize%
slowbaud% = 1


Menu:
' Instructions, Save/Load, Enter Sim, or Quit.


CPM:
' Literally emulate CP/M enough to make it convincing.

' Boot Routine
CLS
Delay (2)
PRINT "CP/M 2.2 Copyright 1979 (c) by Digital Research"
Disk (1)

Prompt:
' Disk Prompt
PRINT cpmdisk$;
LINE INPUT ">", cmd$
SELECT CASE cmd$
    CASE "STAT"
        IF cpmdisk$ = "B" THEN
            PRINT "STAT?"
            Delay (2)
        ELSE
            PRINT "A: R/O, Space: 78k"
            Delay (3)
            PRINT "B: R/W, Space:" + STR$(cpmspace%) + "k"
            Delay (3)
        END IF

    CASE "DIR"
        PRINT "DIR isn't written yet."
        ' TAB can help with string formatting

    CASE "QUIT"
        END

    CASE ELSE
        PRINT cmd$ + "?"
        Delay (2)

END SELECT

GOTO Prompt

' Commands:
' A: - Switch to A: Disk - Contains CPM and program, disk full
' B: - Switch to B: Disk - Contains
' DIR - List Directory
' ERA - Erase File
' A: STAT.COM, HELP.COM, VTEE.COM, MENU.COM, SCORE.COM

VTEE100:
' V-TEE 100 - The Video Terminal Emulator Emulator
' What a great name for a program.

' Improvements to include:
' ISP Beta Program - Faster network transmission and display times
' Terminal Proxy - Connect through other servers
' Color Terminal Support - Download illegally
' Favorites - Address book for servers found on the Internet

HACCBBS:
' The Hacker and Computing Connoisseur Bulletin Board System.
' I know how to name shit.

' News - Recent news (find link to NASA Public Gateway)
' Topics - Movies, Space, CPM, MSDOS, V-TEE
' Files - .GRB file formats (garbage), .DAT (used for tasks), .COM (executables)

NETSERV:
' NETSERV Customer Services Portal
' For customers of the Network Services Corporation.
' Which you're not, so go 'way. Shoo.

Gateway:
' The NASA Public Gateway
' Your tax dollars paid for this.

CPN:
' NASA's Classified Private Network (CPN)

XPLOD:
' The X-Series Probe Launcer and Orbiting Director, Version 3.
' IBM calls it the X-PLOD-3. That's totally not telling.

Gamedata:
' Your one-stop shop for all the datums.

' 80s NASA LOGO for Public Gateway
' ,@@@@@@C      @@@@     ,@@@@@@.      1@@@@@@@@@@@@      0@@@@@:
'i@@@@@@@@@     @@@@    i@@@@@@@@,   G@@@@@@@@@@@@@@     @@@@@@@@G
'G@@@t t@@@L    @@@@    @@@@ .@@@@  :@@@8               8@@@1 @@@@
'G@@@t  @@@@    @@@@   8@@@1  C@@@0 :@@@8              ;@@@@  ,@@@@
'C@@@1  ;@@@G   @@@@  ;@@@8    @@@@, G@@@@@@@@@@@@@    @@@@    0@@@L
'L@@@t   @@@@   @@@@  @@@@     .@@@@   f8@@@@@@@@@@@; 8@@@L     @@@@
'C@@@f   :@@@0  @@@@ 0@@@L      0@@@L           .@@@8:@@@@      :@@@@
'C@@@t    @@@@1:@@@@,@@@@        @@@@GGGGGGGCCC0@@@@L@@@@.       8@@@1
'C@@@t     @@@@@@@@C@@@@,        :@@@@@@@@@@@@@@@@@1G@@@C         @@@@

' STAR WARS logo for a Return of the Jedi reference
'   .           .        .                     .        .            .
'             .               .    .          .              .   .         .
'               _________________      ____         __________
' .       .    /                 |    /    \    .  |          \
'     .       /    ______   _____| . /      \      |    ___    |     .     .
'             \    \    |   |       /   /\   \     |   |___>   |
'           .  \    \   |   |      /   /__\   \  . |         _/               .
' .     ________>    |  |   | .   /            \   |   |\    \_______    .
'      |            /   |   |    /    ______    \  |   | \           |
'      |___________/    |___|   /____/      \____\ |___|  \__________|    .
'  .     ____    __  . _____   ____      .  __________   .  _________
'       \    \  /  \  /    /  /    \       |          \    /         |      .
'        \    \/    \/    /  /      \      |    ___    |  /    ______|  .
'         \              /  /   /\   \ .   |   |___>   |  \    \
'   .      \            /  /   /__\   \    |         _/.   \    \            .
'           \    /\    /  /            \   |   |\    \______>    |   .
'            \  /  \  /  /    ______    \  |   | \              /          .
' .       .   \/    \/  /____/      \____\ |___|  \____________/  LS
'                               .                                        .
'     .                           .         .               .                 .
'                .                                   .            .

' More Star Wars ASCII
'         _____
'       .'/L|__`.
'      / =[_]O|` \
'      |"+_____":|
'    __:='|____`-:__
'   ||[] ||====| []||
'   ||[] | |=| | []||
'   |:||_|=|U| |_||:|
'   |:|||]_=_ =[_||:| LS
'   | |||] [_][]C|| |
'   | ||-'"""""`-|| |
'   /|\\_\_|_|_/_//|\
'  |___|   /|\   |___|   R2 Astromech Droid
'  `---'  |___|  `---'     - Front View -
'         `---'

' Space forum thing for the BBS
'                                         _.oo.
'                 _.u[[/;:,.         .odMMMMMM'
'              .o888UU[[[/;:-.  .o@P^    MMM^
'             oN88888UU[[[/;::-.        dP^
'            dNMMNN888UU[[[/;:--.   .o@P^
'           ,MMMMMMN888UU[[/;::-. o@^
'           NNMMMNN888UU[[[/~.o@P^
'           888888888UU[[[/o@^-..
'          oI8888UU[[[/o@P^:--..
'       .@^  YUU[[[/o@^;::---..
'     oMP     ^/o@P^;:::---..
'  .dMMM    .o@^ ^;::---...
' dMMMMMMM@^`       `^^^^
'MMMUP^
' ^^

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

SUB Delay (ticks%)
    iter% = tickspeed% * ticks% * 25
    FOR k = 1 TO iter%
    NEXT k
END SUB

SUB Disk (seconds%)
    ' Something will go here.
END SUB

SUB Lineout (lines$(), numlines%)
    sounds$ = "T255MSMFO4L64A-"
    IF slowbaud% THEN sounds$ = "T255MSMFO5L64EO4A-P64"

    FOR i = 1 TO numlines%
        outpt$ = lines$(i)
        FOR j = 1 TO LEN(outpt$)
            char$ = MID$(outpt$, j, 1)
            PRINT char$;
            IF char$ <> " " THEN PLAY sounds$
            Pause (1)
        NEXT j
        PRINT
        Pause (5)
    NEXT i
END SUB

SUB Pause (ticks%)
    iter% = tickspeed% * ticks%
    IF slowbaud% THEN iter% = iter% * 5
    FOR k = 1 TO iter%
    NEXT k
END SUB

