% lightup.pl
% CS3243 Homework 2I: Light Up

%--------------------------- [HELPER FUNCTION] ---------------------------%
list_member(X,[X|_]) :- !.
list_member(X,[_|TAIL]) :- list_member(X,TAIL).


count_neibor([], L, 0).
count_neibor([X | Tail], L, N) :- list_member(X, L), !, count_neibor(Tail, L, N1), N is N1 + 1.
count_neibor([X | Tail], L, N) :- count_neibor(Tail, L, N).



get_neibor([], L, _, _, 0, []).
get_neibor([X | Tail], L, BlackCells, CurrBulbs, N, L2) :- list_member(X, L), check_constrain_2(BlackCells, [X|CurrBulbs], L), !, get_neibor(Tail, L, BlackCells, CurrBulbs, N1, L3), N is N1 + 1, L2 = [X|L3].
get_neibor([X | Tail], L, BlackCells, CurrBulbs ,N, L2) :- get_neibor(Tail, L, BlackCells, CurrBulbs, N, L2).
%--------------------------------------------------------------------------%



%--------------------------- [CHECK IF THERE IS ONE BLACK CELL BETWEEN 2 WHITE CELL] ---------------------------%
black_between(A, X, Y, [[A, B, C] | BackCells], 0) :- X < B, B < Y, !.
black_between(A, X, Y, [[A, B, C] | BackCells], 0) :- X > B, B > Y, !.

black_between(A, X, Y, [[B, A, C] | BackCells], 1) :- X < B, B < Y, !.
black_between(A, X, Y, [[B, A, C] | BackCells], 1) :- X > B, B > Y, !.

black_between(A, X, Y, [H|Tail], K) :- black_between(A, X, Y, Tail, K).


not_between(A, X, Y, BlackCells, K) :- black_between(A, X, Y, BlackCells, K), !, fail; true.
%---------------------------------------------------------------------------------------------------------------%



%----------------------- [WHEN PUTTING LIGHT DELETE WHITE CELL] -------------------------%
%delete in 3 case.
putLight(A, B, [], _, []) :- !.

putLight(A, B, [[A, B] | L1], BlackCells, CurrWhite) :-
	% write('1'),nl,
	% write([A, B]), nl,
	% write([[A, B] | L1]), nl,
	% write('xxxx'),write(NewWhite),nl,
	putLight(A, B, L1, BlackCells, CurrWhite), !. %delete

putLight(A, X, [[A, Y] | L1], BlackCells, CurrWhite) :-
	% write('2'),nl,
	% write([A,X]),nl,
	% write([[A, Y] | L1]),nl,
	not_between(A, X, Y, BlackCells, 0), !, 
	% write('xxxx'),write(NewWhite),nl,
	putLight(A, X, L1, BlackCells, CurrWhite). %delete

putLight(X, A, [[Y, A] | L1], BlackCells, CurrWhite) :-
	% write('3'),nl,
	% write([X,A]),nl,
	% write([[Y, A] | L1]),nl,
	not_between(A, X, Y, BlackCells, 1), !, 
	% write('xxxx'),write(NewWhite),nl,
	putLight(X, A, L1, BlackCells, CurrWhite). %delete

putLight(X, A, [H | L1], BlackCells, CurrWhite) :-
	% write('4'),nl,
	% write([X,A]),nl,
	% write([H | L1]),nl,
	putLight(X, A, L1, BlackCells, OutWhite), CurrWhite = [H | OutWhite].
%-----------------------------------------------------------------------------------------%




%-------------------------------- [CHECKING FINAL CONSTRAIN] -------------------------------%
check_one_black_cell([X, Y , 5], CurrBulbs) :- !.

check_one_black_cell([X, Y , Z], CurrBulbs) :-
	A is X + 1, B is X - 1, C is Y + 1, D is Y - 1,
	count_neibor([[A, Y], [B, Y], [X, C], [X, D]], CurrBulbs, K),
	K = Z.


check_constrain([], _).

check_constrain([X|BlackCells], CurrBulbs) :-
	check_one_black_cell(X, CurrBulbs),
	check_constrain(BlackCells, CurrBulbs).
%-------------------------------------------------------------------------------------------%



%------------------------ [CHECKING CURRENT CONSTRAIN] -----------------------%
check_one_black_cell_2([X, Y , 5], _, _) :- !.

