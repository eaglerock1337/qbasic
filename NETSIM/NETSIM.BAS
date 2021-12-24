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

'-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-'

' Subroutine declarations
DECLARE SUB CPMBoot ()                          ' CP/M Boot Routine
DECLARE SUB CPMCommand (cmd$)                   ' Process a command from the CPM command prompt
DECLARE SUB CPMCommandA (cmd$, fullcmd$)        ' Process a command from the A: Drive
DECLARE SUB CPMCommandB (cmd$, fullcmd$)        ' Process a command from the B: Drive
DECLARE SUB CPMDir ()                           ' Print the DIR command to the CP/M terminal
DECLARE SUB CPMDirOut (filenum%, filedata%())   ' Helper routine for printing DIR command
DECLARE SUB CPMOutput (start%, numlines%)       ' Perform a lineout from CP/M
DECLARE SUB CPMStat ()                          ' Print the STAT command to the CP/M terminal
DECLARE SUB Disk (seconds%)                     ' Simulate disk access sounds for number of seconds
DECLARE SUB DiskPause (ticks%)                  ' Play a sound pause for a number of ticks (from 2^0 to 2^4)
DECLARE SUB DiskSeek (ticks%)                   ' Get a disk access sound for a number of ticks (from 2^0 to 2^4)
DECLARE SUB EventTask (number%)                 ' Process any event tasks by its number in the event list
DECLARE SUB EventLoad ()                        ' Process all the previous game events for loading a saved game
DECLARE SUB EventScore (number%)                ' Process a game event, update your score, and display event text
DECLARE SUB FileAdd (drive$, number%)           ' Add a file designated by its number to the destination drive
DECLARE SUB FileDel (drive$, location%)         ' Delete the file at the specified location from the specified drive
DECLARE SUB Initialize ()                       ' Initialize global game variables for a new game
DECLARE SUB LinefeedDelay ()                    ' Delay the local terminal for a linefeed
DECLARE SUB Lineout (start%, numlines%, modem)  ' Perform a lineout of the requested text lines
DECLARE SUB LineoutDelay (ticks%)               ' Delay by a set number of ticks
DECLARE SUB LineoutDemo (start%, numlines%)     ' Perform a lineout from the demo text
DECLARE SUB RemoteDelay (ticks%)                ' Pause the remote terminal for x ticks
DECLARE SUB SetDisk (newdisk$)                  ' Set the CP/M disk drive to specified disk

' Function Declarations
DECLARE FUNCTION FileSeek (drive$, number%)     ' Returns the location of the file if found, 0 otherwise

' Game constants
CONST tickspeed% = 6            ' The configured tickspeed for screen output
CONST tickrate% = 32            ' The number of ticks per second for disk access time
CONST diskasize% = 125          ' The size of the A: disk in 4kb blocks
CONST diskbsize% = 245          ' The size of the B: disk in 4kb blocks

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

' For selecting the default color
CONST DEFAULT = -1

' Global game variables
DIM SHARED cpmanum%             ' Number of files on A: drive
DIM SHARED cpmafiles%(16)       ' The list of files on the A: drive
DIM SHARED cpmaspace%           ' Available A: drive space in KB
DIM SHARED cpmbnum%             ' Number of files on B: drive
DIM SHARED cpmbfiles%(40)       ' The list of files on the B: drive
DIM SHARED cpmbspace%           ' Available B: drive space in KB
DIM SHARED cpmcolor             ' The default terminal color used by CP/M
DIM SHARED cpmdisk$             ' Current CP/M Disk Drive
DIM SHARED cpmramsize%          ' The size of of the CP/M system
DIM SHARED gameloaded           ' If the game is loaded
DIM SHARED gameevents%(100)     ' List of game events that have occurred
DIM SHARED gameeventtotal%      ' Total game events that have taken place
DIM SHARED modemcolor           ' If terminal color is enabled
DIM SHARED modemtextcolor       ' Default modem text color
DIM SHARED modemslowbaud        ' If the terminal runs at 300 baud

