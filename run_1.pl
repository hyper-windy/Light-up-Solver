consult('lightup.pl').
lightup([[0, 0], [0, 2], [0, 4], [2, 0], [2, 2], [2, 4]], [[0, 1, 5], [0, 3, 5], [1, 0, 5], [1, 1, 5], [1, 2, 5], [1, 3, 5], [1, 4, 5], [2, 1, 5], [2, 3, 5]], Bulbs),
	tell('Solution/sol_1.txt'),
	printBulbs(Bulbs),
	told,
	halt.
