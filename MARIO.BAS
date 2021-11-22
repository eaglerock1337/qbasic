'MarioMeter 2.0
'by Peter Marks
' This program rates your power-ups in Super Mario World.
CLS
PRINT "Welcome.  This will rate your power-ups in Super Mario World."
Continue = 1
DO WHILE Continue = 1
 CLS
 PRINT
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
 IF Reinput = 1 THEN
  Start = 2
 ELSE
  PRINT "Have you started the game yet? (Yes = 1, No = 2)"
  INPUT Start
 END IF
 IF Start = 2 THEN
  Mario = 1
  Reserve = 1
  Yoshi = 1
  Points = 1
  Lives = 5
  Coins = 0
  PRINT
  PRINT "To start the on-hand guide, press the space bar..."
 ELSE PRINT "Then let's start.  If you are regular Mario, type 1. "
  PRINT "                   If you are Super Mario, type 2."
  PRINT "                   If you are Fire Mario, type 3."
  PRINT "                   If you are Cape Mario, type 4."
  INPUT Mario
  IF Mario = 1 THEN MarPoints = 1
  IF Mario = 2 THEN MarPoints = 3
  IF Mario = 3 THEN MarPoints = 4
  IF Mario = 4 THEN MarPoints = 6
  Points = MarPoints
  CLS
  PRINT
  PRINT
  PRINT "Your total at this point is"; Points; "points."
  PRINT
  PRINT "Now, we will concern ourselves with your reserve power up."
  PRINT "If you have in your reserve: Nothing, type 1."
  PRINT "                             A Power-up Mushroom, type 2."
  PRINT "                             A Fire Flower, type 3."
  PRINT "                             A Cape Feather, type 4."
  INPUT Reserve
  IF Reserve = 2 THEN ReserPoints = 2
  IF Reserve = 3 THEN ReserPoints = 3
  IF Reserve = 4 THEN ReserPoints = 5
  Points = Points + ReserPoints
  CLS
  PRINT
  PRINT
  PRINT "Your total now is"; Points; "points."
  PRINT
  PRINT "Now, we will talliate your Yoshi Points."
  PRINT "If you have no Yoshi, type 1."
  PRINT "If your Yoshi Color is: Green, type 2."
  PRINT "                        Yellow, type 3."
  PRINT "                        Red, type 4."
  PRINT "                        Blue, type 5."
  INPUT Yoshi
  IF Yoshi = 2 THEN YosPoints = 11
  IF Yoshi = 3 THEN YosPoints = 12
  IF Yoshi = 4 THEN YosPoints = 13
  IF Yoshi = 5 THEN YosPoints = 14
  CLS
  PRINT
  PRINT "Now input the number of lives you have."
  INPUT Lives
  PRINT
  PRINT "Lastly, input the number of coins you have."
  INPUT Coins
  Points = Points + YosPoints
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
 DO UNTIL Choice = 8 OR Lives <= 0
  CLS
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
  IF Mario = 1 THEN Mario$ = "Regular"
  IF Mario = 2 THEN Mario$ = "Super"
  IF Mario = 3 THEN Mario$ = "Fire"
  IF Mario = 4 THEN Mario$ = "Cape"
  PRINT "You are "; Mario$; " Mario."
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
  INPUT "Choice"; Choice
  IF Choice = 1 THEN
   CLS
   PRINT
   PRINT
   PRINT "What power up did you recieve?"
   PRINT "    1. Mushroom"
   PRINT "    2. Fire Flower"
   PRINT "    3. Cape Feather"
   INPUT Powerup
   IF Powerup <> 1 THEN
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
   IF Yoshi = 1 THEN Board2 = 1
   IF Yoshi <> 1 THEN
    PRINT "Are you playing a board that doesn't let you use your Yoshi? (Yes = 1, No = 2)"
    INPUT Board2
   END IF
   IF Board2 = 1 THEN
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
   ELSEIF Yoshi <> 1 THEN
    PRINT "Did you get back your Yoshi? (Yes = 1, No = 2)"
    INPUT Yoshihit
    IF Yoshihit = 2 THEN Yoshi = 1
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
   IF Yoshi = 1 THEN Board4 = 1
   IF Yoshi <> 1 THEN
    PRINT "Are you playing a board that doesn't let you use your Yoshi? (Yes = 1, No = 2)"
    INPUT Board4
   END IF
   IF Board4 <> 1 THEN Yoshi = 1
   Lives = Lives - 1
   Mario = 1
  END IF
  IF Choice = 5 AND Reserve <> 1 AND Mario - 1 < Reserve THEN
   Booster = Mario
   Mario = Reserve
   Reserve = Booster
  END IF
  IF Choice = 6 THEN Lives = Lives + 1
  IF Choice = 7 THEN
   CLS
   PRINT
   PRINT
   PRINT "How many 1-ups did you earn?"
   INPUT Oneup
   Lives = Lives + Oneup
  END IF
  IF Choice = 0 THEN Coins = Coins + 1
  IF Lives > 99 THEN Lives = 99
  IF Coins > 99 THEN
   Lives = Lives + 1
   Coins = 0
  END IF
 LOOP
 CLS
 IF Lives = 0 THEN
  PRINT
  PRINT
  PRINT "Ouch!  You ran out of lives!  I hope you saved your game!"
 END IF
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
 PRINT "You had"; Coins; "Coins."
 PRINT "Your total was"; Points; "points."
 PRINT
 PRINT "Type in wether or not you are going to continue. (Yes = 1, No = 2)"
 INPUT Continue
 IF Continue = 1 THEN Reinput = 1
 Choice = 1
LOOP
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