' Debug Globals (to be removed)
DIM SHARED demoremote           ' If the demo text is remote or not

'-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-'
' Custom data types
'-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-'

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

'-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-'
' Load all game data from .DAT and .TXT files
'-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-'

' Open files for reading game text
OPEN "NETSIM\CPM.DAT" FOR INPUT AS #1
OPEN "NETSIM\DEMO.DAT" FOR INPUT AS #2

' Create data length and offset variables
DIM SHARED cpmoffset AS INTEGER
DIM SHARED cpmlines AS INTEGER
DIM SHARED demooffset AS INTEGER
DIM SHARED demolines AS INTEGER
DIM SHARED totallines AS INTEGER

' Read file headers and populate variables
cpmoffset = 0
INPUT #1, cpmlines
demooffset = cpmlines
INPUT #2, demolines
totallines = cpmlines + demolines

' Read demo text data
DIM SHARED lines(1 TO totallines) AS STRING
DIM SHARED linedata(1 TO totallines) AS TextData
FOR I = cpmoffset + 1 TO cpmoffset + cpmlines
    INPUT #1, linedata(I).fgcolor, linedata(I).bgcolor, linedata(I).linefeed, lines(I)
NEXT I
FOR I = demooffset + 1 TO demooffset + demolines
    INPUT #2, linedata(I).fgcolor, linedata(I).bgcolor, linedata(I).linefeed, lines(I)
NEXT I

' Close game text files
CLOSE #1, #2

' Retrieve game file data
OPEN "NETSIM\FILES.DAT" FOR INPUT AS #1

DIM SHARED totalfiles AS INTEGER
INPUT #1, totalfiles
DIM SHARED gamefilenames(1 TO totalfiles) AS STRING
DIM SHARED gamefiles(1 TO totalfiles) AS GameFile

FOR I = 1 TO totalfiles
    INPUT #1, gamefiles(I).displayname, gamefiles(I).blocks, gamefiles(I).server, gamefiles(I).event, gamefilenames(I)
NEXT I

CLOSE #1

' Indicate a game isn't loaded yet
gameloaded = FALSE

'-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-'

Menu:           ' Main game menu

' Alpha development menu (none of this stays, capiche?)
CLS
COLOR OLIVE, BLACK
PRINT : PRINT : PRINT
PRINT "1 - New Game"
PRINT "2 - Back to CP/M"
PRINT "3 - Reset Altair"
PRINT "4 - Quit"
LINE INPUT "Select: ", menuselect$

SELECT CASE menuselect$
    CASE "1"
        CALL Initialize
        CALL CPMBoot
        GOTO CPM
    CASE "2"
        IF gameloaded THEN GOTO CPM
    CASE "3"
        IF gameloaded THEN
            CALL CPMBoot
            GOTO CPM
        END IF
    CASE "4"
        END
END SELECT

GOTO Menu

'-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-'

CPM:            ' CP/M Disk Prompt

COLOR cpmcolor, BLACK
PRINT cpmdisk$;
LINE INPUT ">", cmd$

' Return to menu or process command
IF cmd$ = "QUIT" THEN GOTO Menu
CALL CPMCommand(cmd$)

GOTO CPM

'-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-'

modem:          ' MODEM.COM - Modem dialing software
' You best not be dialing LONG DISTANCE with that thing or I swear!

'-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-'

Postel:         ' Postal Telemessaging Server
' Not for your spam messages, please. This is 1983. Not yet. Just chill.

'-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-'

PubNews:        ' The Public News Server
' Run by some hippie with Birkenstocks or something.

'-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-'

HACCBBS:        ' The Hacker and Computing Connoisseur Bulletin Board System.
' I know how to name shit.

' Digital News - Recent news (find link to NASA Public Gateway)
' Pages - BBS pages
' Best of USENET - best-of threads curated by the SYSOP
' Files - .GRB file formats (garbage), .DAT (used for tasks), .COM (executables)

