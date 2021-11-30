'The Internet Simulator v2.0 by Peter Marks
'This Net program will give a good heaping helping of fun!
'Original incomplete version - July 1, 1998
'Version 2.0 - November 21st, 2021

'-=-=-=-=-=-=-=-=-=-=-=-'

' Subroutine declarations
DECLARE SUB Delay (ticks%)                      ' Delay by a set number of ticks
DECLARE SUB Disk (seconds%)                     ' Simulate disk access sounds for number of seconds
DECLARE SUB Diskpause (ticks%)                  ' Play a sound pause for a number of ticks (from 2^0 to 2^4)
DECLARE SUB Disksound (ticks%)                  ' Get a disk access sound for a number of ticks (from 2^0 to 2^4)
DECLARE SUB Linedelay ()                        ' Delay the local terminal for a linefeed
DECLARE SUB Lineout (startline%, numlines%)     ' Perform a lineout of the requested text lines
DECLARE SUB Pause (ticks%)                      ' Pause the remote terminal for x ticks
DECLARE SUB Setdisk (newdisk$)                  ' Set the CP/M disk drive to specified disk

' Game constants
CONST tickspeed% = 6            ' The configured tickspeed for screen output
CONST tickrate% = 32            ' The number of ticks per second for disk access time
CONST disksize% = 980           ' The size of the B: disk in kb

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
DIM SHARED ramsize%             ' 
DIM SHARED slowbaud             ' If the terminal runs at 300 baud
DIM SHARED remote               ' If the terminal is outputting remote data
DIM SHARED colorterm            ' If terminal color is enabled
DIM SHARED defaultcolor         ' The default terminal color

'-=-=-=-=-=-=-=-=-=-=-=-'

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
    server AS INTEGER           ' The target server for this file (0 for executables, -1 for none)
    event AS INTEGER            ' The triggered event if uploaded to the target server
END TYPE

TYPE GameServer                 ' A file server inside the simulator
    servername AS STRING * 20   ' Name of the server
    address AS STRING * 11      ' Phone number of the server
    model AS INTEGER            ' The model computer of the server
    online AS INTEGER           ' Whether the server is online
END TYPE

TYPE GameComputer               ' Different model computers inside the game
    modelname AS STRING * 20    ' Display name of the computer
    software AS STRING * 50     ' Name of file server program
END TYPE

'-=-=-=-=-=-=-=-=-=-=-=-'

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

'-=-=-=-=-=-=-=-=-=-=-=-'

Initialize:     ' Initializes all variables for a new game.

' Initialize global variables
ERASE cpmfiles$
cpmdisk$ = "A"
cpmfilenum% = 0
cpmspace% = disksize%
ramsize% = 20
slowbaud = TRUE
remote = FALSE
colorterm = FALSE
defaultcolor = GREEN

'-=-=-=-=-=-=-=-=-=-=-=-'

Menu:           ' Main game menu

'-=-=-=-=-=-=-=-=-=-=-=-'

Intro:          ' Game Introduction

' 

'-=-=-=-=-=-=-=-=-=-=-=-'

CPM:            ' Literally emulate CP/M enough to make it convincing.

' Boot Routine
CLS
COLOR GREEN, BLACK
Disk (4)
CALL Lineout(1, 3)
Delay (4)
PRINT
Disk (2)
Delay (4)

