# Towers Solver
**CS 131: Programming Languages** <br />
*9 November 2018*

"Towers is an arithmetical-logical puzzle whose goal is to fill in an N×N grid with integers, so that every row and every column contains all the integers from 1 through N, and so that certain extra constraints can be met. These extra constraints are specified by counts of which towers are visible from an edge of the grid, assuming that each grid entry is occupied by a tower whose height is given by the grid entry." <br />


The two GNU Prolog predicates tower/3 and plain_tower/3 solve tower puzzles. <br />
tower/3 makes use of the GNU Prolog finite domain solver, while plain_tower/3 does not. <br />

tower/3 and plain_tower/3 accepts the following arguments: <br />
* N, a nonnegative integer specifying the size of the square grid.
* T, a list of N lists, each representing a row of the square grid. Each row is represented by a list of N distinct integers from 1 through N. The corresponding columns also contain all the integers from 1 through N.
* C, a structure with function symbol counts and arity 4. Its arguments are all lists of N integers, and represent the tower counts for the top, bottom, left, and right edges, respectively.

While the spec suggested that tower/3 be implemented first, I implemented plain_tower/3 first to better develop the logic and optimize the solution before making use of the speedup the GNU Prolog finite domain solver provides.