'-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-'

Fileserver:       ' Game fileservers
' For all your up-a-loadin' and down-a-loadin' needs, yee-haw!

'-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-'

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

'-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-'

Gateway:        ' The NASA Public Gateway
' Your tax dollars paid for this.

'-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-'

CPN:            ' NASA's Classified Private Network (CPN)
' How'd you get on here, boy?

'-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-'

XPLOD:          ' The X-Series Probe Launcher and Orbiting Director, Version 3.
' IBM calls it the X-PLOD-3.....great.

'-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-'
' Subroutines and Functions
'-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-'

SUB CPMBoot
' CP/M Boot Routine
    CLS
    COLOR cpmcolor, BLACK
    Disk (4)
    CALL CPMOutput(1, 3)
    LineoutDelay (4)
    PRINT : Disk (1): LineoutDelay (2)
    cpmdisk$ = "A"
END SUB

SUB CPMCommand (cmd$)
' Process a command from the CPM command prompt
    netcmd$ = UCASE$(cmd$)

    ' Process builtin commands
    SELECT CASE netcmd$
        CASE "DIR"          ' Provides a directory listing for active drive
            CALL CPMDir

        ' ********** DEBUG COMMANDS **********

        ' Debug commands for DIR command
        CASE "FILES"
            FOR I% = 13 TO 17
                CALL FileAdd("B", I%)
            NEXT I%

        ' Debug commands for terminal color
        CASE "GREEN"
            cpmcolor = GREEN

        CASE "AMBER"
            cpmcolor = OLIVE

        ' Debug commands for Lineout subroutine demos
        CASE "NASA"
            CALL LineoutDemo(1, 18)

        CASE "STARWARS"
            CALL LineoutDemo(19, 20)

        CASE "SATURN"
            CALL LineoutDemo(39, 33)

        CASE "TEXT"
            CALL LineoutDemo(72, 29)

        CASE "TEST"
            CALL LineoutDemo(1, demolines)

        CASE "REMOTE"
            IF demoremote THEN
                demoremote = FALSE
            ELSE
                demoremote = TRUE
            END IF

        ' Debug command for toggling terminal color
        CASE "COLOR"
            IF modemcolor THEN
                modemcolor = FALSE
            ELSE
                modemcolor = TRUE
            END IF

        ' Debug command for toggling baud rate
        CASE "BAUD"
            IF modemslowbaud THEN
                modemslowbaud = FALSE
            ELSE
                modemslowbaud = TRUE
            END IF

        ' Debug the LineoutDelay() tickrate
        CASE "LineoutDelay"
            LineoutDelay (32)

        ' ********** DEBUG COMMANDS **********

        CASE ""
            LineoutDelay (4)

        CASE ELSE
            ' Prepare for running commands by disk
            cmddisk$ = cpmdisk$

            ' Handle drive prefixes (e.g. A:STAT, B:TERM)
            IF LEN(netcmd$) >= 2 AND MID$(netcmd$, 2, 1) = ":" THEN
                cmddisk$ = MID$(netcmd$, 1, 1)

                ' Invalid drive select handler
                IF cmddisk$ <> "A" AND cmddisk$ <> "B" THEN
                    cpmdisk$ = "A"
                    PRINT "Bdos Err On " + cmddisk$ + ": Select";
                    WHILE newdisk$ = ""
                        newdisk$ = INKEY$
                    WEND
                    PRINT : LineoutDelay (1)
                    IF newdisk$ = "B" OR newdisk$ = "b" THEN cpmdisk$ = "B"
                    EXIT SUB
                END IF

                ' Change active drive
                IF LEN(netcmd$) = 2 THEN
                    SetDisk (cmddisk$)
                    EXIT SUB
                END IF

                ' Prepare command variables for disk processing
                cmddisk$ = MID$(netcmd$, 1, 1)
                netcmd$ = MID$(netcmd$, 3)
            END IF

            ' Process commands from disk
            IF cmddisk$ = "A" THEN
                CALL CPMCommandA(netcmd$, cmd$)
            ELSE
                CALL CPMCommandB(netcmd$, cmd$)
            END IF

    END SELECT