Prompt:         ' CP/M Disk Prompt
COLOR GREEN, BLACK
PRINT cpmdisk$;
LINE INPUT ">", cmd$
SELECT CASE cmd$
    CASE "STAT"         ' Provides disk usage information
        IF cpmdisk$ = "B" THEN
            PRINT "STAT?"
            Delay (4)
        ELSE
            Delay (6): PRINT "A: R/O, Space: "; : Disk (3): PRINT "68k": Delay (6)
            readtime% = INT(((disksize% - cpmspace%) / disksize%) * 14) + 1
            PRINT "B: R/W, Space:"; : Disk (readtime%): Delay (6)
            PRINT STR$(cpmspace%) + "k"; : PRINT : PRINT
        END IF

    CASE "DIR"          ' Provides a directory listing for active drive
        PRINT "DIR isn't written yet."
        ' TAB can help with string formatting

    CASE "MONITOR"      ' System Monitor
        PRINT "MONITOR isn't written yet."

    CASE "MOVCPM"       ' Create 63K CP/M Image
        PRINT "MOVCPM isn't written yet."

    CASE "SYSGEN"       ' System

    CASE "SCORE"        ' Get a score of how you're doing
        PRINT "SCORE isn't written yet."

    CASE "QUIT"         ' Quit the game
        END

    ' Debug commands for STAT command
    CASE "FULLDISK"
        cpmspace% = 16

    CASE "HALFDISK"
        cpmspace% = INT(disksize% / 2)

    CASE "FREEDISK"
        cpmspace% = disksize%

    CASE "RANDDISK"
        cpmspace% = INT(RND * disksize% + 1)

    ' Debug commands for Lineout subroutine
    CASE "SATURN"
        CALL Lineout(65, Totallines)

    CASE "TEST"
        CALL Lineout(1, Totallines)

    ' Debug command for toggling terminal color
    CASE "COLOR"
        IF colorterm THEN
            colorterm = FALSE
        ELSE
            colorterm = TRUE
        END IF

    ' Debug command for toggling baud rate
    CASE "BAUD"
        IF slowbaud THEN
            slowbaud = FALSE
        ELSE
            slowbaud = TRUE
        END IF

    ' Debug command for toggling remote output
    CASE "REMOTE"
        IF remote THEN
            remote = FALSE
        ELSE
            remote = TRUE
        END IF

    ' Debug the Delay() tickrate
    CASE "DELAY"
        Delay (32)

    CASE "A:"           ' Change to A drive
        Setdisk ("A")
        Delay (4)

    CASE "B:"           ' Change to B drive
        Setdisk ("B")
        Delay (4)

    CASE ""
        Delay (4)

    CASE ELSE
        PRINT cmd$ + "?"
        Delay (4)

END SELECT

GOTO Prompt

' Commands:
' A: - Switch to A: Disk - Contains CPM and program, disk full
' B: - Switch to B: Disk - Contains
' DIR - List Directory
' ERA - Erase File
' A: STAT.COM, HELP.COM, MODEM.COM, MENU.COM, SCORE.COM, HINT.COM

'-=-=-=-=-=-=-=-=-=-=-=-'

Modem:          ' MODEM.COM - Program for dialing out to computers
' The name couldn't be more vanilla if it tried.

' Improvements to include:
' ISP Beta Program - Faster network transmission and display times
' Terminal Proxy - Connect through other servers
' Color Terminal Support - Download illegally
' Favorites - Address book for servers found on the Internet

'-=-=-=-=-=-=-=-=-=-=-=-'

PubNews:        ' The Public News Server
' Run by some hippie with Birkenstocks or something.

' Articles:

' Radioactive Soviet Spy Satellite Crashes to Earth
' WASHINGTON, January 23rd
' The US Defense Department reported a radioactive section of a Soviet nuclear-
' powered surveillance satellite fell out of orbit at 5:21pm and disintegrated
' over the Indian Ocean. The four-ton chunk was from Cosmos 1402, which broke
' apart last year during an orbital maneuver. The highly radioactive chunk has
' appeared to completely disintegrate over a remote section of the Indian Ocean.

' Confrontations in Lebanon Worrying Pentagon Officials
' BEIRUT, January 23rd
' According to sources from the Pentagon, a Marine Corps rifleman was ordered not
' to fire at an Isreli soldier in his sights yesterday. This event is the closest
' call yet in a series of military confrontations in Lebanon. Concerns over self-
' defense and rules of engagement by US soldiers are fueling the recent incidents.
' The Isreli military command has denied any confrontation, physical or verbal.

' OPEC to Lower Output Levels Due to Dropping Oil Prices
' GENEVA, January 23rd
' The Organization of Petroleum Exporting Countries reached an agreement on a
' plan to reduce their joint output in response to recent dropping oil prices.
' During the emergency session, the OPEC oil ministers have agreed to reduce the
' joint output ceiling of 18.5 million barrels per day by at least 1 million.
' The price per barrel, currently set at $34, is expected to rise as result.

