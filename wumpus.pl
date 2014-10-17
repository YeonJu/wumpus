
start:-
  seedinit, rt, wumpus.

wumpus:- 
 
  nl, write('WELCOME TO HUNT THE WUMPUS'), nl, 
  gameprep, nl, write('BYE BYE!'),!.


/*      Start */
gameprep:-
  write('DO YOU WANT TO READ INSTRUCTIONS? (y/n): '),
  read(I),
  instructions(I), nl,
  init(_,_,_,_,_,_),
  main_frame.


/*    Instruction */
instructions(I):-
  I = n,!.
instructions(I):-
  I = y,
  nl, write('WELCOME TO HUNT THE WUMPUS!! '),
  nl, write('THE WUMPUS LIVES IN A CAVE OF 20 ROOMS. '),
  nl, write('EACH ROOM HAS 3 TUNNELS LEADNG TO OTHER ROOMS'),
  nl, write('LOOK AT A DODECAHEDRON TO SEE HOW IT WORKS- '),
  nl, write('IF YOU DONNOT KNOW WHAT A DODECAHEDRON IS,'),
  nl, write('ASK SOMEONE '),
         
  nl, write( 'HAZARDS:  '),
  nl, write('BOTTEMLESS PITS: TWO ROOMS HAVE BOTTOMLESS PITS'),
  nl, write('IF YOU GO THERE, YOU FALL INTO THE PIT AND LOSE '),
  nl, write('SUPER BATS: TWO OTHER ROOMS HAVE SUPER BATS'),
  nl, write('IF YOU GO THERE, A BAT WILL MOVE YOU TO A RANDOM ROOM '),
  nl, write('WUMPUS:'),
  nl, write('THE WUMPUS ONLY BOTHERED BY YOU ENTERING HIS ROOM OR'),
  nl, write('YOUR ARROW SHOOTS INTO HIS ROOM '),
  nl, write('IF HE IS BOTHERED, HE MAY MOVE TO ANOTHER ROOM, '),
  nl, write('OR CHOOSE TO STAY IN THE SAME ROOM '),
  nl, write('IF YOU ARE IN THE SAME ROOM WITH THE WUMPUS, '),
  nl, write('HE WILL EAT YOU UP, AND YOU LOSE '),
     
  nl,nl, write('YOU: '),
  nl, write('EACH TURN YOU CAN MOVE OR SHOOT A CROOKED ARROW.'),
  nl, write('MOVE: YOU CAN MOVE ONE ROOM (THROUGH ONE TUNNEL.) '),
  nl, write('SHOOT: YOU HAVE 5 ARROWS. YOU LOSE WHEN YOU RUN OUT '),
  nl, write('EACH ARROW CAN GO FROM 1 TO 5 ROOMS. YOU AIM BY TELLING '),
  nl, write('THE COMPUTER THE ROOM #S YOU WANT THE ARROW TO GO TO. '),
  nl, write('IF THE ARROW CANNOT GO THAT WAY,'),
  nl, write('IT MOVES AT RANDOM TO THE NEXT ROOM.'),
  nl, write( 'IF THE ARROW HITS THE WUMPUS, YOU WIN. '),
  nl, write( 'IF THE ARROW HITS YOU, YOU LOSE.'),
  nl,nl, write('WARNINGS: '),
  nl, write('WHEN YOU ARE ONE ROOM AWAY FROM WUMPUS OR HAZARD,'),
  nl, write('THE COMPUTER SAYS '),
  nl, write('WUMPUS: I SMELL A WUMPUS'),
  nl, write('BAT: BATS NEARBY'),
  nl, write('PIT: I FEEL A DRAFT'),
       
  nl, write(      '*****'),
  nl, write( 'HUNT THE WUMPUS'),nl,nl, !.

instructions(_):-
  nl, write('PLEASE ENTER y OR n'), nl, read(I),
  instructions(I).


/*      Gameover */
gameover:-
  do_retract, nl,write('DO YOU WANT TO QUIT? (y/n): '),read(Q),
  gamecont(Q).

gamecont(Q):-
  Q = y, write('GAME ENDS----'),halt,!.

gamecont(Q):-
  Q = n, nl, write('DO YOU WANT TO PLAY ANOTHER GAME WITH SAME SET UP?'),
  read(S), newgame(S).

gamecont(_):-
 nl, write('PLEASE ENTER Y OR N'), read(E), gamecont(E).

newgame(S):-
  S = y, myseed(K), set_seed(K), wumpus.

newgame(S):-
  S = n, seedinit, rt, wumpus.

newgame(_):-
  write("PLEASE ENTER Y OR N"), read(R), newgame(R).


/*      Random game plot generator */
seedinit:-
  asserta(myseed(0)).