END SUB

SUB CPMCommandA (cmd$, fullcmd$)
' Process a command from the A: Drive
    SELECT CASE cmd$
        CASE "STAT"         ' Provides disk usage information
            CALL CPMStat

        CASE "DIR"          ' Provides a directory listing for active drive
            CALL CPMDir

        CASE "MONITOR"      ' System Monitor
            PRINT "MONITOR isn't written yet."

        CASE "MOVCPM"       ' Create 63K CP/M Image
            PRINT "MOVCPM isn't written yet."

        CASE "SYSGEN"       ' Apply CP/M to disk
            PRINT "SYSGEN isn't written yet."

        CASE "SCORE"        ' Get a score of how you're doing
            PRINT "SCORE isn't written yet."

        CASE ELSE
            PRINT fullcmd$ + "?"
            LineoutDelay (4)

    END SELECT
END SUB

SUB CPMCommandB (cmd$, fullcmd$)
' Process a command from the B: Drive
    SELECT CASE cmd$
        CASE "COLOR"        ' COLOR.COM - Color
            PRINT "B:COLOR.COM isn't written yet."

        CASE ELSE
            PRINT fullcmd$ + "?"
            LineoutDelay (4)

    END SELECT
END SUB

SUB CPMDir
' Print out the DIR command to the CP/M terminal
    IF cpmdisk$ = "A" THEN
        CALL CPMDirOut(cpmanum%, cpmafiles%())
    ELSE
        CALL CPMDirOut(cpmbnum%, cpmbfiles%())
    END IF
END SUB

SUB CPMDirOut (filenum%, filedata%())
' Helper routine for printing DIR command
    IF filenum% = 0 THEN
        LineoutDelay (3): PRINT "No file"
    ELSE
        rows% = 0: file% = 0
        header$ = cpmdisk$ + ": "
        spacer$ = " : "
        Disk (1)
        WHILE file% < filenum%
            PRINT header$; : LineoutDelay (1)
            count% = filenum% - file%
            IF count% > 4 THEN count% = 4
            FOR I% = 1 TO count%
                IF I% <> 1 THEN PRINT spacer$;
                target = filedata%(file% + 1)
                PRINT gamefiles(target).displayname;
                LineoutDelay (2)
                file% = file% + 1
            NEXT I%
            PRINT : rows% = rows% + 1
        WEND
    END IF
END SUB

SUB CPMOutput (start%, numlines%)
' Perform CP/M text output
    FOR I = cpmoffset + start% TO cpmoffset + start% + numlines% - 1
        IF linedata(I).fgcolor = DEFAULT THEN
            COLOR cpmcolor, BLACK
        ELSE
            COLOR linedata(I).fgcolor, linedata(I).bgcolor
        END IF

        IF linedata(I).linefeed THEN CALL LinefeedDelay
        PRINT lines(I);
        IF linedata(I).linefeed THEN
            CALL LinefeedDelay
            PRINT
        END IF
    NEXT I
END SUB

SUB CPMStat
' Print out the STAT command to the CP/M terminal
    LineoutDelay (6): PRINT "A: R/O, Space:"; : Disk (2)
    PRINT STR$(cpmaspace% * 4) + "k": LineoutDelay (6)
    PRINT "B: R/W, Space:"; : Disk (2): LineoutDelay (6)
    PRINT STR$(cpmbspace% * 4) + "k"; : PRINT : PRINT
END SUB

