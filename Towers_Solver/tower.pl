/* Robert Griffith
   CS 131 HW 
*/

%=======================PLAIN-TOWER======================

/* visible
   arguments:
   list of numbers (towers),
   current count of visible towers,
   Maximum height of tower encountered,
   total count of visible towers
*/
visible([], VT, _, VT).
visible([X|L], V, M, VT):-
    X>M,
    VI is V+1,
    !,
    visible(L, VI, X, VT).
visible([X|L], V, M, VT):-
    X=<M,
    !,
    visible(L, V, M, VT).


/* first_elements
   arguments:
   list of lists
   list of first element in each list
   list of lists without first elements
*/
first_elements([], [], []).
first_elements([[X|L]|LL], [X|E], [L|RLL]):-
    first_elements(LL, E, RLL).


/* valid_numbers
   arguments:
   list of numbers (towers) in range [1,N]
   N (max number)
*/
valid_numbers(_, N):-
    N<0,
    !,
    fail.
valid_numbers([], 0).
valid_numbers([N|L], N):-
    ND is N-1,
    !,
    valid_numbers(L, ND).


/* counts_length
   arguments:
   list of counts lists
   size of all counts lists
*/
counts_length([C1,C2,C3,C4], N):-
    length(C1, N),
    length(C2, N),
    length(C3, N),
    length(C4, N).

/* valid_rows
   arguments:
   list of lists of numbers (towers) traversed row-wise
   list of lists of numbers (towers) traversed column-wise
   list of acceptable numbers
   list of lists of visible towers

   recursively checks matrix
   at iteration i row_i and column_i are checked
   this minimizes backtracking and makes it faster
*/
valid_rows([], _, _, [[],[],[],[]]).
valid_rows([L|LL], T, NL, [[V1|C1], [V2|C2], [V3|C3], [V4|C4]]):-
    first_elements(T, LT, TR),
    permutation(NL, L),
    permutation(NL, LT),
    visible(L, 0, 0, V3),
    visible(LT, 0, 0, V1),
    reverse(L, RL),
    visible(RL, 0, 0, V4),
    reverse(LT, RLT),
    visible(RLT, 0, 0, V2),
    valid_rows(LL, TR, NL, [C1, C2, C3, C4]).


plain_tower(N, T, counts(C1,C2,C3,C4)):-
    length(T, N),
    C=[C1,C2,C3,C4],
    counts_length(C, N),
    valid_numbers(NL, N),
    !,
    valid_rows(T, T, NL, C).



%==========================TOWER======================

/* fd_visible
   arguments:
   list of numbers (towers),
   current count of visible towers,
   Maximum height of tower encountered,
   total count of visible towers
*/
fd_visible([], VT, _, VT).
fd_visible([X|L], V, M, VT):-
    X#>M,
    VI is V+1,
    fd_visible(L, VI, X, VT).
fd_visible([X|L], V, M, VT):-
    X#=<M,
    fd_visible(L, V, M, VT).


/* fd_counts_length
   arguments:
   list of counts lists
   size of all counts lists
*/
fd_counts_length([C1,C2,C3,C4], N):-
    length(C1, N),
    length(C2, N),
    length(C3, N),
    length(C4, N),
    fd_domain(C1, 1, N),
    fd_domain(C2, 1, N),
    fd_domain(C3, 1, N),
    fd_domain(C4, 1, N).


/* fd_valid_rows
   arguments:
   list of lists of numbers (towers) traversed row-wise
   list of lists of numbers (towers) traversed column-wise
   length of row and upper bound for numbers
   list of lists of visible towers

   recursively checks matrix
   at iteration i row_i and column_i are checked
*/
fd_valid_rows([], _, _, [[],[],[],[]]).
fd_valid_rows([L|LL], T, N, [[V1|C1], [V2|C2], [V3|C3], [V4|C4]]):-
    length(L, N),
    first_elements(T, LT, TR),
    fd_domain(L, 1, N),
    fd_all_different(L),
    fd_domain(LT, 1, N),
    fd_all_different(LT),
    !,
    fd_valid_rows(LL, TR, N, [C1, C2, C3, C4]),
    fd_visible(L, 0, 0, V3),
    fd_visible(LT, 0, 0, V1),
    reverse(L, RL),
    fd_visible(RL, 0, 0, V4),
    reverse(LT, RLT),
    fd_visible(RLT, 0, 0, V2),
    append(L, LT, A),
    fd_labeling([V1,V2,V3,V4|A]).


