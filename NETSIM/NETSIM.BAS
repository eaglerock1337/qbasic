DECLARE SUB CPMCommandB (cmd$)
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
DECLARE SUB CPMCommandA (cmd$)                  ' Process a command from the A: Drive
DECLARE SUB CPMCommandA (cmd$)                  ' Process a command from the B: Drive
DECLARE SUB CPMDir ()                           ' Print the DIR command to the CP/M terminal
DECLARE SUB CPMDirOut (filenum%, filedata%())   ' Helper routine for printing DIR command
DECLARE SUB CPMOutput (start%, numlines%)       ' Perform a lineout from CP/M
DECLARE SUB CPMStat ()                          ' Print the STAT command to the CP/M terminal
DECLARE SUB Delay (ticks%)                      ' Delay by a set number of ticks
DECLARE SUB Disk (seconds%)                     ' Simulate disk access sounds for number of seconds
DECLARE SUB DiskPause (ticks%)                  ' Play a sound pause for a number of ticks (from 2^0 to 2^4)
DECLARE SUB DiskSeek (ticks%)                   ' Get a disk access sound for a number of ticks (from 2^0 to 2^4)
DECLARE SUB EventTask (number%)                 ' Process any event tasks by its number in the event list
DECLARE SUB EventLoad ()                        ' Process all the previous game events for loading a saved game
DECLARE SUB EventScore (number%)                ' Process a game event, update your score, and display event text
DECLARE SUB LineDelay ()                        ' Delay the local terminal for a linefeed
DECLARE SUB Lineout (start%, numlines%, modem)  ' Perform a lineout of the requested text lines
DECLARE SUB LineoutDemo (start%, numlines%)     ' Perform a lineout from the demo text
DECLARE SUB Pause (ticks%)                      ' Pause the remote terminal for x ticks
DECLARE SUB SetDisk (newdisk$)                  ' Set the CP/M disk drive to specified disk

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

' For selecting the default color
CONST DEFAULT = -1

' Global variables
DIM SHARED cpmanum%             ' Number of files on A: drive
DIM SHARED cpmafiles%(16)       ' The list of files on the A: drive
DIM SHARED cpmbnum%             ' Number of files on B: drive
DIM SHARED cpmbfiles%(40)       ' The list of files on the B: drive
DIM SHARED cpmcolor             ' The default terminal color used by CP/M
DIM SHARED cpmdisk$             ' Current CP/M Disk Drive
DIM SHARED cpmramsize%          ' The size of of the CP/M system
DIM SHARED cpmspace%            ' Available B: drive space in KB
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

Loaddata:       ' Load all game data from .DAT and .TXT files

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
FOR i = 1 TO cpmlines
    INPUT #1, linedata(i).fgcolor, linedata(i).bgcolor, linedata(i).linefeed, lines(i)
NEXT i
FOR i = 1 TO demolines
    INPUT #2, linedata(i).fgcolor, linedata(i).bgcolor, linedata(i).linefeed, lines(i)
NEXT i

' Close game text files
CLOSE #1, #2

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

' Indicate a game isn't loaded yet
gameloaded = FALSE

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

'-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-'

Menu:           ' Main game menu

' Temporary Menu (to be moved to a proper subroutine)
CLS
COLOR OLIVE, BLACK
PRINT : PRINT : PRINT
PRINT "1 - New Game"
PRINT "2 - Back to CP/M"
PRINT "3 - Quit"
LINE INPUT "Select: ", menuselect$

SELECT CASE menuselect$
    CASE "1"
        GOTO Initialize
    CASE "2"
        IF gameloaded THEN GOTO CPM
    CASE "3"
        END
END SELECT

GOTO Menu

'-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-'

Initialize:     ' Initializes all variables for a new game and boot CP/M

' Initialize global variables
cpmanum% = 11
cpmbnum% = 0
cpmcolor = GREEN
cpmdisk$ = "A"
cpmramsize% = 20
cpmspace% = disksize%
gameeventtotal% = 0
gameloaded = TRUE
modemcolor = FALSE
modemtextcolor = OLIVE
modemslowbaud = TRUE

ERASE cpmafiles%, cpmbfiles%, gameevents%

FOR i = 1 TO cpmanum%   ' Initialize A: drive files
    cpmafiles%(i) = i