SUB Disk (seconds%)
' Simulate disk access sounds for number of seconds
    ticks% = seconds% * tickrate%

    ' Perform long disk seek if longer than 1 second
    IF seconds% > 1 THEN
        DiskSeek (16)
        ticks% = ticks% - tickrate%
    END IF

    DO WHILE ticks% > 0
        ' pause before/between disk operations
        pausetime% = 2 ^ INT(RND * 3 + 3)       ' 2^3 - 2^5
        DiskPause (pausetime%)
        ticks% = ticks% - pausetime%

        ' Pick a random disk event
        roll% = INT(RND * 100)
        SELECT CASE roll%
            CASE IS < 75    ' One quick seek and read
                DiskSeek (2)
                DiskPause (8)
                ticks% = ticks% - 10

            CASE IS < 85    ' One medium seek
                DiskSeek (4)
                DiskPause (16)
                ticks% = ticks% - 20

            CASE IS < 90    ' Two quick seeks
                FOR I = 1 TO 2
                    DiskSeek (2)
                    DiskPause (16)
                NEXT I
                ticks% = ticks% - 36

            CASE IS < 95    ' Three quick seeks
                FOR I = 1 TO 3
                    DiskSeek (2)
                    DiskPause (16)
                NEXT I
                ticks% = ticks% - 54

            CASE ELSE       ' Jump and two quick seeks
                DiskSeek (8)
                DiskPause (16)
                DiskSeek (2)
                DiskPause (8)
                DiskSeek (2)
                DiskPause (8)
                DiskSeek (8)
                DiskPause (16)
                ticks% = ticks% - 68
        END SELECT
    LOOP

    ' Perform final disk seek if over 1 second and add time delay
    IF seconds% > 1 THEN DiskSeek (16)
    LineoutDelay (seconds%)
END SUB

SUB DiskPause (ticks%)
' Play a sound pause for a number of ticks (from 2^0 to 2^4)
    PLAY "T255P" + STR$(INT(tickrate% / ticks%))
END SUB

SUB DiskSeek (ticks%)
' Get a disk seek sound for a number of ticks (from 2^0 to 2^4)
    PLAY "T255MLMFO1L" + STR$(INT(tickrate% / ticks%)) + "A"
END SUB

SUB EventLoad
' Process all the previous game events for loading a saved game
    ' For each item in the list, call GameEvent
    ' Updates all the stuff without
END SUB

SUB EventScore (number%)
' Process a game event, update your score, and display event text
    CALL EventTask(number%)
    ' Update score from event list
    ' Display text from the event text (optional)
    gameeventtotal% = gameeventtotal% + 1
    gameevents%(gameeventtotal%) = number%
END SUB

SUB EventTask (number%)
' Process any event tasks by its number in the event list
    ' Look up the event in the list
    ' Process each individual instructions (editing data, outputs, etc.)
END SUB

SUB FileAdd (drive$, number%)
' Add a file designated by its number to the destination drive
    ' Delete the file if it's present first
    fileloc% = FileSeek(drive$, number%)
    IF fileloc% <> 0 THEN CALL FileDel(drive$, fileloc%)

    ' Yes, this is lazy. Sue me.
    IF drive$ = "A" THEN
        cpmanum% = cpmanum% + 1
        cpmafiles%(cpmanum%) = number%
        cpmaspace% = cpmaspace% - gamefiles(number%).blocks
    ELSEIF drive$ = "B" THEN
        cpmbnum% = cpmbnum% + 1
        cpmbfiles%(cpmbnum%) = number%
        cpmbspace% = cpmbspace% - gamefiles(number%).blocks
    ELSE    ' Lazy (hopefully) temporary error handling
        PRINT "FileAdd Error: How the hell did you get here?"
        END
    END IF
END SUB

SUB FileDel (drive$, location%)
' Delete the file at the specified location from the specified drive
    ' Yes, this is also lazy. Sue me.
    IF drive$ = "A" THEN
        blocks% = gamefiles(cpmafiles%(location%)).blocks
        cpmaspace% = cpmaspace% + blocks%
        cpmanum% = cpmanum% - 1
        FOR I = location% TO cpmanum%
            cpmafiles%(I) = cpmafiles%(I + 1)
        NEXT I
    ELSEIF drive$ = "B" THEN
        blocks% = gamefiles(cpmafiles%(location%)).blocks
        cpmbspace% = cpmbspace% + blocks%
        cpmbnum% = cpmbnum% - 1
        FOR I = location% TO cpmbnum%
            cpmbfiles%(I) = cpmbfiles%(I + 1)
        NEXT I
    ELSE    ' Lazy (hopefully) temporary error handling
        PRINT "FileDel Error: How the hell did you get here?"
        END
    END IF
