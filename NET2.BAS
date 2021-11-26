'The Internet Simulator v2.0 by Peter Marks
'This Net program will give a good heaping helping of fun!
'Original incomplete version - July 1, 1998
'Version 2.0 - November 21st, 2021


REM $DYNAMIC

' Subroutine declarations
DECLARE SUB Lineout (startline%, numlines%)
DECLARE SUB Pause (ticks%)
DECLARE SUB Delay (ticks%)
DECLARE SUB Disk (seconds%)

' Game constants
CONST tickspeed% = 6            ' The configured tickspeed for screen output
CONST disksize% = 360           ' The size of the B: disk in kb

' Boolean constants
CONST TRUE = 1
CONST FALSE = 0

' Dark colors (FG and BG)
CONST BLACK = 0
CONST NAVY = 1
CONST GREEN = 2
CONST TEAL = 3
CONST MAROON = 4
CONST PURPLE = 5
CONST OLIVE = 6
CONST SILVER = 7

' Light colors (FG only)
CONST GRAY = 8
CONST BLUE = 9
CONST LIME = 10
CONST CYAN = 11
CONST RED = 12
CONST MAGENTA = 13
CONST YELLOW = 14
CONST WHITE = 15

' Global variables
DIM SHARED cpmdisk$             ' Current CP/M Disk Drive
DIM SHARED cpmfiles$(12)        ' The list of files on the B: drive
DIM SHARED cpmfilenum%          ' Number of files on B: drive
DIM SHARED cpmspace%            ' Available B: drive space in KB
DIM SHARED slowbaud             ' If the terminal runs at 300 baud
'DIM SHARED remote               ' If the terminal is outputting remote data


' Custom data types
TYPE TextData                   ' Text string metadata
    fgcolor AS INTEGER          ' Text foreground color (if enabled)
    bgcolor AS INTEGER          ' Text background color (if enabled)
    linefeed AS INTEGER         ' If a newline is needed
END TYPE

TYPE GameEvent                  ' A game event that updates player score
    score AS INTEGER            ' Change of score (positive or negative)
    cred AS INTEGER             ' Change of cred (positive or negative)
    times AS INTEGER            ' Times the reward is given (-1 for unlimited)
    startline AS INTEGER        ' The start line of the output text
    numlines AS INTEGER         ' The number of lines to output
END TYPE

TYPE GameHeader                 ' A game screen header
    startline AS INTEGER        ' The start line of the header text
    numlines AS INTEGER         ' The number of lines to the header
END TYPE

TYPE GameScreen                 ' A complete game screen
    remote AS INTEGER           ' If the terminal is outputting remote data
    header AS INTEGER           ' Number of header to use
    startline AS INTEGER        ' The start line of the output text
    numlines AS INTEGER         ' The number of lines to output
END TYPE

TYPE GameFile                   ' A file inside the simulator
    filename AS STRING * 12     ' The name of the file (e.g. VTEE.COM)
    size AS INTEGER             ' The size of the file in kb
    server AS INTEGER           ' The target server for this file (0 for an executable)
    event AS INTEGER            ' The triggered event if uploaded to the target server
END TYPE


' Read game data
RESTORE Textlines
DIM SHARED Totallines AS INTEGER
READ Totallines

DIM SHARED linedata(1 TO Totallines) AS TextData
DIM SHARED lines(1 TO Totallines) AS STRING
FOR l = 1 TO Totallines
    READ linedata(l).fgcolor
    READ linedata(l).bgcolor
    READ linedata(l).linefeed
    READ lines(l)
NEXT l


Initialize:
' Initializes all variables for a new game.


' Initialize global variables
ERASE cpmfiles$
cpmdisk$ = "A"
cpmfilenum% = 0
cpmspace% = disksize%
slowbaud = TRUE
remote = FALSE


Menu:
' Main game menu


CPM:
' Literally emulate CP/M enough to make it convincing.

' Boot Routine
CLS
COLOR GREEN, BLACK
Delay (2)
PRINT "CP/M 2.2 Copyright 1979 (c) by Digital Research"
Disk (1)

Prompt:
' Disk Prompt

COLOR GREEN, BLACK
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

    CASE "TEST"
        slowbaud = FALSE
        CALL Lineout(1, 75)

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


BellFone:
' BellFone Customer Services Portal
' For customers of the BellFone Telephone Services Corporation
' Which you're not, so go 'way. Shoo.


Gateway:
' The NASA Public Gateway
' Your tax dollars paid for this.