tower(N, T, counts(C1,C2,C3,C4)):-
    length(T, N),
    C=[C1,C2,C3,C4],
    fd_counts_length(C, N),
    fd_valid_rows(T, T, N, C).



%======================SPEEDUP======================

/* plain_test_N
   arguments:
   dimension N for NxN matrix
   lsit of NxN tower matrices that are solvable
*/
plain_test_N(N, LT):-
    findall(T, plain_tower(N,T,_), LT).

/* plain_test
   arguments:
   run time in ms
*/
plain_test(RT):-
    statistics(real_time, _),
    plain_test_N(0, _),
    plain_test_N(1, _),
    plain_test_N(2, _),
    plain_test_N(3, _),
    plain_test_N(4, _),
    plain_test_N(4, _),
    plain_test_N(4, _),
    plain_test_N(4, _),
    plain_test_N(4, _),
    plain_test_N(4, _),
    plain_test_N(4, _),
    plain_test_N(4, _),
    plain_test_N(4, _),
    plain_test_N(4, _),
    plain_test_N(4, _),
    plain_test_N(4, _),
    C=counts([2,3,2,1,4],[3,1,3,3,2],[4,1,2,5,2],[2,4,2,1,2]),
    plain_tower(_, _, C),
    plain_tower(_, _, C),
    plain_tower(_, _, C),
    plain_tower(_, _, C),
    plain_tower(_, _, C),
    T=[[2,3,4,5,1],[5,4,1,3,2],[4,1,5,2,3],[1,2,3,4,5],[3,5,2,1,4]],
    plain_tower(_, T, _),
    plain_tower(_, T, _),
    plain_tower(_, T, _),
    plain_tower(_, T, _),
    plain_tower(_, T, _),
    statistics(real_time, [_, RT]).


/* fd_test_N
   arguments:
   dimension N for NxN matrix
   lsit of NxN tower matrices that are solvable
*/
fd_test_N(N, LT):-
    findall(T, tower(N,T,_), LT).

/* fd_test
   arguments:
   run time in ms
*/
fd_test(RT):-
    statistics(real_time, _),
    fd_test_N(0, _),
    fd_test_N(1, _),
    fd_test_N(2, _),
    fd_test_N(3, _),
    fd_test_N(4, _),
    fd_test_N(4, _),
    fd_test_N(4, _),
    fd_test_N(4, _),
    fd_test_N(4, _),
    fd_test_N(4, _),
    fd_test_N(4, _),
    fd_test_N(4, _),
    fd_test_N(4, _),
    fd_test_N(4, _),
    fd_test_N(4, _),
    fd_test_N(4, _),
    C=counts([2,3,2,1,4],[3,1,3,3,2],[4,1,2,5,2],[2,4,2,1,2]),
    tower(_, _, C),
    tower(_, _, C),
    tower(_, _, C),
    tower(_, _, C),
    tower(_, _, C),
    T=[[2,3,4,5,1],[5,4,1,3,2],[4,1,5,2,3],[1,2,3,4,5],[3,5,2,1,4]],
    tower(_, T, _),
    tower(_, T, _),
    tower(_, T, _),
    tower(_, T, _),
    tower(_, T, _),
    statistics(real_time, [_, RT]).


/* speedup
   arguments:
   ratio of time taken to run plain_tower over tower
*/
speedup(R):-
    once(plain_test(PT)),
    once(fd_test(FT)),
    R is PT/FT.
    


%======================AMBIGUOUS======================

ambiguous(N, C, T1, T2):-
    tower(N,T1,C),
    tower(N,T2,C),
    T1\=T2.
