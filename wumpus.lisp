
;;; Global variable declaration
(setf bat1 0)
(setf bat2 0)
(setf pit1 0)
(setf pit2 0)
(setf hunter 0)
(setf wumps 0)
(setf arrow 0)
(setf arrwnum 5)
(setf win nil)
(setf gameon nil)
(setf same nil)
(defvar resp 0)
(defvar resp2 0)
(defvar dist 0)


;;; Seed for random generator
(let* ((state (make-random-state t))
	(copy (make-random-state state)))


;;; Init game plot
(setf cave (make-array '(20 3) :initial-contents '((2 5 8)(1 3 10)(2 4 12)(3 5 14)(1 4 6)
		(5 7 15)(6 8 17)(1 7 9)(8 10 18)(2 9 11)(10 12 19)
		(3 11 13)(12 14 20)(4 13 15)(6 14 16)(15 17 20)
		(7 16 18)(9 17 19)(11 18 20)(13 16 19)) ))

(defun init() 
   (setq bat1 (random-gen) bat2 (random-gen) 
         pit1 (random-gen) pit2 (random-gen)
         hunter (random-gen) wumps (random-gen) arrwnum 5)
   
   (if (= hunter wumps) (init) ))
   

;;; Random number generator
(defun random-gen()
    (if (equal same nil)
	(1+ (random 20 state))
	(1+ (random 20 copy)))))


