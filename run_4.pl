consult('lightup.pl').
lightup([[0, 0], [0, 2], [0, 3], [0, 5], [0, 6], [1, 0], [1, 1], [1, 2], [1, 3], [1, 4], [1, 5], [2, 1], [2, 2], [2, 3], [2, 4], [2, 5], [2, 6], [3, 0], [3, 1], [3, 2], [3, 4], [3, 5], [3, 6], [4, 0], [4, 1], [4, 2], [4, 3], [4, 4], [4, 5], [5, 1], [5, 2], [5, 3], [5, 4], [5, 5], [5, 6], [6, 0], [6, 1], [6, 3], [6, 4], [6, 6]], [[0, 1, 3], [0, 4, 5], [1, 6, 2], [2, 0, 5], [3, 3, 0], [4, 6, 0], [5, 0, 2], [6, 2, 1], [6, 5, 1]], Bulbs),
	tell('Solution/sol_4.txt'),
	printBulbs(Bulbs),
	told,
	halt.
