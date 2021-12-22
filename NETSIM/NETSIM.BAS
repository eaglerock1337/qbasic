'The Internet Simulator by Peter Marks
'A text-based adventure game based on the early 80's Internet.
'The idea is from old code I wrote when I was 15 and I recently rediscovered.

'Yes, clearly it's inspired by WarGames. Duh.

'I can only assume I recently saw the film since I have no recollection of
'writing it whatsoever. However, I've written the successor game to be as
'accurate as possible in terms of feel and authenticity, taking creative
'license only when necessary.

'While the modem software, servers, game events are fictional (and let's just
'ignore my lazy and wrong use of QAM as a way of "unlocking" faster modem
'speeds), everything else, including the computers, CP/M and its utilities, the
'news events of the day (everything up to my "rumors" and fictional servers), how
'the early 80's Internet worked, BBSes, USENET, as well as the look, sound, and
'speed of terminals are as faithful to the real thing as I can manage.

'Original attempt: July 1, 1998
'New attempt: November 21st, 2021
'Version 1.0 completed:

'-=-=-=-=-=-=-=-=-=-=-=-'

' Subroutine declarations
DECLARE SUB Delay (ticks%)                      ' Delay by a set number of ticks
DECLARE SUB Disk (seconds%)                     ' Simulate disk access sounds for number of seconds
DECLARE SUB Diskpause (ticks%)                  ' Play a sound pause for a number of ticks (from 2^0 to 2^4)
DECLARE SUB Diskseek (ticks%)                  ' Get a disk access sound for a number of ticks (from 2^0 to 2^4)
DECLARE SUB Linedelay ()                        ' Delay the local terminal for a linefeed
DECLARE SUB Lineout (startline%, numlines%)     ' Perform a lineout of the requested text lines
DECLARE SUB Pause (ticks%)                      ' Pause the remote terminal for x ticks
DECLARE SUB Printdir ()                         ' Print the DIR command to the CP/M terminal
DECLARE SUB Printdirout (filenum%, filedata%()) ' Helper routine for printing DIR command
DECLARE SUB Printstat ()                        ' Print the STAT command to the CP/M terminal
DECLARE SUB Setdisk (newdisk$)                  ' Set the CP/M disk drive to specified disk

' Game constants
CONST tickspeed% = 6            ' The configured tickspeed for screen output
CONST tickrate% = 32            ' The number of ticks per second for disk access time
CONST disksize% = 245           ' The size of the B: disk in 4kb blocks

' Boolean constants
CONST TRUE = 1
CONST FALSE = 0

' Dark colors (FG and BG)       Light colors (FG only)
CONST BLACK = 0:                CONST GRAY = 8
CONST NAVY = 1:                 CONST BLUE = 9
CONST GREEN = 2:                CONST LIME = 10
CONST TEAL = 3:                 CONST CYAN = 11
CONST MAROON = 4:               CONST RED = 12
CONST PURPLE = 5:               CONST MAGENTA = 13
CONST OLIVE = 6:                CONST YELLOW = 14
CONST SILVER = 7:               CONST WHITE = 15

' Text type contstants
CONST DEMO = 1

' Global variables
DIM SHARED cpmdisk$             ' Current CP/M Disk Drive
DIM SHARED cpmanum%             ' Number of files on A: drive
DIM SHARED cpmafiles%(16)       ' The list of files on the A: drive
DIM SHARED cpmbnum%             ' Number of files on B: drive
DIM SHARED cpmbfiles%(40)       ' The list of files on the B: drive
DIM SHARED cpmspace%            ' Available B: drive space in KB
DIM SHARED ramsize%             ' The size of of the CP/M system
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
    displayname AS STRING * 12  ' The display format of the file (e.g. 'MODEM     COM')
    blocks AS INTEGER           ' The number of 4kb blocks the file uses
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

Loaddata:       ' Load all game data from .DAT and .TXT files

' Open files for reading game text
OPEN "NETSIM\DEMO.DAT" FOR INPUT AS #1

' Create data length and offset variables
DIM SHARED demooffset AS INTEGER
DIM SHARED demolines AS INTEGER
DIM SHARED totallines AS INTEGER

demooffset = 0
INPUT #1, demolines
totallines = demolines

' Read demo text data
DIM SHARED lines(1 TO totallines) AS STRING
DIM SHARED linedata(1 TO totallines) AS TextData
FOR i = 1 TO totallines
    INPUT #1, linedata(i).fgcolor, linedata(i).bgcolor, linedata(i).linefeed, lines(i)
NEXT i

' Close game text files
CLOSE #1

' Retrieve game file data
OPEN "NETSIM\FILES.DAT" FOR INPUT AS #1

DIM SHARED totalfiles AS INTEGER
INPUT #1, totalfiles
DIM SHARED gamefilenames(1 TO totalfiles) AS STRING
DIM SHARED gamefiles(1 TO totalfiles) AS GameFile