' NASA Set To Launch Infrared Satellite on Wednesday
' WASHINGTON, January 23rd
' NASA has reported that it is on-track for launching the Infrared Astronomical
' Satellite (IRAS) on Wednesday. The satellite will be launched from Vandenberg
' Air Force Base by a Delta 3910 rocket for performing a survey of the night sky
' at infrared wavelengths. NASA also confirmed rumors of issues with the rocket
' and satellite, but reassured that they are on-schedule for the 25th launch.

' Dolphins Beat Jets 14-0, Will Play Redskins in Super Bowl
' MIAMI, January 23rd
' The Miami Dolphins shut out the New York Jets 14-0, taking the AFC Championship
' and advancing to the Super Bowl, where they will face the Washington Redskins
' at Super Bowl XVII. The Dolphins defeated their NY rival with strong offensive
' play and 2 touchdowns in the second half. They will compete against Washington
' in a Super Bowl VII rematch, where Miami claimed a 14-7 victory a decade ago.

' Popular NYC Hacker BBS Comes Back Online After Four-Month Haitus
' NEW YORK, January 23rd
' A popular BBS from New York City known as HACCBBS is back online after a four-
' month hiatus where the status of the BBS was unknown. The sysop known by the
' alias G4ndalf brought the system back online yesterday, citing concerns of FBI
' surveillance for going dark until security measures could be taken. The BBS is
' available again at 212-638-4805 and is accepting old and new users.

'-=-=-=-=-=-=-=-=-=-=-=-'

HACCBBS:        ' The Hacker and Computing Connoisseur Bulletin Board System.
' I know how to name shit.

' News - Recent news (find link to NASA Public Gateway)
' Topics - Movies, Space, CPM, MSDOS, V-TEE
' Files - .GRB file formats (garbage), .DAT (used for tasks), .COM (executables)

'-=-=-=-=-=-=-=-=-=-=-=-'

BellFone:       ' BellFone Customer Services Portal
' For customers of the BellFone Telephone Services Corporation
' Which you're not, so go 'way. Shoo.

'-=-=-=-=-=-=-=-=-=-=-=-'

Gateway:        ' The NASA Public Gateway
' Your tax dollars paid for this.

'-=-=-=-=-=-=-=-=-=-=-=-'

CPN:            ' NASA's Classified Private Network (CPN)

'-=-=-=-=-=-=-=-=-=-=-=-'

XPLOD:          ' The X-Series Probe Launcer and Orbiting Director, Version 3.
' IBM calls it the X-PLOD-3. That's totally not telling.

'-=-=-=-=-=-=-=-=-=-=-=-'

