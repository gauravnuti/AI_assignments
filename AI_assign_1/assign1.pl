field('Data science','Data Scientist').
field('Ml research','ML Researcher').
field('VLSI research','VLSI Researcher').
field('HCI','HCI Researcher').
field('Operating Systems','Systems Researcher').
field('Algorithm research', 'Algorithm Researcher').
field('Cryptography research', 'Cryptography Researcher').

branch_subjects('Data Scientist', ['DS(Data Science)', 'DBMS']).
branch_subjects('Security engineer', ['FCS(Foundation of computer security)',
 'SE(Security Engineering)', 'NS(Network Security)']).
branch_subjects('Game Developer', ['CG(Computer Graphics)',
 'GDD(Game Developement and Design)']).
branch_subjects('Sys Admin', ['SM(Systems Management)',
 'OS(Operating Systems)']).
branch_subjects('Financial analyst', ['Microeconomics', 'PS(Probability and Statistics)'
, 'FF(Foundation of Finance)']).
branch_subjects('Social Scientist', ['Sociology', 'Econometrics']).
branch_subjects('UI UX Developer', ['MC(Mobile Computing)', 'ID(Introduction to Design)']).

external_avenues('Internships').
external_avenues('GSOCs').
external_avenues('Fellowships').

external('Internships', 'Data Science', 'Data Scientist').
external('Internships', 'Computer Security', 'Security engineer').
external('Internships', 'Database', 'Database Adminstrator').
external('Internships', 'Backend Developement', 'Backend Developer').
external('Internships', 'UI UX Developement', 'UI UX Developer').
external('GSOCs', 'Data Science', 'Data Scientist').
external('GSOCs', 'Operating Systems', 'Systems engineer').
external('GSOCs', 'UI UX Developement', 'UI UX Developer').
external('GSOCs', 'Unit Testing', 'Quality Tester').
external('GSOCs', 'Game Developement', 'Game Developer').
external('Fellowships', 'Algorithm research', 'Algorithm Researcher').
external('Fellowships', 'Operating Systems','Systems Researcher').
external('Fellowships', 'HCI','HCI Researcher').
external('Fellowships', 'VLSI research','VLSI Researcher').
external('Fellowships', 'Ml research','ML Researcher').

get_rank(Y):- retract(rank(X)), Y is X+1, assert(rank(Y)).

add_job(X,Y):- retract(job_record(X,Z)),!,D is (1000/Y)+Z, assert(job_record(X,D)).
add_job(X,Y):- D is (1000/Y), assert(job_record(X,D)).

btp(_) :- write('Did you do a BTP?'),nl,read(Y), Y=y.

btp_subj(X, Y1):- field(X,Y1), write('Did you do a btp in '),write(X),nl, read(Y), Y=y,!,
write('Did you like it?'),nl,read(Y2),Y2 =y .

base_job(_,Rank) :- write('Did you get >=8 in all CSE core courses'),nl, read(Y), Y=y, 
assert(found_job('Software Developer','Has the neccesary core CSE skills.')),add_job('Software Developer',Rank),assert(curr(Rank)),fail.

branch_job(X, Rank) :- branch_subjects(X, L), write('Did you do >= 2 in the following coures and get >=8 gpa in them? Courses: ')
, write_courses(L),nl, read(Y), Y=y,
assert(found_job(X,'Has done the neccesary coures.')),add_job(X,Rank),assert(curr(Rank)),fail.

write_courses([H|L]):- write(H),write(" "), write_courses(L).
write_courses([]).

external_job(X,Rank) :- write('Did you do one or more than one '), write(X), nl, read(Ans), Ans=y,
external(X, Y, Z), write('Did you do it in '), write(Y), nl, read(Ans1), Ans1 = y, 
atom_concat('Has done a ',X, Re),assert(found_job(Z,Re)),add_job(Z,Rank),assert(curr(Rank)),fail.

job(_) :- retract(rank(_)), fail.
job(_) :- assert(rank(0)), fail.
job(X) :- get_rank(Y),btp(_),btp_subj(X, Y1), assert(found_job(Y1,'Has done BTP in the subject and liked it.')),
assert(curr(Y)),add_job(Y1,Y),fail.
job(X) :- get_rank(Y),nl,branch_job(X, Y).
job(X) :- get_rank(Y),nl, external_avenues(X), external_job(X, Y).
job(_) :- get_rank(Y),base_job(_,Y).
job(_) :- get_job_score(L),keysort(L, L1),reverse(L1, L2),nl,result(L2).
result([]):-write('At present none of the jobs seem suitable try building up your resume.').
result(L2):-
write('The following are the job suggestions displayed in an order from most to least appropriate:'),
nl,print_jobs(L2,1).
/*job(_) :- find_list(L1,L2,L3), write_l(L1,L2,L3).*/


get_job_score([H2-[H1] | L]) :- retract(job_record(H1, H2)), get_job_score(L).
get_job_score([]).

find_job_reasons(H1, [H2 | L]):- retract(found_job(H1,H2)), find_job_reasons(H1, L).
find_job_reasons(_, []).

print_l([H1|L], Y, Cur):- write(Cur),write('.'),write(Y), write(': '), write(H1), nl, D is Y+1,
print_l(L, D, Cur).
print_l([], _, _).

print_jobs([_-[H1] | L],Rank):- write(Rank),write(')'),write(H1),
write(' due to the following reasons: '), nl,
find_job_reasons(H1, L1), print_l(L1,1,Rank),nl, D is Rank+1, print_jobs(L, D).
print_jobs([],_).

find_list([H1|L1], [H2|L2], [H3|L3]) :- retract(found_job(H1,H2)), retract(curr(H3)),find_list(L1, L2, L3).
find_list([],[],[]).

write_l([H1| L1], [H2| L2], [H3|L3]) :- write('Rank level: '), write(H3), write(" "),
write(H1), write(" "), write(H2), nl, write_l(L1, L2, L3).
write_l([], [], []). 
