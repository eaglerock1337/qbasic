'The Internet Simulator by Peter Marks
'This Net program will give a good heaping helping of fun!

CLS
PRINT "Hello! Welcome to the net program.  Remember that this program is not a real netexperience."
SLEEP 4
PRINT
PRINT "These are VITAL codes.  remember them."
SLEEP 2
PRINT "Startup code - 8917160 "
SLEEP 3
PRINT "Access to top secret level security - 7201982"
SLEEP 4
PRINT "Access to the EBS system - 8488190"
SLEEP 4
PRINT "ARE YOU WRITING THESE DOWN???"
SLEEP 2
PRINT "Access to the HES system - 7920671"
SLEEP 4
PRINT "GOT THAT?????  ";
SLEEP 2
PRINT "Good."
SLEEP 4
PRINT "Okay... Lets get started!"
SLEEP 6
CLS
PRINT "Welcome to the internet establishment system 4.1...."
SLEEP 2
PRINT
PRINT "Please wait...."
SLEEP 4
PRINT
PRINT
PRINT
PRINT
PRINT "Finding hookup";
SLEEP 1
PRINT ".";
SLEEP 1
PRINT ".";
SLEEP 1
PRINT "."
CLS
SLEEP 4
PRINT
PRINT
PRINT "-Welcome to the Internet! You are at the NASA entry gate.-"
SLEEP 3
PRINT
PRINT
PRINT
PRINT
5 INPUT "DO YOU WISH TO ENTER SECURITY BOARD??? (yes = 1, no = 2)"; X
SLEEP 2
IF X = 2 = true THEN
        GOTO 20
END IF
IF X = 1 = true THEN
        GOTO 10
ELSE PRINT "Please type 1 or 2.": GOTO 5
END IF
10 PRINT : PRINT "ARE YOU SURE????": GOTO 5
20 PRINT : SLEEP 2: PRINT "Please wait..."
SLEEP 3
CLS
SLEEP 1
PRINT
PRINT
PRINT
PRINT
PRINT "Establishing Modem..."
SLEEP 3
PRINT
PRINT
PRINT "Finding Address..."
SLEEP 2
PRINT
PRINT
PRINT "Connection ready....."
CLS
PRINT
PRINT
PRINT
PRINT
COLOR 17, 5
25 PRINT "PASSWORD NEEDED TO PROCEED..."
COLOR 7, 0
PRINT
INPUT "Please enter startup code here ----->  "; y: PRINT
IF y = 8917160 THEN
        GOTO 30
ELSE GOTO 40
END IF
40 PRINT "INCORRECT PASSWORD": SLEEP 2: GOTO 25
30 PRINT "PASSWORD ACCEPTED!!!!!": SLEEP 2: PRINT "Please wait..."
PRINT
PRINT
PRINT "Booting up security system.";
SLEEP 1
PRINT ".";
SLEEP 1
PRINT ".";
SLEEP 1
PRINT ".";
SLEEP 1
PRINT ".";
SLEEP 1
PRINT ".";
SLEEP 1
PRINT "."
SLEEP 2
CLS
SLEEP 1
COLOR 17, 2
PRINT
PRINT
PRINT
PRINT
PRINT
PRINT
PRINT "WARNING!!!";
COLOR 12, 0
SLEEP 2
PRINT " HACKER PRESUMED PRESENT ON NET PROGRAM...."
SLEEP 3
PRINT "HACKER EXTERMINATION SYSYEM BOOTING UP..."
SLEEP 5
COLOR 7, 0
PRINT
PRINT
PRINT
PRINT "PASSWORD NOT REQUIRED FOR EXAMINATION..."
PRINT "NOTE: IF YOU WANT TO FOLLOW UP, CHOOSE THE HES SYSTEM IN THE TOP SECRET SECRITY MENU."
PRINT
PRINT
PRINT "Continuing to boot up program..."
SLEEP 4
CLS
SLEEP 2
60 PRINT
PRINT
PRINT "********************************************************************************"
PRINT "* WELCOME TO THE NASA LAUNCH PREPARATION SYSTEM!           GUEST LEVEL SECURITY*"
PRINT "********************************************************************************"
PRINT "* 1) GET INFO ON THE SPACE SHUTTLE LAUNCH   2) INPUT CODE FOR HIGHER ATHORITY  *"
PRINT "********************************************************************************"
PRINT
PRINT
55 INPUT "          Please enter number of your choice here ----->  "; Z
IF Z = 1 OR Z = 2 THEN
        GOTO 65
ELSE PRINT "Please type a valid number": GOTO 55
END IF
65 IF Z = 2 THEN
       GOTO 80
ELSE GOTO 70
END IF
70 SLEEP 3
CLS
SLEEP 1
PRINT
PRINT
PRINT "        This launch will take place in a few hours.  ";
SLEEP 2
PRINT "The journey will be for two months and will carry a crew of 8.  ";
SLEEP 2
PRINT "The ship will go to Mars to release another satellite in its orbit.  "
SLEEP 3
PRINT
PRINT "This will help our studies on life on Mars."
SLEEP 5: CLS : GOTO 60
80 SLEEP 1
PRINT "Please Wait..."
SLEEP 4
CLS
SLEEP 1
PRINT
PRINT
PRINT
PRINT
PRINT
INPUT "Please enter code..."; A
IF A = 7201982 THEN
        PRINT "ACCEPTED!!!  ": SLEEP 2: PRINT "Please wait as system is booted up...": GOTO 75