' Individual lines of text data
' Total number of text lines:
' Format:   fgcolor%, bgcolor%, linefeed%, text$
' Example:  DATA LIME, BLACK, TRUE, "line of text"
Textlines:
DATA 97
DATA  2, 0, 1,  "20K CP/M"
DATA  2, 0, 1,  "Version 2.2mits (07/28/80)"
DATA  2, 0, 1,  "Copyright 1980 by Burcon Inc."
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
DATA 10, 0, 0,  " *"
DATA 10, 0, 0,  "********************************************************************************"
DATA 10, 0, 1,  "* 1) CHECK SATELLITE"
DATA 10, 0, 1,  "* 2) CHECK SPACE SHUTTLE"
DATA 10, 0, 1,  "* 3) CHECK BOOSTER ROCKETS"
DATA 10, 0, 1,  "* 4) CHECK MAIN CONTROLS"
DATA 10, 0, 1,  "* 5) CHECK FUEL T7ANK"
DATA 10, 0, 1,  "* 6) ACTIVATE EBS SYSTEM"
DATA 10, 0, 1,  "* 7) ACTIVATE HES SYSTEM"
DATA 10, 0, 1,  "* 8) ACTIVATE LAUNCH PREPARATION..."
DATA 10, 0, 1,  "* 9) RETURN TO GUEST LEVEL SECURITY"
DATA 10, 0, 0,  "********************************************************************************"
DATA 10, 0, 1,  " "
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
DATA 14, 0, 1,  " .       .   \/    \/  /____/      \____\ |___|  \____________/"
DATA 14, 0, 1,  "                               .                                        ."
DATA 14, 0, 1,  "     .                           .         .               .                 ."
DATA 14, 0, 1,  "                .                                   .            ."
DATA  6, 0, 1,  "                                         _.oo."
DATA  9, 0, 0,  "                 _.u[[/;:,.         "
DATA  6, 0, 1,  ".odMMMMMM'"
DATA  9, 0, 0,  "              .o888UU[[[/;:-.  "
DATA  6, 0, 1,  ".o@P^    MMM^"
DATA  9, 0, 0,  "             oN88888UU[[[/;::-.        "
DATA  6, 0, 1,  "dP^"
DATA  9, 0, 0,  "            dNMMNN888UU[[[/;:--.   "
DATA  6, 0, 1,  ".o@P^"
DATA  9, 0, 0,  "           ,MMMMMMN888UU[[/;::-. "
DATA  6, 0, 1,  "o@^"
DATA  9, 0, 0,  "           NNMMMNN888UU[[[/~."
DATA  6, 0, 1,  "o@P^"
DATA  9, 0, 0,  "           888888888UU[[[/"
DATA  6, 0, 0,  "o@^"
DATA  9, 0, 1,  "-.."
DATA  6, 0, 0,  "          o"
DATA  9, 0, 0,  "I8888UU[[[/"
DATA  6, 0, 0,  "o@P^"
DATA  9, 0, 1,  ":--.."
DATA  6, 0, 0,  "       .@^  "
DATA  9, 0, 0,  "YUU[[[/"
DATA  6, 0, 0,  "o@^"
DATA  9, 0, 1,  ";::---.."
DATA  6, 0, 0,  "     oMP     "
DATA  9, 0, 0,  "^/"
DATA  6, 0, 0,  "o@P^"
DATA  9, 0, 1,  ";:::---.."
DATA  6, 0, 0,  "  .dMMM    .o@^ "
DATA  9, 0, 1,  "^;::---..."
DATA  6, 0, 0,  " dMMMMMMM@^`       "
DATA  9, 0, 1,  "`^^^^"
DATA  6, 0, 1,  "MMMUP^"
DATA  6, 0, 1,  " ^^"
DATA 

'D>SURVEY
'                *** System Survey (June 82) ***
'
'Drive A: 28K bytes in 3 files with 8148K bytes remaining
'Drive C: 32K bytes in 9 files with 8160K bytes remaining
'Drive D: 32K bytes in 12 files with 8160K bytes remaining
'
'Memory map:
'0       8       16      24      32      40      48      56      64
'|       |       |       |       |       |       |       |       |
' TTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTCCCBBBBBBB
'T=TPA   C=CPM   B=BIOS or unassigned    R=ROM or bad
'BIOS at E603    iobyte 01       drive 03        BDOS at D806
'
'65535 Bytes RAM         0 Bytes ROM             55302 Bytes in TPA
'0 Bytes Empty           65535 Total Active Bytes
'
'Active I/O ports:
'10 11 12 13 14 15 16 17 


'-=-=-=-=-=-=-=-=-=-=-=-'

Events:
' A single formatted response from a server.
' Format: points%, oneshot%
DATA 1      ' Number of outputs
DATA "useless file", 0, 2, 3, "value"

'-=-=-=-=-=-=-=-=-=-=-=-'

Headers:    ' A formatted header for use in multiple screens
' Format:
DATA 0      ' Number of headers

'-=-=-=-=-=-=-=-=-=-=-=-'

Screens:    ' A formatted game screen with header and body
' Format: header%, startline%, numlines%
DATA 0      ' Number of game screens

'-=-=-=-=-=-=-=-=-=-=-=-'

GameFiles:  ' Data files inside the game
' Format: filename$, size%, server%, event%
DATA 2      ' Number of outputs
DATA "EXAMPLE.COM", 20, 1, 1
DATA "GARBAGE.GRB", 18, -1, 1