NEXT i

' CP/M Boot Routine
CALL CPMBoot

'-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-'

CPM:            ' CP/M Disk Prompt

COLOR cpmcolor, BLACK
PRINT cpmdisk$;
LINE INPUT ">", cmd$

' Return to menu or process command
IF cmd$ = "QUIT" THEN GOTO menu
CALL CPMCommand(cmd$)

GOTO CPM

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

'-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-'

XPLOD:          ' The X-Series Probe Launcer and Orbiting Director, Version 3.
' IBM calls it the X-PLOD-3. That's totally not telling.

'-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-'

SUB CPMBoot
' CP/M Boot Routine
    CLS
    COLOR cpmcolor, BLACK
    Disk (4)
    CALL CPMOutput(1, 3)          ' TODO: change to new lineout
    Delay (4)
    PRINT
    Disk (2)
    Delay (4)
END SUB

SUB CPMCommand (cmd$)
' Process a command from the CPM command prompt
    SELECT CASE cmd$    ' Process builtin commands
        CASE "DIR"          ' Provides a directory listing for active drive
            CALL CPMDir

        ' ********** DEBUG COMMANDS **********

        ' Debug commands for DIR command
        CASE "FILES"
            cpmbnum% = 5
            FOR i = 1 TO 5
                cpmbfiles%(i) = i + 12
            NEXT i

        ' Debug commands for terminal color
        CASE "GREEN"
            cpmcolor = GREEN

        CASE "AMBER"
            cpmcolor = OLIVE

        ' Debug commands for Lineout subroutine demos
        CASE "SATURN"
            CALL Lineoutdemo(42, 33)

        CASE "TEST"
            CALL Lineoutdemo(1, demolines)

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

        ' Debug the Delay() tickrate
        CASE "DELAY"
            Delay (32)

        ' ********** DEBUG COMMANDS **********

        CASE ""
            Delay (4)

        CASE ELSE
            ' Prepare for running commands by disk
            cmddisk$ = cpmdisk$

            ' Handle drive prefixes (e.g. A:STAT, B:TERM)
            IF LEN(cmd$) >= 2 AND MID$(cmd$, 2, 1) = ":" THEN
                cmddisk$ = MID$(cmd$, 1, 1)

                ' Invalid drive select handling
                IF cmddisk$ <> "A" AND cmddisk$ <> "B" THEN
                    cpmdisk$ = "A"
                    PRINT "Bdos Err On " + cmddisk$;
                    LINE INPUT ": Select", newdisk$
                    IF newdisk$ = "B" THEN cpmdisk$ = "B"
                    EXIT SUB
                END IF

                ' Change active drive
                IF LEN(cmd$) = 2 THEN
                    SetDisk (cmddisk$)
                    EXIT SUB
                END IF

                ' Prepare command variables for disk processing
                cmddisk$ = MID$(cmd$, 1, 1)
                cmd$ = MID$(cpm$, 3)
            END IF

            ' Process commands from disk
            IF cmddisk$ = "A" THEN
                CPMCommandA (cmd$)
            ELSE
                CPMCommandB (cmd$)
            END IF

    END SELECT
END SUB

SUB CPMCommandA (cmd$)
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
            PRINT cmd$ + "?"
            Delay (4)

    END SELECT
END SUB

SUB CPMCommandB (cmd$)
' Process a command from the B: Drive
    SELECT CASE cmd$
        CASE "COLOR"        ' COLOR.COM - Color 
            IF modemcolor THEN
                modemcolor = FALSE
            ELSE
                modemcolor = TRUE
            END IF

        CASE ELSE
            PRINT cmd$ + "?"
            Delay (4)

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
        Delay (3): PRINT "No file"
    ELSE
        rows% = 0: file% = 0
        header$ = cpmdisk$ + ": "
        spacer$ = " : "
        Disk (1)
        WHILE file% < filenum%
            Delay (1): PRINT header$; : Delay (1)
            count% = filenum% - file%
            IF count% > 4 THEN count% = 4
            FOR i% = 1 TO count%
                IF i% <> 1 THEN PRINT spacer$;
                target = filedata%(file% + 1)
                PRINT gamefiles(target).displayname;
                Delay (3)
                file% = file% + 1
            NEXT i%
            PRINT : rows% = rows% + 1
        WEND
    END IF
