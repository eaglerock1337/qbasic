'MarioMeter 2.0
'User Friendly Version
'by Peter Marks
'This program rates your power-ups in Super Mario World.
'NOTE TO READERS: This program has notes all over this program to help you
'understand the program better.  To use the notations, simply read them as
'you go along the program.  Knowledge of the Super Mario World game is
'ESSENTIAL.  However, some BASIC knowledge is helpful, but not necessary.
'-----------------------------------------------------------
'-----------------------------------------------------------
'----------TO START THIS PROGRAM, PRESS SHIFT + F5----------
'-----------------------------------------------------------
'-----------------------------------------------------------
CLS
PRINT "Welcome.  This will rate your power-ups in Super Mario World."
Continue = 1
        'NOTE: "Continue" is what controls if the user wants to rerun this
        '      program if they lose the game.
DO WHILE Continue = 1
        'NOTE: This is the loop that jumps back to the beggining of the
        '      program if the user selected to continue the program after
        '      they lost.
 CLS
 PRINT
        'NOTE: This is telling the user about the scoring rating system.
 PRINT "The Scoring is as follows:"
 PRINT "                         Any Mario-        1 point"
 PRINT "                         Mushroom-         2 points"
 PRINT "                         Fire Flower-      3 points"
 PRINT "                         Cape Feather-     5 points"
 PRINT "                         Green Yoshi-     11 points"
 PRINT "                         Yellow Yoshi-    12 points"
 PRINT "                         Red Yoshi-       13 points"
 PRINT "                         Blue Yoshi-      14 points"
 PRINT
        'NOTE: The following 2 lines inputs special info for the user if he
        '      chose continue. (For more info on the inputted info, see the
        '      following notation.)
 IF Reinput = 1 THEN
  Start = 2
 ELSE
  PRINT "Have you started the game yet? (Yes = 1, No = 2)"
  INPUT Start
        'NOTE: "Start" and this INPUT statment give the user the privelege
        '      to not have to input the following information if they are
        '      just starting out in the game.  Since when you start you have
        '      certain things, it is easy to input the info for them.
 END IF
 IF Start = 2 THEN
        'NOTE: The following variables (Mario, Reserve, etc.) are now being
        '      inputted the certain info at the start of the game.  Later in
        '      the program is when the user can input the numbers for himself.
  Mario = 1
  Reserve = 1
  Yoshi = 1
  Points = 1
  Lives = 5
  Coins = 0
  PRINT
  PRINT "To start the on-hand guide, press the space bar..."
        'NOTE: This is the starting point of when the user inputs the info
        '      manually.
 ELSE PRINT "Then let's start.  If you are regular Mario, type 1. "
  PRINT "                   If you are Super Mario, type 2."
  PRINT "                   If you are Fire Mario, type 3."
  PRINT "                   If you are Cape Mario, type 4."
  INPUT Mario
        'NOTE: "Mario" controls the number inputted by the user to be used
        '      for various things explained later.  The above PRINT
        '      statements assign a letter to each power up level of Mario.
        '      Below, "MarPoints" is assigned a number based on the rating
        '      system.  Each level of Mario's power up's has a different
        '      number rating.
  IF Mario = 1 THEN MarPoints = 1
  IF Mario = 2 THEN MarPoints = 3
  IF Mario = 3 THEN MarPoints = 4
  IF Mario = 4 THEN MarPoints = 6
  Points = MarPoints
        'NOTE: "Points" is the total score of the person's rating.  The
        '      points achieved by the status of Mario were just added to it.
  CLS
  PRINT
  PRINT
  PRINT "Your total at this point is"; Points; "points."
        'NOTE: This is just displaying the current pointage.
  PRINT
  PRINT "Now, we will concern ourselves with your reserve power up."
  PRINT "If you have in your reserve: Nothing, type 1."
  PRINT "                             A Power-up Mushroom, type 2."
  PRINT "                             A Fire Flower, type 3."
  PRINT "                             A Cape Feather, type 4."
  INPUT Reserve
        'NOTE: This is the same thing as what was done with "Mario" and
        '      "MarPoints", except this is calculating the points achieved
        '      by the reserve power-up (if any).  Keep the words "Reserve",
        '      "ReserPoints", and the like in mind, just like "Mario" and
        '      "MarPoints".  It will come in handy to understanding the
        '      program.
  IF Reserve = 2 THEN ReserPoints = 2
  IF Reserve = 3 THEN ReserPoints = 3
  IF Reserve = 4 THEN ReserPoints = 5
  Points = Points + ReserPoints
        'NOTE: This is now adding the points from the reserve to the total
        '      score.
  CLS
  PRINT
  PRINT
  PRINT "Your total now is"; Points; "points."
        'NOTE: Displaying the current pointage again.
  PRINT
  PRINT "Now, we will talliate your Yoshi Points."
  PRINT "If you have no Yoshi, type 1."
  PRINT "If your Yoshi Color is: Green, type 2."
  PRINT "                        Yellow, type 3."
  PRINT "                        Red, type 4."
  PRINT "                        Blue, type 5."
  INPUT Yoshi
        'NOTE: Doing to "Yoshi" and "YosPoints" what we did before.
  IF Yoshi = 2 THEN YosPoints = 11
  IF Yoshi = 3 THEN YosPoints = 12
  IF Yoshi = 4 THEN YosPoints = 13
  IF Yoshi = 5 THEN YosPoints = 14
  Points = Points + YosPoints
        'NOTE: Adding it up again.
  CLS
  PRINT
  PRINT "Now input the number of lives you have."
  INPUT Lives
  PRINT
  PRINT "Lastly, input the number of coins you have."
  INPUT Coins
        'NOTE: This is just getting info on the side to help keep track of
        '      the game better and reduce user input.
  CLS
  PRINT "Your total is"; Points; "points."
  PRINT
  PRINT "This will now be your on-hand guide while playing the game."
  PRINT "When an event listed happens to you, type the assigned number"
  PRINT "and answer any questions asked of you."
  PRINT "You will then get an immediate update on your status and rank."
  PRINT
  PRINT "So, when you are ready, press the space bar...."
 END IF
 SLEEP
        'NOTE: Coming up is the main loop that is what you see in this
        '      program the most.  It gives instantaneous updating on the
        '      screen and displays all of the possible things that could
        '      happen in this game.  It also accounts for little things
        '      that could make the program obsolete (e.g. It accounts for
        '      not using a Yoshi if you fall into a pit on a board that
        '      doesn't let you use a Yoshi.)
 DO UNTIL Choice = 8 OR Lives <= 0
        'NOTE: This line is what breaks the user out of the loop if the user
        '      chooses to quit or he runs out of lives.
  CLS
        'NOTE: The following are declaring new variables assigned for each
        '      type of rating.  This is done so the old variables don't mess
        '      up the program.
  IF Mario = 1 THEN MarioPoints = 1
  IF Mario = 2 THEN MarioPoints = 3
  IF Mario = 3 THEN MarioPoints = 4
  IF Mario = 4 THEN MarioPoints = 6
  IF Reserve = 1 THEN ReservePoints = 0
  IF Reserve = 2 THEN ReservePoints = 2
  IF Reserve = 3 THEN ReservePoints = 3
  IF Reserve = 4 THEN ReservePoints = 5
  IF Yoshi = 1 THEN YoshiPoints = 0
  IF Yoshi = 2 THEN YoshiPoints = 11
  IF Yoshi = 3 THEN YoshiPoints = 12
  IF Yoshi = 4 THEN YoshiPoints = 13
  IF Yoshi = 5 THEN YoshiPoints = 14
  Points = MarioPoints + ReservePoints + YoshiPoints
  PRINT
  PRINT
  PRINT "Remember, just type '8' to stop."
  PRINT "Also, if you gain a coin, simply press return by itself."
  PRINT
  PRINT "You have"; Lives; "lives."
        'NOTE: Each group is declaring a new variable (the ones with the "$"
        '      at the end).  These new variables allow text to be inserted.
        '      It is then used to display the status of the person very
        '      straight-fowardly.
  IF Mario = 1 THEN Mario$ = "Regular"
  IF Mario = 2 THEN Mario$ = "Super"
  IF Mario = 3 THEN Mario$ = "Fire"
  IF Mario = 4 THEN Mario$ = "Cape"
  PRINT "You are "; Mario$; " Mario."
        'NOTE: Printing out the results of the input (PRINT statement above).
  IF Reserve = 1 THEN Reserve$ = "nothing"
  IF Reserve = 2 THEN Reserve$ = "a Power-up Mushroom"
  IF Reserve = 3 THEN Reserve$ = "a Fire Flower"
  IF Reserve = 4 THEN Reserve$ = "a Cape Feather"
  PRINT "You have "; Reserve$; " in your reserve."
  IF Yoshi = 1 THEN Yoshi$ = "no"
  IF Yoshi = 2 THEN Yoshi$ = "a Green"
  IF Yoshi = 3 THEN Yoshi$ = "a Yellow"
  IF Yoshi = 4 THEN Yoshi$ = "a Red"
  IF Yoshi = 5 THEN Yoshi$ = "a Blue"
  PRINT "You have "; Yoshi$; " Yoshi."
  PRINT "You have"; Coins; "coins."
  PRINT "Your total is"; Points; "points."
  PRINT
        'NOTE: Now displaying the choices below.     
  PRINT "Make a choice from the list of events below."
  PRINT
  PRINT "1. You gained a power up."
  PRINT "2. You got hit by an enemy or an obstacle."
  PRINT "3. You gained a Yoshi."
  PRINT "4. You fell into a pit."
  PRINT "5. You selected your reserve power-up."
  PRINT "6. You earned a 1-up."
  PRINT "7. You earned more than one 1-up."
  PRINT
        'NOTE: Now inputting the main variable below.  This is the variable
        '      that is used to choose the event that happened (the list is
        '      above).
  INPUT "Choice"; Choice
  IF Choice = 1 THEN
   CLS
   PRINT
   PRINT
   PRINT "What power up did you recieve?"
   PRINT "    1. Mushroom"
   PRINT "    2. Fire Flower"
   PRINT "    3. Cape Feather"
        'NOTE: Inputting the powerup recieved.
   INPUT Powerup
   IF Powerup <> 1 THEN
        'NOTE: The next two lines do the following:
        '      -take the power up currently being used and put it in the
        '       reserve
        '      -put the achieved power-up into active use.
        '      However, if the person was currently Cape or Fire Mario and
        '      achieved a power-up mushroom, then these twp lines are
        '      disregarded and put the two IF's under the END IF into use.
        '      They put the mushroom in the reserve.
    Reserve = Mario
    Mario = Powerup + 1
   END IF
   IF Powerup = 1 AND Mario <> 1 THEN Reserve = Powerup + 1
   IF Powerup = 1 AND Mario = 1 THEN Mario = Powerup + 1
  END IF
  IF Choice = 2 THEN
   CLS
   PRINT
   PRINT
        'NOTE: "Board2" is a variable used to check if a person has a Yoshi.
        '      This is done since if the user has a Yoshi, the program would
        '      need to know if he was on a board that used the Yoshi.  This
        '      is just another thing to limit user input.
   IF Yoshi = 1 THEN Board2 = 1
   IF Yoshi <> 1 THEN
    PRINT "Are you playing a board that doesn't let you use your Yoshi? (Yes = 1, No = 2)"
    INPUT Board2
   END IF
        'NOTE: The following 15 lines change the the number of lives and the
        '      active power up if the user didn't have a Yoshi.
   IF Board2 = 1 THEN
    IF Mario = 1 AND Reserve = 1 THEN Lives = Lives - 1
    IF Mario = 1 AND Reserve <> 1 THEN Lives = Lives - 1
    IF Reserve <> 1 AND Mario <> 1 THEN
        'NOTE: The next 2 lines check if the user retrieved the reserve after 
        '      he was hit.
     PRINT "You had "; Reserve$; " in your reserve.  Did you retrieve it after"
     PRINT "you were hit? (Yes = 1, No = 2)"
     INPUT Hit
      IF Hit = 1 THEN
       Mario = Reserve
       Reserve = 1
      END IF
      IF Hit = 2 THEN
       Mario = 1
       Reserve = 1
      END IF
    END IF
        'NOTE: The next four lines check the hit if the person had a Yoshi.
        '      It also checks if the person retrieved the Yoshi.
   ELSEIF Yoshi <> 1 THEN
    PRINT "Did you get back your Yoshi? (Yes = 1, No = 2)"
    INPUT Yoshihit
    IF Yoshihit = 2 THEN Yoshi = 1
        'NOTE: Checking the non-Yoshi hit again below.  This is neccesary to
        '      check since there are boards where the user can't use a Yoshi,
        '      even if he has one.
    ELSEIF Yoshi = 1 THEN
     IF Mario = 1 AND Reserve = 1 THEN Lives = Lives - 1
     IF Mario = 1 AND Reserve <> 1 THEN Lives = Lives - 1
     IF Reserve <> 1 AND Mario <> 1 THEN
      PRINT "You had "; Reserve$; " in your reserve.  Did you retrieve it after"
      PRINT "you were hit? (Yes = 1, No = 2)"
      INPUT Hit
      IF Hit = 1 THEN
       Mario = Reserve
       Reserve = 1
      END IF
      IF Hit = 2 THEN
       Mario = 1
       Reserve = 1
      END IF
     END IF
   END IF
  END IF
  IF Choice = 3 THEN
   CLS
        'NOTE: The next line is to stop the process of inputting the kind of
        '      Yoshi just achieved if he already has one.  Below it is the
        '      declaration of the variables neccesary to display the progress.
   IF Yoshi = 1 THEN
    PRINT
    PRINT
    PRINT "What color Yoshi did you recieve?"
    PRINT "    1. Green"
    PRINT "    2. Yellow"
    PRINT "    3. Red"
    PRINT "    4. Blue"
    INPUT GetYoshi
    IF GetYoshi = 1 THEN Yoshi = 2
    IF GetYoshi = 2 THEN Yoshi = 3
    IF GetYoshi = 3 THEN Yoshi = 4
    IF GetYoshi = 4 THEN Yoshi = 5
   END IF
  END IF
  IF Choice = 4 THEN
   CLS
   PRINT
   PRINT
        'NOTE: "Board4" is the same type of variable as "Board2."  It checks
        '      if the person had a Yoshi to see wether or not to ask if he
        '      retrieved it.
   IF Yoshi = 1 THEN Board4 = 1
   IF Yoshi <> 1 THEN
        'NOTE: Checking the retrieval of Yoshi. 
    PRINT "Are you playing a board that doesn't let you use your Yoshi? (Yes = 1, No = 2)"
    INPUT Board4
   END IF
   IF Board4 <> 1 THEN Yoshi = 1
   Lives = Lives - 1
   Mario = 1
  END IF
  IF Choice = 5 AND Reserve <> 1 THEN
        'NOTE: This the switching of the active and current power-ups. The
        '      switching of a Fire or Cape for a Mushroom is considered.
        '      "Booster" is only a variable used to help switch the powerups.
   Booster = Mario
   Mario = Reserve
   Reserve = Booster
  END IF
        'NOTE: Adding one life.
  IF Choice = 6 THEN Lives = Lives + 1
        'NOTE: Adding more than one life (inputting the number from the user).
  IF Choice = 7 THEN
   CLS
   PRINT
   PRINT
   PRINT "How many 1-ups did you earn?"
   INPUT Oneup
   Lives = Lives + Oneup
  END IF
        'NOTE: This next "IF" allows the user to simply press enter to
        '      add one coin to the total (when no number is inputted, it
        '      defaults to 0).
  IF Choice = 0 THEN Coins = Coins + 1
        'NOTE: The "IF" below rounds off the number of lives to 99 if over.
  IF Lives > 99 THEN Lives = 99
        'NOTE: The next "IF" turns 100 coins into a one-up and rounds it back.
  IF Coins > 99 THEN
   Lives = Lives + 1
   Coins = 0
  END IF
        'NOTE: The end of the main loop.
 LOOP
 CLS
        'NOTE: The following lines are what you see at the end of one game.
        '      The next five lines add a comment if the user ran out of lives.
 IF Lives = 0 THEN
  PRINT
  PRINT
  PRINT "Ouch!  You ran out of lives!  Well, I hope you saved your game!"
 END IF
        'NOTE: Now, the status of the person is displayed as was at the end
        '      of the game.  Note we are back to the original variables used
        '      to total the variables.
 PRINT
 PRINT
 PRINT "Well, I hope this helped you.  Your status was as follows:"
 IF Mario = 1 THEN MarPoints = 1
 IF Mario = 2 THEN MarPoints = 3
 IF Mario = 3 THEN MarPoints = 4
 IF Mario = 4 THEN MarPoints = 6
 IF Reserve = 1 THEN ReserPoints = 0
 IF Reserve = 2 THEN ReserPoints = 2
 IF Reserve = 3 THEN ReserPoints = 3
 IF Reserve = 4 THEN ReserPoints = 5
 IF Yoshi = 1 THEN YosPoints = 0
 IF Yoshi = 2 THEN YosPoints = 11
 IF Yoshi = 3 THEN YosPoints = 12
 IF Yoshi = 4 THEN YosPoints = 13
 IF Yoshi = 5 THEN YosPoints = 14
 Points = MarPoints + ReserPoints + YoshiPoints
 PRINT "You had"; Lives; "lives."
 IF Mario = 1 THEN Mario$ = "Regular"
 IF Mario = 2 THEN Mario$ = "Super"
 IF Mario = 3 THEN Mario$ = "Fire"
 IF Mario = 4 THEN Mario$ = "Cape"
 PRINT "You were "; Mario$; " Mario."
 IF Reserve = 1 THEN Reserve$ = "nothing"
 IF Reserve = 2 THEN Reserve$ = "a Power-up Mushroom"
 IF Reserve = 3 THEN Reserve$ = "a Fire Flower"
 IF Reserve = 4 THEN Reserve$ = "a Cape Feather"
 PRINT "You had "; Reserve$; " in your reserve."
 IF Yoshi = 1 THEN Yoshi$ = "no"
 IF Yoshi = 2 THEN Yoshi$ = "a Green"
 IF Yoshi = 3 THEN Yoshi$ = "a Yellow"
 IF Yoshi = 4 THEN Yoshi$ = "a Red"
 IF Yoshi = 5 THEN Yoshi$ = "a Blue"
 PRINT "You had "; Yoshi$; " Yoshi."
 PRINT "Your total was"; Points; "points."
 PRINT
        'NOTE: The next 3 lines are what control the continue option, the last
        '      of the three giving the sign to automatically input the info.
 PRINT "Type in wether or not you are going to continue. (Yes = 1, No = 2)"
 INPUT Continue
 IF Continue = 1 THEN Reinput = 1
LOOP
        'NOTE: This is just an ending to show the end of the program.
CLS
PRINT
PRINT
PRINT
PRINT
PRINT
PRINT
PRINT "Bye!  Thank you for using Peter Marks' Super Mario World Power-up"
PRINT "on-hand guide.  Please use it again soon."
END
'FOOTNOTE TO READERS: This program was made to be used with Super Mario World.
'                     You are welcome to type up the program yourself or give
'                     it to friends.  When typing up the program, the lines
'                     with the apostrophe (') DO NOT need to be typed.  It is
'                     suggessted to write something at the top to remind you
'                     of what game it is.  Remember, you need an apostrophe
'                     (') before ANY comment.  Also, when using it, it is
'                     easier to use by having a friend type while you play and
'                     switch afterwards.  Good luck and have fun!