END SUB

FUNCTION FileSeek (drive$, number%)
' Returns the location of the file if found, 0 otherwise
    IF drive$ = "A" THEN
        FOR I = 1 TO cpmanum%
            IF cpmafiles%(I) = number% THEN
                FileSeek = I
                EXIT FUNCTION
            END IF
        NEXT I
        FileSeek = 0
    ELSEIF drive$ = "B" THEN
        FOR I = 1 TO cpmbnum%
            IF cpmbfiles%(I) = number% THEN
                FileSeek = I
                EXIT FUNCTION
            END IF
        NEXT I
        FileSeek = 0
    ELSE    ' Lazy (hopefully) temporary error handling
        PRINT "FileSeek Error: How the hell did you get here?"
        END
    END IF
END FUNCTION

SUB Initialize
' Initialize global variables
    cpmanum% = 0
    cpmaspace% = diskasize%
    cpmbnum% = 0
    cpmbspace% = diskbsize%
    cpmcolor = GREEN
    cpmdisk$ = "A"
    cpmramsize% = 20
    gameeventtotal% = 0
    gameloaded = TRUE
    modemcolor = FALSE
    modemtextcolor = OLIVE
    modemslowbaud = TRUE

    ERASE cpmafiles%, cpmbfiles%, gameevents%

    FOR I% = 1 TO 11    ' Initialize A: drive files
        CALL FileAdd("A", I%)
    NEXT I%
END SUB

SUB LinefeedDelay
' Delay the local terminal for a linefeed
    FOR k = 1 TO tickspeed% * 25
    NEXT k
END SUB

SUB Lineout (start%, numlines%, modem)
' Perform a terminal lineout of the requested text lines
    sounds$ = "T255MSMFO4L64A-"
    IF modemslowbaud THEN sounds$ = "T255MSMFO5L64EO4A-P64"

    FOR I = start% TO start% + numlines% - 1
        IF modemcolor THEN
            IF linedata(I).fgcolor = DEFAULT THEN
                COLOR modemtextcolor, BLACK
            ELSE
                COLOR linedata(I).fgcolor, linedata(I).bgcolor
            END IF
        END IF

        IF modem THEN
            FOR j = 1 TO LEN(lines(I))
                char$ = MID$(lines(I), j, 1)
                PRINT char$;
                IF char$ <> " " THEN PLAY sounds$
                RemoteDelay (1)
            NEXT j
            CALL LinefeedDelay
        ELSE
            IF linedata(I).linefeed THEN CALL LinefeedDelay
            PRINT lines(I);
            IF linedata(I).linefeed THEN CALL LinefeedDelay
        END IF
        IF linedata(I).linefeed THEN PRINT
    NEXT I
END SUB

SUB LineoutDelay (ticks%)
' Delay the local terminal for number of ticks
    iter& = tickspeed% * ticks% * 100
    FOR k = 1 TO iter&
    NEXT k
END SUB

SUB LineoutDemo (start%, numlines%)
' Perform a lineout from the demo text
    CALL Lineout(demooffset + start%, numlines%, demoremote)
END SUB

SUB RemoteDelay (ticks%)
' Pause the remote terminal for x ticks
    iter% = tickspeed% * ticks%
    IF modemslowbaud THEN iter% = iter% * 5
    FOR k = 1 TO iter%
    NEXT k
END SUB

SUB SetDisk (newdisk$)
' Set the CP/M disk drive to specified disk
    IF cpmdisk$ <> newdisk$ THEN
        Disk (1)
        LineoutDelay (5)
    END IF
    cpmdisk$ = newdisk$
END SUB