END SUB

SUB CPMOutput (start%, numlines%)      
' Perform CP/M text output
    FOR i = cpmoffset + start% TO cpmoffset + start% + numlines% - 1
        IF linedata(i).fgcolor = DEFAULT THEN
            COLOR cpmcolor, BLACK
        ELSE
            COLOR linedata(i).fgcolor, linedata(i).bgcolor
        END IF

        IF linedata(i).linefeed THEN CALL LineDelay
        PRINT lines(i);
        IF linedata(i).linefeed THEN
            CALL LineDelay
            PRINT
        END IF
    NEXT i
END SUB

SUB CPMStat
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

SUB Delay (ticks%)
' Delay the local terminal for number of ticks
    iter& = tickspeed% * ticks% * 100
    FOR k = 1 TO iter&
    NEXT k
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
        ' Pause before/between disk operations
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
                FOR i = 1 TO 2
                    DiskSeek (2)
                    DiskPause (16)
                NEXT i
                ticks% = ticks% - 36

            CASE IS < 95    ' Three quick seeks
                FOR i = 1 TO 3
                    DiskSeek (2)
                    DiskPause (16)
                NEXT i
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
    Delay (seconds%)
END SUB

SUB DiskPause (ticks%)
' Play a sound pause for a number of ticks (from 2^0 to 2^4)
    PLAY "T255P" + STR$(INT(tickrate% / ticks%))
END SUB

SUB DiskSeek (ticks%)
' Get a disk seek sound for a number of ticks (from 2^0 to 2^4)
    PLAY "T255MLMFO1L" + STR$(INT(tickrate% / ticks%)) + "A"
END SUB

SUB EventTask (number%)
' Process any event tasks by its number in the event list
    ' Look up the event in the list
    ' Process each individual instructions (editing data, outputs, etc.)
END SUB

SUB EventLoad
' Process all the previous game events for loading a saved game
    ' For each item in the list, call GameEvent
    ' Updates all the stuff without 
END SUB

SUB EventScore (number%)
' Process a game event, update your score, and display event text
    CALL EventTask (number%)
    ' Update score from event list
    ' Display text from the event text (optional)
    gameeventtotal% = gameeventtotal% + 1
    gameevents%(gameeventtotal%) = number%
END SUB

SUB LineDelay
' Delay the local terminal for a linefeed
    FOR k = 1 TO tickspeed% * 25
    NEXT k
END SUB

SUB Lineout (start%, numlines%, modem)
' Perform a terminal lineout of the requested text lines
    sounds$ = "T255MSMFO4L64A-"
    IF modemslowbaud THEN sounds$ = "T255MSMFO5L64EO4A-P64"

    FOR i = start% TO start% + numlines% - 1
        IF modemcolor THEN 
            IF linedata(i).fgcolor = DEFAULT THEN 
                COLOR modemtextcolor, BLACK
            ELSE
                COLOR linedata(i).fgcolor, linedata(i).bgcolor
            END IF
        END IF

        IF modem THEN
            FOR j = 1 TO LEN(lines(i))
                char$ = MID$(lines(i), j, 1)
                PRINT char$;
                IF char$ <> " " THEN PLAY sounds$
                Pause (1)
            NEXT j
            CALL LineDelay
        ELSE
            IF linedata(i).linefeed THEN CALL LineDelay
            PRINT lines(i);
            IF linedata(i).linefeed THEN CALL LineDelay
        END IF
        IF linedata(i).linefeed THEN PRINT
    NEXT i
END SUB

SUB LineoutDemo (start%, numlines%)
' Perform a lineout from the demo text
    CALL Lineout(demooffset + start%, numlines%, demoremote)
END SUB

SUB Pause (ticks%)
' Pause the remote terminal for x ticks
    iter% = tickspeed% * ticks%
    IF modemslowbaud THEN iter% = iter% * 5
    FOR k = 1 TO iter%
    NEXT k
END SUB

SUB SetDisk (newdisk$)
' Set the CP/M disk drive to specified disk
    IF cpmdisk$ <> newdisk$ THEN
        Disk (2)
        Delay (25)
    END IF
    cpmdisk$ = newdisk$
END SUB