rt:-
  real_time(T), set_seed(T), retract(myseed(_)), asserta(myseed(T)).


/*      Initialization */
init(H,B1,B2,P1,P2,W):-
  random(1, 21, H),
  random(1, 21, B1),
  random(1, 21, B2),
  random(1, 21, P1),
  random(1, 21, P2),
  random(1, 21, W),
  init_check(H, B1, B2, P1, P2, W),
  do_assert(H,B1,B2,P1,P2,W).
		
init_check(H, _, _, _, _, W):-
  H = W,
  random(1, 21, X),
  init_check(H, _,_,_,_, X).

init_check(_, _, _, _, _, _):-
  !.

do_assert(H, B1, B2, P1, P2, W):-
  asserta(hunter(H)),
  asserta(bat1(B1)),
  asserta(bat2(B2)),
  asserta(pit1(P1)),
  asserta(pit2(P2)),
  asserta(wumpus(W)),
  asserta(arrwnum(5)).

cave(1,2).
cave(1,5).
cave(1,8).
cave(2,1).
cave(2,3).
cave(2,10).
cave(3,2).
cave(3,4).
cave(3,12).
cave(4,3).
cave(4,5).
cave(4,14).
cave(5,1).
cave(5,4).
cave(5,6).
cave(6,5).
cave(6,7).
cave(6,15).
cave(7,6).
cave(7,8).
cave(7,17).
cave(8,1).
cave(8,7).
cave(8,9).
cave(9,8).
cave(9,10).
cave(9,18).
cave(10,2).
cave(10,9).
cave(10,11).
cave(11,10).
cave(11,12).
cave(11,19).
cave(12,11).
cave(12,13).
cave(12,3).
cave(13,12).
cave(13,14).
cave(13,20).
cave(14,13).
cave(14,15).
cave(14,4).
cave(15,6).
cave(15,14).
cave(15,16).
cave(16,15).
cave(16,17).
cave(16,20).
cave(17,18).
cave(17,16).
cave(17,7).
cave(18,9).
cave(18,17).
cave(18,19).
cave(19,11).
cave(19,18).
cave(19,20).
cave(20,13).
cave(20,16).
cave(20,19).


/*      Game Env Reset */
do_retract:-
  hunter(H), retract(hunter(H)),
  bat1(B1), retract(bat1(B1)),
  bat2(B2), retract(bat2(B2)),
  pit1(P1), retract(pit1(P1)),
  pit2(P2), retract(pit2(P2)),
  wumpus(W), retract(wumpus(W)),
  arrwnum(N), retract(arrwnum(N)).


/*       Player Position */
position:-
  hunter(H),write('YOU ARE IN CAVE '), write(H),
  write(' WHICH IS CONNECTED TO '),
  caveadj(H),!.

caveadj(H):-
  cave(H, X),write(X), write(' '),fail.
caveadj(_).


/*     Stepwise Instruction */
main_frame:-
  hunter(H), bat1(B1), bat2(B2), pit1(P1), pit2(P2), wumpus(W),
  detector(H, B1, B2, P1, P2, W), position,nl,
  nl, write('DO YOU WANT TO SHOOT OR MOVE? (s/m): '),
  read(R), action(R).


/*     Hazard Detector */
detector(H, B1, B2, P1, P2, W):-
  cave(H, B1), write('BATS NEAR YOU'), nl,
  detector(H, 0, B2, P1, P2, W).
detector(H, B1, B2, P1, P2, W):-
  cave(H, B2), write('BATS NEAR YOU'), nl,
  detector(H, B1, 0, P1, P2, W).
detector(H, B1, B2, P1, P2, W):-
  cave(H, P1), write('I FEEL DRAFT...'), nl,
  detector(H, B1, B2, 0, P2, W).
detector(H, B1, B2, P1, P2, W):-
  cave(H, P2), write('I FEEL DRAFT...'), nl,
  detector(H, B1, B2, P1, 0, W).
detector(H, _, _, _, _, W):-
  cave(H, W), write('I SMELL A WUMPUS'), nl.
detector(_, _, _, _, _, _).


/*       Determine player's next move */
action(R):-
 R = s,
  write('YOU CAN SHOOT THROUGH 1 TO 5 CAVES.'),nl,
  write('HOW MANY CAVES? '),read(K),shoot(K).

action(R):-
 R = m,
 nl, write('WHERE TO? '), read(K), move(K).

action(_):-
 nl, write('PLEASE CHOOSE BETWEEN S OR M'),
 nl, write('DO YOU WANT TO SHOOT OR MOVE? (s/m): '),
 read(R), action(R).