FOR i = 1 TO totalfiles
    INPUT #1, gamefiles(i).displayname, gamefiles(i).blocks, gamefiles(i).server, gamefiles(i).event, gamefilenames(i)
NEXT i

CLOSE #1

' TODO: Each type of data (screens, usenet posts, events, etc.)
'       as DAT files with text and lineout data as TXT files
'       Functions for loading each type of data
'       Variables for text and metadata
' E.G.: USENET.DAT holds the usenet post metadata
'       USENET.TXT holds the text and lineout data
'       LoadUsenet() loads the usenet metadata
'       LoadLines("USENET.TXT") loads the lineout data
'       usenet(totusenet%) holds the usenet metadata
'       usenetlines$(totusenetlines%) holds the lineout data

'-=-=-=-=-=-=-=-=-=-=-=-'

Initialize:     ' Initializes all variables for a new game.

' Initialize global variables
ERASE cpmafiles%, cpmbfiles%
cpmanum% = 11: cpmbnum% = 0
FOR i = 1 TO cpmanum%
    cpmafiles%(i) = i
NEXT i
cpmspace% = disksize%
cpmdisk$ = "A"
ramsize% = 20
slowbaud = TRUE
remote = FALSE
colorterm = FALSE
defaultcolor = GREEN

'-=-=-=-=-=-=-=-=-=-=-=-'

Menu:           ' Main game menu

'-=-=-=-=-=-=-=-=-=-=-=-'

Intro:          ' Game Introduction

' View Introduction
'

' Missions
'
' Resize CP/M - Grants access to certain programs (MODEM.COM, SCORE)
' Connect to BellNet and find the news server (link to HACCBBS offline)
' Connect to News Server for first time
' Conect to HACCBBS for the first time
' Download Modem Test Utility and use to determine you have 300bps
' Help your first person on USENET (MOVCPM)
' Contact from G4ndalf - get the cracked MODEM application
' - allows selection of 2400BPS but doesn't work until QAM works
' - enables public filesystem access for your account
' Help two more USENET users
' Unlock QAM and 2400BPS from AT&T
'



'- Unlock color
'- Unlock long-distance phreaking
'- Unlock side missions?
'- Unlock NASA Gateway
'- Get password to NASA Gateway User
'- Find better password on network somewhere
'-

'-=-=-=-=-=-=-=-=-=-=-=-'

CPM:            ' Literally emulate CP/M enough to make it convincing.

' Boot Routine
CLS
COLOR defaultcolor, BLACK
Disk (4)
CALL Lineout(1, 3)
Delay (4)
PRINT
Disk (2)
Delay (4)

Prompt:         ' CP/M Disk Prompt
COLOR defaultcolor, BLACK
PRINT cpmdisk$;
LINE INPUT ">", cmd$
SELECT CASE cmd$
    CASE "STAT"         ' Provides disk usage information
        CALL Printstat

    CASE "DIR"          ' Provides a directory listing for active drive
        CALL Printdir

    CASE "MONITOR"      ' System Monitor
        PRINT "MONITOR isn't written yet."

    CASE "MOVCPM"       ' Create 63K CP/M Image
        PRINT "MOVCPM isn't written yet."

    CASE "SYSGEN"       ' Apply CP/M to disk
        PRINT "SYSGEN isn't written yet."

    CASE "SCORE"        ' Get a score of how you're doing
        PRINT "SCORE isn't written yet."

    CASE "QUIT"         ' Quit the game
        END

    ' Debug commands for DIR command
    CASE "FILES"
        cpmbnum% = 5
        FOR i = 1 TO 5
            cpmbfiles%(i) = i + 12
        NEXT i

    CASE "FILENAME"
        FOR i = 1 TO 5
            PRINT "***" + gamefilenames(i) + "***"
        NEXT i

    ' Debug commands for terminal color
    CASE "GREEN"
        defaultcolor = GREEN

    CASE "AMBER"
        defaultcolor = OLIVE

    ' Debug commands for Lineout subroutine
    CASE "SATURN"
        CALL Lineout(65, 34)

    CASE "TEST"
        CALL Lineout(1, totallines)

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

    CASE "B:"           ' Change to B drive
        Setdisk ("B")

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


'-=-=-=-=-=-=-=-=-=-=-=-'

HACCBBS:        ' The Hacker and Computing Connoisseur Bulletin Board System.
' I know how to name shit.

' Digital News - Recent news (find link to NASA Public Gateway)
' Pages - BBS pages
' Best of USENET - best-of threads curated by the SYSOP
' Files - .GRB file formats (garbage), .DAT (used for tasks), .COM (executables)

'-=-=-=-=-=-=-=-=-=-=-=-'