check_one_black_cell_2([X, Y , Z], CurrBulbs, WhiteCells) :-
	A is X + 1, B is X - 1, C is Y + 1, D is Y - 1,
	count_neibor([[A, Y], [B, Y], [X, C], [X, D]], CurrBulbs, Num1), % Num1 is number of bulbs around black cell
	Num1 =< Z,
	count_neibor([[A, Y], [B, Y], [X, C], [X, D]], WhiteCells, Num2), % Num2 is number of white cell around black cell
	K is Num1 + Num2,
	K >= Z.


check_constrain_2([], _, _).

check_constrain_2([X|BlackCells], CurrBulbs, WhiteCells) :-
	check_one_black_cell_2(X, CurrBulbs, WhiteCells),
	check_constrain_2(BlackCells, CurrBulbs, WhiteCells).
%----------------------------------------------------------------------------%



%------------------------------- [USING BACKTRACKING] -------------------------------%
traverse(_, [], BlackCells, CurrBulbs, Bulbs) :- 
	% write(CurrBulbs), nl,
	check_constrain(BlackCells, CurrBulbs),
	Bulbs = CurrBulbs, !.
	
traverse([[A, B] | List1], List2, BlackCells, CurrBulbs, Bulbs) :-        % List 1 is List of Traversed White Cells, List 2 is List of Current White Cells
	write('\n\n>>>Visit: '), write(A), write(' '), write(B), nl,
	putLight(A, B, List2, BlackCells, NewList),
	check_constrain_2(BlackCells, [[A, B]|CurrBulbs], NewList),
	write('Pass'),nl,
	% -------------------[USING PATTERN HERE] -------------------%
	write('----------- Checking pattern -----------'), nl,
	pattern1(BlackCells, BlackCells, BlackCells, NewList, [[A, B] | CurrBulbs], OutBulbs, OutWhite, 0),
	write('\nOut\nCurrent Bulbs='), write(OutBulbs), nl,
	write('Current White='), write(OutWhite), nl,
	% -----------------------------------------------------------%
	% write('Current Bulbs: '),write([[A, B]|CurrBulbs]),nl,
	% write('Remaining White: '),write(NewList),nl,
	traverse(OutWhite, OutWhite, BlackCells, OutBulbs, Bulbs),!.

traverse([[A, B] | List1], List2, BlackCells, CurrBulbs, Bulbs) :-
    traverse(List1, List2, BlackCells,  CurrBulbs, Bulbs).
%------------------------------------------------------------------------------------%



%------------------- [GET LIST OF WHITE CELL AROUND BLACK CELL SATIFIED] ------------------------%
getWhite([X, Y, Z], WhiteCells, BlackCells, CurrBulbs, ListWhite) :-
	A is X + 1, B is X - 1, C is Y + 1, D is Y - 1,
	get_neibor([[A, Y], [B, Y], [X, C], [X, D]], WhiteCells, BlackCells, CurrBulbs, Num1, ListWhite),
	count_neibor([[A, Y], [B, Y], [X, C], [X, D]], CurrBulbs, Num2),
	% write('num1='),write(Num1),nl,
	% write('num2='),write(Num2),nl,
	Num1 =\= 0, 
	K is Num1 + Num2,
	K = Z.
%-----------------------------------------------------------------------------------------------%



%---------------------------------------------- [PUT MULTIPLE BULBS] ----------------------------------------%
putMultipleLight([], WhiteCells, _, NewList, CurrBulbs, Bulbs) :-
	NewList = WhiteCells,
	Bulbs = CurrBulbs.

putMultipleLight([[A, B]|Tail], WhiteCells, BlackCells, NewList, CurrBulbs, Bulbs) :-
	putLight(A, B, WhiteCells, BlackCells, NewWhite), !,
	% write('putLight='),write(A),write(' '), write(B), nl,
	% write('newWhite='), write(NewWhite), nl,
	putMultipleLight(Tail, NewWhite, BlackCells, NewList, [[A, B] | CurrBulbs], Bulbs).
%-----------------------------------------------------------------------------------------------------------%



%------------------------------ [CHECKING PATTERN 1 AND PATTERN 2] ---------------------------------%
pattern1(_, CurrBlack, BlackCells, [], CurrBulbs, FinalBulbs, FinalWhite, _) :-       % WhiteCells is empty.
	FinalWhite = [],
	FinalBulbs = CurrBulbs, !.

