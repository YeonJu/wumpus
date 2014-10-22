Hunt the Wumpus
======================
Classic text-based "Hunt the Wumpus" game implemented in four different languages
-----------------------------------------------------------------------------------

Hunt the Wumpus was first created by a student at Dartmouth, who were tired of the same old grid-based games.
So rather than planting the player&game elements on each grid (= tiny tiles that cover the whole
game map) in the game environment, Hunt the Wumpus puts each element in a room where the connectivity of
each room is predetermined. The map(connectivity) of this game can be easily visualized 
as a "squashed Dodecahedron."


For the ones who want some visual aid, I'd recommend this webpage: 
  http://www.kidsmathgamesonline.com/pictures/shapes/dodecahedron.html


So there are 20 rooms in a cave, each connected to three other different rooms, which the player will explore.
The player, Wumpus, and hazards can be located in any of those rooms, and can move to one of adjacent rooms.
The goal of this game is to kill the wumpus before it eats you up!


The huge difference between a map-based and a grid-based game is that there can be no such command as 
"move left one step" in the map-based game, while the latter can't function without this kind of command. 


Each movement/action of the game happens based on what "room" the player is in, 
not at which "point" he/she is. This was a pretty interesting shift in viewpoint!



Without further ado, Let's get started! 
-------------------------------------------------

In this repo, I have uploaded four different implementations of the game.
(No matter which file you choose to try out, you'll always be able to play the same "Hunt the Wumpus")
The installation explanation below works best for Linux(Ubuntu).



a. FORTRAN (Imperative Language)
-----------------------------------

1. Open up your command line tool, and clone the repo:

   git clone https://github.com/YeonJu/wumpus
  
2. CD into the repo you just cloned:

   cd Where/You/Have/Downloaded/The/Repo

When you type ls, you should be able to see the four wumpus files in this repo copied in your directory.

3. wumpus.f is written in Fortran77, but getting the latest gfortran compiler will get you through the whole process
without any problem:

   sudo apt-get install gfortran

4. Then compile the file:

    gfortran wumpus.f
  
5. Type ls again, you'll see a new file generated, named a.out. Type: 

    ./a.out  
  
  Tada! Enjoy the game!




b. LISP (Functional Language)
---------------------------------------

1. Assuming that you are already in the right directory, in your terminal type:

    sudo apt-get install clisp

2. Now you have installed CommonLisp, try it out by typing

    clisp

You should see a pretty logo moving up and down on your terminal. 
If it does not work in your machine for some reason, there is an alternative
package that you can install. Try: sudo apt-get install sbcl

3. After your successful installation of CommonLisp, type:

    (load "wumpus.lisp")
    (wumpus)

(Remember, ((parentheses) are the like the elixir of lisp))!!!




c. Prolog (Logical Language)
----------------------------------
This language was hardest to get used to out of all four languages, 
especially when I first started learning how to code with Java and Python(the two best languages for
Object Oriented programming!)

1. Go into the right directory, and open up the terminal, and type:

    apt-get install swi-prolog

2. Then, type: 
    swipl
  to see if the installation was successful.

3. Assuming that the terminal didn't give you any hard time in installing the package, type:

    [wumpus].   #<- Loading the file
    wumpus.     

4. and Enjoy! You can always halt the game by typing 

    halt.




d. Literate-Java
-------------------------------------
Literate-java was the most fun language to play around in this project.
Think of it as the same as LaTex, but not only it produces a beautiful pdf file that explains the 
structure of the code, but also the game works perfectly fine!!
I think this should be the standard language of any open-source projects
to lower the entry barrier for beginners. But as there's no such thing as "perfect" programming language, 
Literate Java takes long time to "write." (Yes, I said "write," not "code")

Installation can be also a little troublesome too. I used "Rambutan" for this project, 
and you can get more detailed info here: http://www.qgd.uzh.ch/projects/rambutan/Manual.pdf
and Download the Rambutan software here: http://www.qgd.uzh.ch/projects/rambutan/

Detailed explanation on how to install/execute the file is included in the pdf file above. 

Enjoy!