CPN:
' NASA's Classified Private Network (CPN)


XPLOD:
' The X-Series Probe Launcer and Orbiting Director, Version 3.
' IBM calls it the X-PLOD-3. That's totally not telling.


' Individual lines of text data
' Total number of text lines:
' Format:   fgcolor%, bgcolor%, linefeed%, text$
' Example:  DATA LIME, BLACK, TRUE, "line of text"
Textlines:
DATA 75
DATA 10, 0, 1,  "line of text"
DATA  2, 0, 1,  "other line of text"
DATA  0, 0, 1,  " "
DATA  0, 0, 1,  " "
DATA  0, 0, 1,  " "
DATA  0, 0, 1,  " "
DATA  0, 0, 1,  " "
DATA  0, 0, 1,  " "
DATA  0, 0, 1,  " "
DATA  0, 0, 1,  " "
DATA 10, 0, 0,  "********************************************************************************"
DATA 10, 0, 0,  "* WELCOME TO THE NASA LAUNCH PREPARATION SYSTEM!           "
DATA  4, 0, 0,  "TOP SECRET SECURITY"
DATA 10, 0, 0,  " *********************************************************************************"
DATA 10, 0, 1,  "* 1) CHECK SATELLITE"
DATA 10, 0, 1,  "* 2) CHECK SPACE SHUTTLE"
DATA 10, 0, 1,  "* 3) CHECK BOOSTER ROCKETS"
DATA 10, 0, 1,  "* 4) CHECK MAIN CONTROLS"
DATA 10, 0, 1,  "* 5) CHECK FUEL TANK"
DATA 10, 0, 1,  "* 6) ACTIVATE EBS SYSTEM"
DATA 10, 0, 1,  "* 7) ACTIVATE HES SYSTEM"
DATA 10, 0, 1,  "* 8) ACTIVATE LAUNCH PREPARATION..."
DATA 10, 0, 1,  "* 9) RETURN TO GUEST LEVEL SECURITY"
DATA 10, 0, 0,  "********************************************************************************"
DATA 10, 0, 1,  ""
DATA 10, 0, 1,  "          Enter number of choice here -----> "
DATA  6, 0, 0,  "********************************************************************************"
DATA  6, 0, 0,  "* WELCOME TO THE NASA LAUNCH PREPARATION SYSTEM!           GUEST LEVEL SECURITY*"
DATA  6, 0, 0,  "********************************************************************************"
DATA  6, 0, 0,  "* 1) GET INFO ON THE SPACE SHUTTLE LAUNCH   2) INPUT CODE FOR HIGHER ATHORITY  *"
DATA  6, 0, 0,  "********************************************************************************"
DATA 12, 7, 1,  " ,@@@@@@C      @@@@     ,@@@@@@.      1@@@@@@@@@@@@      0@@@@@:"
DATA 12, 7, 1,  "i@@@@@@@@@     @@@@    i@@@@@@@@,   G@@@@@@@@@@@@@@     @@@@@@@@G"
DATA 12, 7, 1,  "G@@@t t@@@L    @@@@    @@@@ .@@@@  :@@@8               8@@@1 @@@@"
DATA 12, 7, 1,  "G@@@t  @@@@    @@@@   8@@@1  C@@@0 :@@@8              ;@@@@  ,@@@@"
DATA 12, 7, 1,  "C@@@1  ;@@@G   @@@@  ;@@@8    @@@@, G@@@@@@@@@@@@@    @@@@    0@@@L"
DATA 12, 7, 1,  "L@@@t   @@@@   @@@@  @@@@     .@@@@   f8@@@@@@@@@@@; 8@@@L     @@@@"
DATA 12, 7, 1,  "C@@@f   :@@@0  @@@@ 0@@@L      0@@@L           .@@@8:@@@@      :@@@@"
DATA 12, 7, 1,  "C@@@t    @@@@1:@@@@,@@@@        @@@@GGGGGGGCCC0@@@@L@@@@.       8@@@1"
DATA 12, 7, 1,  "C@@@t     @@@@@@@@C@@@@,        :@@@@@@@@@@@@@@@@@1G@@@C         @@@@"
DATA 14, 0, 1,  "   .           .        .                     .        .            ."
DATA 14, 0, 1,  "             .               .    .          .              .   .         ."
DATA 14, 0, 1,  "               _________________      ____         __________"
DATA 14, 0, 1,  " .       .    /                 |    /    \    .  |          \ "
DATA 14, 0, 1,  "     .       /    ______   _____| . /      \      |    ___    |     .     ."
DATA 14, 0, 1,  "           .  \    \   |   |      /   /__\   \  . |         _/               ."
DATA 14, 0, 1,  " .     ________>    |  |   | .   /            \   |   |\    \_______    ."
DATA 14, 0, 1,  "      |            /   |   |    /    ______    \  |   | \           |"
DATA 14, 0, 1,  "      |___________/    |___|   /____/      \____\ |___|  \__________|    ."
DATA 14, 0, 1,  "  .     ____    __  . _____   ____      .  __________   .  _________"
DATA 14, 0, 1,  "       \    \  /  \  /    /  /    \       |          \    /         |      ."
DATA 14, 0, 1,  "        \    \/    \/    /  /      \      |    ___    |  /    ______|  ."
DATA 14, 0, 1,  "         \              /  /   /\   \ .   |   |___>   |  \    \ "
DATA 14, 0, 1,  "   .      \            /  /   /__\   \    |         _/.   \    \            ."
DATA 14, 0, 1,  "           \    /\    /  /            \   |   |\    \______>    |   ."
DATA 14, 0, 1,  "            \  /  \  /  /    ______    \  |   | \              /          ."
DATA 14, 0, 1,  " .       .   \/    \/  /____/      \____\ |___|  \____________/  LS"
DATA 14, 0, 1,  "                               .                                        ."
DATA 14, 0, 1,  "     .                           .         .               .                 ."
DATA 14, 0, 1,  "                .                                   .            ."
DATA  9, 0, 1,  "                                         _.oo."
DATA  9, 0, 1,  "                 _.u[[/;:,.         .odMMMMMM'"
DATA  9, 0, 1,  "              .o888UU[[[/;:-.  .o@P^    MMM^"
DATA  9, 0, 1,  "             oN88888UU[[[/;::-.        dP^"
DATA  9, 0, 1,  "            dNMMNN888UU[[[/;:--.   .o@P^"
DATA  9, 0, 1,  "           ,MMMMMMN888UU[[/;::-. o@^"
DATA  9, 0, 1,  "           NNMMMNN888UU[[[/~.o@P^"
DATA  9, 0, 1,  "           888888888UU[[[/o@^-.."
DATA  9, 0, 1,  "          oI8888UU[[[/o@P^:--.."
DATA  9, 0, 1,  "       .@^  YUU[[[/o@^;::---.."
DATA  9, 0, 1,  "     oMP     ^/o@P^;:::---.."
DATA  9, 0, 1,  "  .dMMM    .o@^ ^;::---..."
DATA  9, 0, 1,  " dMMMMMMM@^`       `^^^^"
DATA  9, 0, 1,  "MMMUP^"
DATA  9, 0, 1,  " ^^"