'-=-=-=-=-=-=-=-=-=-=-=-'

Servers:

'-=-=-=-=-=-=-=-=-=-=-=-'

Computers:  ' Different model computers inside the game

' Computers to include:

' Apple II
' TRS-80
' Atari 800
' Commodore VIC-20
' Commodore 64
' ZX Spectrum
' TI-99/4
' IBM PC Compatible

'-=-=-=-=-=-=-=-=-=-=-=-'

SUB Delay (ticks%)
' Delay the local terminal for number of ticks
    iter& = tickspeed% * ticks% * 100
    FOR k = 1 TO iter&
    NEXT k
END SUB

SUB Disk (seconds%)
' Simulate disk access sounds for number of seconds
    ticks% = seconds% * tickrate%
    DO WHILE ticks% > 0
        ' Pause before/between disk operations
        pausetime% = 2 ^ INT(RND * 3 + 3)       ' 2^3 - 2^5
        Diskpause (pausetime%)
        ticks% = ticks% - pausetime%

        ' Pick a random disk event
        roll% = INT(RND * 100)
        SELECT CASE roll%
            CASE IS < 60    ' One long access sound
                Disksound (32)
                ticks% = ticks% - 32

            CASE IS < 85    ' One quick access sound
                Disksound (4)
                ticks% = ticks% - 4

            CASE IS < 90    ' Three quick access sounds
                FOR i = 1 TO 3
                    Disksound (4)
                    Diskpause (8)
                NEXT i
                ticks% = ticks% - 36

            CASE IS < 95    ' Quick-long-quick sequence
                Disksound (4)
                Diskpause (8)
                Disksound (32)
                Diskpause (8)
                Disksound (4)
                ticks% = ticks% - 56

            CASE ELSE       ' Two long access sounds
                Disksound (32)
                Diskpause (8)
                Disksound (32)
                Diskpause (8)
                ticks% = ticks% - 80
        END SELECT
    LOOP
    Delay (seconds%)
END SUB

SUB Diskpause (ticks%)
' Play a sound pause for a number of ticks (from 2^0 to 2^4)
    PLAY "T255P" + STR$(INT(tickrate% / ticks%))
END SUB

SUB Disksound (ticks%)
' Get a disk access sound for a number of ticks (from 2^0 to 2^4)
    PLAY "T255MLMFO1L" + STR$(INT(tickrate% / ticks%)) + "A"
END SUB

SUB Linedelay
' Delay the local terminal for a linefeed
    FOR k = 1 TO tickspeed% * 25
    NEXT k
END SUB

SUB Lineout (startline%, numlines%)
' Perform a lineout of the requested text lines
    sounds$ = "T255MSMFO4L64A-"
    IF slowbaud THEN sounds$ = "T255MSMFO5L64EO4A-P64"

    FOR i = startline% TO startline% + numlines% - 1
        IF colorterm = TRUE THEN COLOR linedata(i).fgcolor, linedata(i).bgcolor
        IF remote THEN
            FOR j = 1 TO LEN(lines(i))
                char$ = MID$(lines(i), j, 1)
                PRINT char$;
                IF char$ <> " " THEN PLAY sounds$
                Pause (1)
            NEXT j
            CALL Linedelay
        ELSE
            IF linedata(i).linefeed THEN CALL Linedelay
            PRINT lines(i);
            IF linedata(i).linefeed THEN CALL Linedelay
        END IF
        IF linedata(i).linefeed THEN PRINT
    NEXT i
END SUB

SUB Pause (ticks%)
' Pause the remote terminal for x ticks
    iter% = tickspeed% * ticks%
    IF slowbaud THEN iter% = iter% * 5
    FOR k = 1 TO iter%
    NEXT k
END SUB

SUB Setdisk (newdisk$)
' Set the CP/M disk drive to specified disk
    IF cpmdisk$ <> newdisk$ THEN
        Disk (2)
        Delay (25)
    END IF
    cpmdisk$ = newdisk$
END SUB