pattern1(_, [], BlackCells, WhiteCells, CurrBulbs, FinalBulbs, FinalWhite, _) :-       % Current BackCell is empty.
	FinalWhite = WhiteCells,
	FinalBulbs = CurrBulbs, !.

pattern1([], CurrBlack, BlackCells, WhiteCells, CurrBulbs, FinalBulbs, FinalWhite, 0) :-
	% write('end'), write(CurrBlack), nl,
	FinalWhite = WhiteCells,
	FinalBulbs = CurrBulbs, !.

pattern1([], CurrBlack, BlackCells, WhiteCells, CurrBulbs, FinalBulbs, FinalWhite, Flag) :-      % Second chance.
	Flag = 1, !,
	% write('return'), write(CurrBlack), nl,
    pattern1(CurrBlack, CurrBlack, BlackCells, WhiteCells, CurrBulbs, FinalBulbs, FinalWhite, 0).

pattern1([H|Tail], CurrBlack, BlackCells, WhiteCells, CurrBulbs, FinalBulbs, FinalWhite, Flag) :-
	getWhite(H, WhiteCells, BlackCells, CurrBulbs, ListWhite), !,
	write('\nChoose black: '),write(H),nl,
	write('Put Bulbs: '), write(ListWhite), nl,
	putMultipleLight(ListWhite, WhiteCells, BlackCells, NewList, CurrBulbs, NewBulbs),
    write('Current Bulbs: '), write(NewBulbs), nl,
	% write('NewList'), write(NewList), nl,
	delete(CurrBlack, H, NewCurrBlack),
	pattern1(Tail, NewCurrBlack, BlackCells, NewList, NewBulbs, FinalBulbs, FinalWhite, 1).

pattern1([H|Tail], CurrBlack, BlackCells, WhiteCells, CurrBulbs, FinalBulbs, FinalWhite, Flag) :-
	pattern1(Tail, CurrBlack, BlackCells, WhiteCells, CurrBulbs, FinalBulbs, FinalWhite, Flag).
%-----------------------------------------------------------------------------------------------------%



%-----------------------[TESTING]------------------------------%
% test1 :- 
% 	X = [[1,1],[1,4], [2,2]],
% 	putLight(1,1, X, [[1,2,3],[1,3,5]], X, Y),
% 	write(Y).

% test2 :- 
% 	X = [[1,1],[1,3],[2,1],[2,2],[2,3],[3,1],[3,2],[3,3],[5,1]],
% 	traverse(X, X, [[1,2,2]], Y),
% 	write('Y='), write(Y).

% test3 :- 
% 	X = [[1,1],[1,3],[2,1],[2,2],[2,3],[3,1],[3,2],[3,3],[5,1]],
% 	Black = [[1, 2, 3],[4,1,5]],
% 	pattern1(Black, Black, Black, X, [], A, Y, 0),
% 	write('A='), write(A), nl,
% 	write('Y='), write(Y), nl,
% 	traverse(Y, Y, Black, A, Bulbs),
% 	write('Bulbs='), write(Bulbs), nl.

% test4 :- 
% 	lightup(),
% 	printBulbs(Bulbs).
%----------------------------------------------------------------%



%--------------------------------------------[MAIN]---------------------------------------%
lightup(WhiteCells, NumberConstraints, Bulbs) :-
	write('----------- Checking pattern -----------'), nl,
	pattern1(NumberConstraints, NumberConstraints, NumberConstraints, WhiteCells, [], OutBulbs, OutWhite, 0),
	write('\nOut\nCurrent Bulbs='), write(OutBulbs), nl,
	write('Current White='), write(OutWhite), nl,
	% OutWhite = WhiteCells, OutBulbs = [],
	write('\n\n%------------------ [BACKTRACKING] -------------------%'), nl,
	traverse(OutWhite, OutWhite, NumberConstraints, OutBulbs, Bulbs),
	write('\n\n---------------\nBulbs = '), write(Bulbs), nl.
%-------------------------------------------------------------------------------------------%


%-------------------[PRINT BULBS]------------------%
% % Pretty printer to print the coordinates of each bulb in a row.
printBulbs([]).
printBulbs([[R, C] | Bulbs]) :-
	write(R), write(' '), write(C), nl,
	printBulbs(Bulbs).
%---------------------------------------------------%