;;; Take user input
(defun userint ()
  (let ((x (read)))
    (values
        (if (not (typep x 'number)) 
	    (progn (print "Please enter an integer input") (userint)))
	(if (typep x 'number)	 
	    (progn
		(if (or (> x 20) (< x 0)) (progn (print "Choose among room 1-20") (userint))   
                (setq resp x) ))))))

(defun userYN()
(setq resp2
	(with-output-to-string (s)
	    (format s "~s" (read))))

(if (not (or (equal resp2 "Y") (equal resp2 "N")))
	(progn
	    (print "PLEASE ENTER A VALID INPUT: ")
	    (userYN) )))

(defun userSM()
(setq resp2
	(with-output-to-string (s)
	    (format s "~s" (read))))
	    
	    
;;; Check user input 
(if (not (or (equal resp2 "S") (equal resp2 "M")))
	(progn
	    (print "PLEASE ENTER A VALID INPUT: ")
	    (userSM) )))


;;; Check Hunter's next move
(defun move ()
   (print "WHERE TO?")
   (userint)


;;; Move hunter
   (if (or (= resp (aref cave (- hunter 1) 0)) 
	   (= resp (aref cave (- hunter 1) 1)) 
	   (= resp (aref cave (- hunter 1) 2)))
	(setq hunter resp) (progn (print "You can only move to an adjacent room") (move) ))


;;; Check hazard on the way
  (if (or (= hunter bat1) (= hunter bat2))
	(progn
	    (print "ZAP--SUPERBAT SNATCH! ELSEWHEREVILLE FOR YOU. You are now in a random room")
	    (setq hunter (random-gen))))

  (if (or (= hunter pit1) (= hunter pit2))
	(progn
	    (print "YYYIIIEEEEEEE. . . FELL IN A PIT")
	    (setq gameon nil)
	    (setq win nil)
            (gameover)
)))


;;; Decide Wumpus' behavior when disturbed
(defun wmps()
    (if (= hunter wumps)
	(progn
	    (if (> (random-gen) 5)
	        (setq wumps (aref cave (- wumps 1) (mod (random-gen) 3)))
		   	
		 (progn
		    (setq win nil)
		    (setq gameon nil)
		    (print "You are eaten by the wumpus! YOU LOST!")
		    (gameover)))))

    (if (= arrow wumps)
	(progn
	    (if (> (random-gen) 5)
	        (setq wumps (aref cave (- wumps 1) (mod (random-gen) 3)))
		   	
		 (progn
		    (setq win t)
		    (setq gameon nil)
		    (print "You just shoot the wumpus! You won!")
		    (gameover))))))


;;; Shoot arrow to an adjacent room
(defun shoot()
    (setq arrow hunter)
    (decf arrwnum)
    (print "You can shoot through 5 rooms. How many rooms do you want to shoot through?")
    (userint)
    (if (> resp 5) 
      (progn
        (loop
        (when (and (> resp 0)(< resp 6)) (return))
        (print "Choose between 1-5. How many rooms?")
        (userint)
         ) ) )
    (setq dist resp)

    (loop
	(when (< dist 1) (return))
	(print "Where to?")
	(userint)
	(if (not (or (= resp (aref cave (- arrow 1) 0)) 
	   (= resp (aref cave (- arrow 1) 1)) 
	   (= resp (aref cave (- arrow 1) 2)) ) )
	   (progn
		(print "You can only shoot to an adjacent room.")
		(print "Your arrow ended up at a random room.")
		(setq arrow (random-gen))
		(wmps)
		(suicide)	
		(return) )
	   (progn  	
		(setq arrow resp)
		(wmps)
		(suicide)
	  	(decf dist)
	   	 ) ) )
	   	 
	 (if (equal gameon t)
	 (print "Sorry! You missed!"))
	 (if (= arrwnum 0)
	     (progn
		(print "Sorry, You just used up all of your arrows.")
		(print "You lost")
		(setq gameon nil)
		(setq win nil)
 		(gameover))))


;;; Check if the player shoot himself in the back
(defun suicide()
    (if (= hunter arrow)
	(progn
	    (print "HAHAHA- You just shoot yourself in the back")
	    (print "YOU DIED")
	    (setq gameon nil)
	    (setq win nil)
	    (gameover))))	


;;; Decide the result of the game
(defun gameover()
    (if (equal win t) (print "GAME ENDS-YOU WON") (print "GAME ENDS-YOU LOST"))
    (print "Do you want to quit? Y-N")
    (userYN)

    (if  (equal resp2 "Y")   (print "BYE BYE") 
	(progn
	    (print "same setup? Y-N")
	    (userYN)
	    (if (or (equal resp2 "N")) 
		(progn
		    (setq same nil)
		    (wumpus) )
		(progn
		    (setq same t)
		    (wumpus) ) ) ) ) )


;;; Instruction
(defun instruction()

(print "WELCOME TO HUNT THE WUMPUS!!
THE WUMPUS LIVES IN A CAVE OF 20 ROOMS. 
EACH ROOM HAS 3 TUNNELS LEADNG TO OTHER ROOMS'
LOOK AT A DODECAHEDRON TO SEE HOW IT WORKS- 
IF YOU DONNOT KNOW WHAT A DODECAHEDRON IS,
ASK SOMEONE
HAZARDS:  
BOTTEMLESS PITS: TWO ROOMS HAVE BOTTOMLESS PITS
IF YOU GO THERE, YOU FALL INTO THE PIT AND LOSE
SUPER BATS: TWO OTHER ROOMS HAVE SUPER BATS
IF YOU GO THERE, A BAT WILL MOVE YOU TO A RANDOM ROOM
WUMPUS:
THE WUMPUS ONLY BOTHERED BY YOU ENTERING HIS ROOM OR
YOUR ARROW SHOOTS INTO HIS ROOM
IF HE IS BOTHERED, HE MAY MOVE TO ANOTHER ROOM,
OR CHOOSE TO STAY IN THE SAME ROOM 
IF YOU ARE IN THE SAME ROOM WITH THE WUMPUS, 
HE WILL EAT YOU UP, AND YOU LOSE.

YOU: 
EACH TURN YOU CAN MOVE OR SHOOT A CROOKED ARROW.
MOVE: YOU CAN MOVE ONE ROOM (THROUGH ONE TUNNEL.) 
SHOOT: YOU HAVE 5 ARROWS. YOU LOSE WHEN YOU RUN OUT 
EACH ARROW CAN GO FROM 1 TO 5 ROOMS. YOU AIM BY TELLING 
THE COMPUTER THE ROOM #S YOU WANT THE ARROW TO GO TO. 
IF THE ARROW CANNOT GO THAT WAY,
IT MOVES AT RANDOM TO THE NEXT ROOM.
IF THE ARROW HITS THE WUMPUS, YOU WIN. 
IF THE ARROW HITS YOU, YOU LOSE.
  
WARNINGS:
WHEN YOU ARE ONE ROOM AWAY FROM WUMPUS OR HAZARD,
THE COMPUTER SAYS 
WUMPUS: I SMELL A WUMPUS
BAT: BATS NEARBY
PIT: I FEEL A DRAFT

*****
HUNT THE WUMPUS") )


;;; Hazard Detector for the player
(defun detect()
    (if (or (equal pit1  (aref cave (- hunter 1) 0)) (equal pit1  (aref cave (- hunter 1) 1))
            (equal pit1  (aref cave (- hunter 1) 2)) ) 
            (print "I feel draft...")) 

    (if (or (equal pit2  (aref cave (- hunter 1) 0)) (equal pit2  (aref cave (- hunter 1) 1))
            (equal pit2  (aref cave (- hunter 1) 2)) ) 
            (print "I feel draft...")) 

    (if (or (equal bat1  (aref cave (- hunter 1) 0)) (equal bat1  (aref cave (- hunter 1) 1))
            (equal bat1  (aref cave (- hunter 1) 2)) ) 
            (print "BATs near you")) 

    (if (or (equal bat1  (aref cave (- hunter 1) 0)) (equal bat1  (aref cave (- hunter 1) 1))
            (equal bat1  (aref cave (- hunter 1) 2)) ) 
            (print "BATs near you")) 

    (if (or (equal wumps  (aref cave (- hunter 1) 0)) (equal wumps  (aref cave (- hunter 1) 1))
            (equal wumps  (aref cave (- hunter 1) 2)) ) 
            (print "I smell a wumpus")) )


;;; Mainframe of the game
(defun wumpus()
    (print "WELCOME TO HUNT THE WUMPUS WORLD!")
    (print "DO YOU WANT TO READ THE INSTRUCTION?")
    (userYN)
    (if (equal resp2 "Y") (instruction))
    (init)
    (setq gameon t)

    (loop
       (when (equal gameon nil) (return))
       (detect)
       (print "You are in room:")
       (print hunter)
       (print "Which is connected to:")
       (print (aref cave (- hunter 1) 0))
       (print (aref cave (- hunter 1) 1))
       (print (aref cave (- hunter 1) 2))
    
       (print "Do you want to shoot or move?")
       (userSM)
       (if (equal resp2 "S") (shoot) (move) )
     ))