Events:
' A single formatted response from a server.
' Format: points%, oneshot%
DATA 1      ' Number of outputs
DATA "event", 1, 2, 3, "value"


Headers:    ' A formatted header for use in multiple screens
' Format:
DATA 0      ' Number of headers


Screens:    ' A formatted game screen with header and body
' Format: header%, startline%, numlines%
DATA 0      ' Number of game screens


GameFiles:  ' Data files inside the game
' Format: filename$, size%, server%, event%
DATA 0      ' Number of outputs

SUB Delay (ticks%)
' Delay the local terminal for x ticks
    iter% = tickspeed% * ticks% * 25
    FOR k = 1 TO iter%
    NEXT k
END SUB

SUB Disk (seconds%)
' TODO: Simulate disk access sounds for number of seconds
END SUB

SUB Lineout (startline%, numlines%)
' Perform a lineout of the requested text lines.
    sounds$ = "T255MSMFO4L64A-"
    IF slowbaud% THEN sounds$ = "T255MSMFO5L64EO4A-P64"

    FOR i = startline% TO numlines%
        COLOR linedata(i).fgcolor, linedata(i).bgcolor
        FOR j = 1 TO LEN(lines(i))
            char$ = MID$(lines(i), j, 1)
            PRINT char$;
            IF char$ <> " " THEN PLAY sounds$
            Pause (1)
        NEXT j
        IF linedata(i).linefeed THEN PRINT
        Pause (5)
    NEXT i
END SUB

SUB Pause (ticks%)
' Pause the remote terminal for x ticks'
    iter% = tickspeed% * ticks%
    IF slowbaud% THEN iter% = iter% * 5
    FOR k = 1 TO iter%
    NEXT k
END SUB

