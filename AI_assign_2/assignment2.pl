:- [dist]. 

add_to_Closed(H1, [H|L1], [H|L2]) :- add_to_Closed(H1, L1, L2).
add_to_Closed(H, [H|L], [H|L]).
add_to_Closed(H, [], [H]).

member_Closed(H, [H1|L]) :- dif(H,H1), member_Closed(H, L).
member_Closed(H, [H|_]).

best-first(Source, Goal) :- Closed = [],heuristic_value(Source, Goal, H),node(Source, nil, H, Curr_Node), insert_priority_queue(Curr_Node, [], Open),bestfirst(Open, Closed, Goal).

bestfirst(Open,_,_) :- Open = [],write("Nodes are not connected").

bestfirst(Open, Closed, Goal) :- remove_priority_queue(Curr_Node, Open, _), node(State, _, _, Curr_Node), State = Goal, write('The path from source to goal is:'), nl, print_path(Curr_Node, Closed,Soln),write("The cost is: "),find_dist(Soln,Cost),write(Cost),nl.

bestfirst(Open, Closed, Goal) :- remove_priority_queue(Curr_Node, Open, Rest_of_open), findall(Child, list_children(Curr_Node, Open, Closed, Child, Goal), Allchildnodes), insert_list_to_queue(Allchildnodes, Rest_of_open, New_open), add_to_Closed(Curr_Node, Closed, New_closed), bestfirst(New_open, New_closed, Goal),!.
    
list_children(Curr_Node, Open, Closed,Child, Goal) :- node(State, _,_, Curr_Node), edge(State, Next), node(Next, _, _, Test), not(member_priority_queue(Test, Open)), not(member_Closed(Test, Closed)), heuristic_value(Next, Goal, H), node(Next, State, H, Child).

insert_priority_queue(State, [H|T], [H | T_new]) :- insert_priority_queue(State, T, T_new). 
insert_priority_queue(State, [H | T], [State, H | T]) :- comes_before(State, H).
insert_priority_queue(State, [], [State]).

member_priority_queue(E, S) :- member(E, S).
    
remove_priority_queue(First, [First|Rest], Rest).

node(State, Parent, H, [State, Parent, H]).
comes_before([_,_,H1], [_,_,H2]) :- H1 =< H2.  

insert_list_to_queue([State | Tail], L, New_L) :- insert_priority_queue(State, L, L2), insert_list_to_queue(Tail, L2, New_L).
insert_list_to_queue([], L, L).

print_path(Next_record, _,[State]):- node(State, nil,_, Next_record), write(State), nl.

print_path(Next_record, Closed,[State|L]) :- node(State, Parent, _, Next_record), node(Parent, _,_, Parent_record), member_Closed(Parent_record, Closed), print_path(Parent_record, Closed,L), write(State), nl.

solve(Node, Goal) :- depthfirst([], Node, Goal, Solution), write("The path from source to Goal is:"),nl, reverse(Solution, Solution1), print_sol(Solution1),nl,write("The cost is: "),find_dist(Solution1,Cost),write(Cost),nl, !.

depthfirst(Path, Node, Node, [Node|Path]).

depthfirst(Path, Node,Goal, Sol) :- dif(Goal,Node), edge(Node, Node1), not(member_Closed(Node1, Path)), depthfirst([Node|Path], Node1,Goal, Sol).

print_sol([H|List]):- write(H),nl,print_sol(List).
print_sol([]).

find_dist([H1,H2|L], Z):- find_dist([H2|L],Y),dists(H1,H2,X),Z is X+Y.
find_dist([_],0).
find_dist([],0).

edge(X,Y) :- dists(X,Y,_).
heuristic_value(S,_,E) :- findall(X,dists(S,_,X),Bag), min_list(Bag,E).

final_solution() :- write("Do you want to proceed with dfs(y/n)."), nl,read(Y),Y=y,!, write("Input Source"),nl,read(X), write("Input Goal"),nl,read(Y1), solve(X,Y1).

final_solution() :- write("Do you want to proceed with best-first(y/n)."), nl,read(Y),Y=y,!, write("Input Source"),nl,read(X), write("Input Goal"),nl,read(Y1), best-first(X,Y1).