BellNet:        ' AT&T's Customer Service Portal
' Not real, but I can picture some of those Bell Labs guys doing something like this.

' Payment History
' Monthly Usage
' Local calls: 8,137 minutes
' Long-Distance calls: 0 minutes
' Shows the user has his own phone line with 8,137 monthly minutes but no long-distance charges
' Contact Us:
' About the Portal (a thing from Bell labs)
' Bell Laboratories (a thing about Bell labs)
' Trial Programs: QAM trial (enable 2400baud)

'-=-=-=-=-=-=-=-=-=-=-=-'

Gateway:        ' The NASA Public Gateway
' Your tax dollars paid for this.

'-=-=-=-=-=-=-=-=-=-=-=-'

CPN:            ' NASA's Classified Private Network (CPN)

'-=-=-=-=-=-=-=-=-=-=-=-'

XPLOD:          ' The X-Series Probe Launcer and Orbiting Director, Version 3.
' IBM calls it the X-PLOD-3. That's totally not telling.

'-=-=-=-=-=-=-=-=-=-=-=-'


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

    ' Perform initial seek
    Diskseek (16)
    ticks% = ticks% - 16

    DO WHILE ticks% >= 16
        ' Pause before/between disk operations
        pausetime% = 2 ^ INT(RND * 3 + 3)       ' 2^3 - 2^5
        Diskpause (pausetime%)
        ticks% = ticks% - pausetime%

        ' Pick a random disk event
        roll% = INT(RND * 100)
        SELECT CASE roll%
            CASE IS < 75    ' One quick seek and read
                Diskseek (2)
                Diskpause (8)
                ticks% = ticks% - 10

            CASE IS < 85    ' One medium seek
                Diskseek (4)
                Diskpause (8)
                ticks% = ticks% - 12

            CASE IS < 90    ' Two quick seeks
                FOR i = 1 TO 2
                    Diskseek (2)
                    Diskpause (16)
                NEXT i
                ticks% = ticks% - 36

            CASE IS < 95    ' Three quick seeks
                FOR i = 1 TO 3
                    Diskseek (2)
                    Diskpause (16)
                NEXT i
                ticks% = ticks% - 54

            CASE ELSE       ' Jump and two quick seeks
                Diskseek (8)
                Diskpause (16)
                Diskseek (2)
                Diskpause (8)
                Diskseek (2)
                Diskpause (8)
                Diskseek (8)
                Diskpause (16)
                ticks% = ticks% - 68
        END SELECT
    LOOP

    ' Peform final disk seek and add time delay
    Diskseek (16)
    Delay (seconds%)
END SUB

SUB Diskpause (ticks%)
' Play a sound pause for a number of ticks (from 2^0 to 2^4)
    PLAY "T255P" + STR$(INT(tickrate% / ticks%))
END SUB

SUB Diskseek (ticks%)
' Get a disk seek sound for a number of ticks (from 2^0 to 2^4)
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

SUB Printdir
' Print out the DIR command to the CP/M terminal
    IF cpmdisk$ = "A" THEN
        CALL Printdirout(cpmanum%, cpmafiles%())
    ELSE
        CALL Printdirout(cpmbnum%, cpmbfiles%())
    END IF
END SUB

SUB Printdirout (filenum%, filedata%())
' Helper routine for printing DIR command
    IF filenum% = 0 THEN
        Delay (3): PRINT "No file"
    ELSE
        rows% = 0: file% = 0
        header$ = cpmdisk$ + ": "
        spacer$ = " : "
        WHILE file% < filenum%
            Delay (3): PRINT header$; : Disk (3)
            count% = filenum% - file%
            IF count% > 4 THEN count% = 4
            FOR i% = 1 TO count%
                IF i% <> 1 THEN PRINT spacer$;
                target = filedata%(file% + 1)
                PRINT gamefiles(target).displayname;
                Delay (gamefiles(target).blocks)
                file% = file% + 1
            NEXT i%
            PRINT : rows% = rows% + 1
        WEND
        Delay (5)
    END IF
END SUB

SUB Printstat
' Print out the STAT command to the CP/M terminal
    IF cpmdisk$ = "B" THEN
        PRINT "STAT?"
        Delay (4)
    ELSE
        Delay (6): PRINT "A: R/O, Space: "; : Disk (3): PRINT "68k": Delay (6)
        readtime% = INT(((disksize% - cpmspace%) / disksize%) * 14 * 4) + 1
        PRINT "B: R/W, Space:"; : Disk (readtime%): Delay (6)
        PRINT STR$(cpmspace% * 4) + "k"; : PRINT : PRINT
    END IF
END SUB

SUB Setdisk (newdisk$)
' Set the CP/M disk drive to specified disk
    IF cpmdisk$ <> newdisk$ THEN
        Disk (2)
        Delay (25)
    END IF
    cpmdisk$ = newdisk$
END SUB