ELSE PRINT "INCORRECT PASSWORD": SLEEP 3: CLS : GOTO 60
END IF
75 SLEEP 6
F = 0
G = 0
85 CLS
SLEEP 2
86 CLS
PRINT
PRINT
PRINT "********************************************************************************"
PRINT "* WELCOME TO THE NASA LAUNCH PREPARATION SYSTEM!           TOP SECRET SECURITY *"
PRINT "********************************************************************************"
PRINT "* 1) CHECK SATELLITE                                                           *"
PRINT "* 2) CHECK SPACE SHUTTLE                                                       *"
PRINT "* 3) CHECK BOOSTER ROCKETS                                                     *"
PRINT "* 4) CHECK MAIN CONTROLS                                                       *"
PRINT "* 5) CHECK FUEL TANK                                                           *"
PRINT "* 6) ACTIVATE EBS SYSTEM                                                       *"
PRINT "* 7) ACTIVATE HES SYSTEM                                                       *"
PRINT "* 8) ACTIVATE LAUNCH PREPARATION...                                            *"
PRINT "* 9) RETURN TO GUEST LEVEL SECURITY                                            *"
PRINT "********************************************************************************"
PRINT
PRINT
SLEEP 1
PRINT "          Enter number of choice here -----> ";
INPUT B
IF B = 9 THEN
        CLS
        GOTO 60
END IF
IF B = 1 THEN
        CLS
        PRINT
        PRINT
        PRINT
        PRINT
        PRINT
        PRINT
        PRINT
        PRINT "Satellite in perfect working order."
        SLEEP 2
        GOTO 85
ELSE
        IF B = 2 THEN
                F = F + 1
                CLS
                PRINT
                PRINT
                PRINT
                PRINT
                PRINT
                PRINT
                PRINT
                PRINT "Space shuttle detector sees slight leak in the airlock system..."
                SLEEP 2
                PRINT
                PRINT "Leak being fixed..."
                SLEEP 3
                GOTO 85
        ELSE
                IF B = 3 THEN
                        CLS
                        PRINT
                        PRINT
                        PRINT
                        PRINT
                        PRINT
                        PRINT
                        PRINT
                        PRINT "Booster rockets are in perfect working order."
                        SLEEP 2
                        GOTO 85
                ELSE
                        IF B = 4 THEN
                                CLS
                                PRINT
                                PRINT
                                PRINT
                                PRINT
                                PRINT
                                PRINT
                                PRINT
                                PRINT "Main controls normal."
                                SLEEP 2
                                GOTO 85
                        ELSE
                                IF B = 5 THEN
                                        CLS
                                        G = G + 1
                                        PRINT
                                        PRINT
                                        PRINT
                                        PRINT
                                        PRINT
                                        PRINT
                                        PRINT
                                        PRINT "Fuel tank has a minor leak..."
                                        SLEEP 3
                                        PRINT "Leak is being maintenced..."
                                        SLEEP 2
                                        PRINT "Leak will be fixed by the time of the launch..."
                                        SLEEP 4
                                        GOTO 85
                                ELSE
                                        IF B = 6 THEN
                                                CLS
                                                PRINT
                                                PRINT
                                                PRINT
                                                PRINT
                                                PRINT
                                                PRINT
                                                PRINT
                                                PRINT "Note: The EBS (Emergency Backup System) is not needed at this point and is inaccessable."
                                                SLEEP 4
                                                GOTO 85
                                        ELSE
                                                IF B = 7 THEN
                                                        CLS
                                                        PRINT
                                                        PRINT
                                                        PRINT
                                                        PRINT
                                                        PRINT
                                                        PRINT
                                                        PRINT
                                                        PRINT "Note: The HES (Hacker Extermination System) is turned on at this point. The HES system is also not accessable at this time since passwords are not enterable at this point in the launch."
                                                        SLEEP 6
                                                        GOTO 85
                                                ELSE
                                                IF B = 8 THEN
                                                        CLS
                                                        SLEEP 3
                                                        PRINT
                                                        PRINT
                                                        PRINT
                                                        PRINT
                                                        PRINT "Launching sequence initiated..."
                                                        PRINT
                                                        PRINT
                                                        IF F <> 1 THEN
                                                                PRINT "AutoLaunch System detects leak in the airlock system..."
                                                                SLEEP 3
                                                                PRINT
                                                                PRINT "Leak being maintenced..."
                                                                PRINT
                                                                PRINT
                                                                SLEEP 6
                                                        END IF
                                                        IF G <> 1 THEN
                                                                PRINT "AutoLaunch System detects leak in the fuel tank..."
                                                                SLEEP 3
                                                                PRINT
                                                                PRINT "Leak being maintenced..."
                                                                SLEEP 6
                                                                SLEEP 2
                                                        END IF
                                                        PRINT "Please Wait..."
                                                        SLEEP 6
                                                        CLS
                                                ELSE PRINT "Invalid number..."
                                                GOTO 86
                                                END IF
                                        END IF
                                END IF
                        END IF
                END IF
        END IF
END IF
END IF

PRINT
PRINT
PRINT "System launch is being set up by the AutoLaunch system.  The system is now"
PRINT "finished detecting any leaks or problems with the "