/*        Shoot wumpus */
shoot(R):-
  R<6, R>0,
  hunter(H),asserta(arrow(H)),
  arrwnum(N),retract(arrwnum(N)),
  X is N - 1, asserta(arrwnum(X)),
  arrowloop(R).

shoot(_):-
  write('PLEASE CHOOSE BETWEEN 1-5.'), nl,
  write('HOW MANY CAVES? '),
  read(R), shoot(R).

arrowloop(R):-
  R = 0, nl, write('SORRY, YOU MISSED!'), nl,
  arrow(A), retract(arrow(A)),arrwnum(N), arrwnum_check(N).

arrowloop(R):-
  nl, write('WHERE TO? '), read(K), movearrw(R, K).

randomarrow(A):-
  arrow(A),random(1, 21, T), cave(A,T),
  retract(arrow(A)),asserta(arrow(T)).
randomarrow(A):-
  randomarrow(A).

movearrw(R, K):-
  arrow(A),cave(K, A),retract(arrow(A)), 
  asserta(arrow(K)), shotresult(R).

movearrw(_, _):-
  arrow(A), randomarrow(A),
  write('YOUR INPUT WAS INVALID, SO'),nl, arrow(T),
  write('YOUR ARROW ENDED UP AT A RANDOM ADJACENT CAVE: '), write(T), nl,
  U is 1, shotresult(U).
  
arrwnum_check(N):-
  arrwnum(N),N < 1,
  nl, write('YOU JUST USED UP ALL OF YOUR ARROWS. SORRY, YOU LOST.'), nl,
  write('GAME OVER.'), gameover.
arrwnum_check(_):- main_frame.


/*    Determine Wumpus' next move */
wumcheck(W,Y,_):-
  Y=1, getaway(W).

wumcheck(W,_,A):-
  wumkill(A,W).


/*     Kill wumpus */
wumkill(A,W):-
  arrow(A), wumpus(W), A = W,
  nl, write('YOU JUST KILLED THE WUMPUS!'), nl,
  write('CONGRATULATIONS, YOU WON!'), nl,
  retract(arrow(A)), gameover.

wumkill(_,_):-
  !.


/*    Check if the player shoot himself in the back */
suicide(A,H):-
  arrow(A), hunter(H), A = H,
  nl, write('YOU JUST SHOOT YOURSELF IN THE BACK. BYE BYE'), nl,
  write('GAME OVER'), gameover,!.

suicide(_,_):-
  !.


/*     Check game result */
shotresult(R):-
  arrow(A),hunter(H),wumpus(W),
  suicide(A,H), random(1,4,Y), wumcheck(W,Y,A), 
  X is R - 1, arrowloop(X).

move(C):-
  hunter(H), cave(H, C), retract(hunter(H)),asserta(hunter(C)),
  bat1(B1), bat2(B2), pit1(P1), pit2(P2), wumpus(W),
  mvresult(C, B1, B2, P1, P2, W).

move(_):-
  nl, write('YOU CAN ONLY MOVE TO AN ADJACENT CAVE'), nl,
  write('WHERE TO? '), read(P), move(P).


/*       Determines wumpus' next move */
wumpusmv(W,Y):-
  Y=1, getaway(W),!.

wumpusmv(_,_):-
  nl, write('SORRY, YOU WERE EATEN BY A WUMPUS.'), nl,
  write('GAME OVER.'), gameover,!.

getaway(W):-
  random(1,21,Y), cave(W,Y),
  retract(wumpus(W)),asserta(wumpus(Y)).
getaway(W):-
  getaway(W).

mvresult(H, _, _, _, _, W):-
 H = W,
 random(1,4,Y),
 wumpusmv(W,Y).

mvresult(H, _, _, P1, _, _):-
 H = P1,
 nl, write('YYIIIEEEE... FELL IN A PIT.'), nl,
 write('GAME OVER'), gameover,!.

mvresult(H, _, _, _, P2, _):-
 H = P2, nl, write('YYIIIEEEE... FELL IN A PIT'), nl,
 write('GAME OVER'), gameover,!.

mvresult(H, B1, B2, P1, P2, W):-
 H = B1, nl, write('SUPER BAT SNATCH--ELSEWHEREVILLE FOR YOU'),
 random(1, 21, M),  retract(hunter(H)),asserta(hunter(M)),
 mvresult(M, B1, B2, P1, P2, W).

mvresult(H, B1, B2, P1, P2, W):-
 H = B2, nl, write('SUPER BAT SNATCH--ELSEWHEREVILLE FOR YOU'),
 random(1, 21, M),retract(hunter(H)),asserta(hunter(M)),
 mvresult(M, B1, B2, P1, P2, W).

mvresult(_, _, _, _, _, _):-
 nl, main_frame.
