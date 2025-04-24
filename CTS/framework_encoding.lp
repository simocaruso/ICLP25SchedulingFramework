#program base.
#const chair_total_time = 71.
#const bed_total_time = 71.
{x(REGID,DAY,PH4,0,S): day(DAY)} = 1 :- reg(REGID,0,_,PH4,PH3,PH2,PH1,S).
1 {bed(ID,REGID,DAY): bed(ID); chair(ID,REGID,DAY): chair(ID) } 1 :- x(REGID,DAY,_,_,_).
:- #sum{PH4, REGID: x(REGID,DAY,PH4,_,_), chair(ID,REGID,DAY)} > chair_total_time, day(DAY), chair(ID).
:- #sum{PH4, REGID: x(REGID,DAY,PH4,_,_), bed(ID,REGID,DAY)} > bed_total_time, day(DAY), bed(ID).
:~ x(REGID,DAY,_,_,1), chair(_,REGID,DAY). [1@4,REGID]
:~ x(REGID,DAY,_,_,0), bed(_,REGID,DAY). [1@4,REGID]
numbReg(DAY,TOT) :- TOT = #count{REGID: x(REGID,DAY,_,_,_)}, day(DAY).
numMax(DAY,MAX) :- MAX = #max{N: numbReg(DAY,N)}, day(DAY).
bound(N_PAT/N_DAYS) :- N_PAT = #count{REGID: reg(REGID,_,_,_,_,_,_,_)}, N_DAYS = #count{DAY: day(DAY)}, N_PAT \ N_DAYS = 0.
bound(N_PAT/N_DAYS+1) :- N_PAT = #count{REGID: reg(REGID,_,_,_,_,_,_,_)}, N_DAYS = #count{DAY: day(DAY)}, N_PAT \ N_DAYS != 0.
:~ numMax(DAY,M), bound(B), M-B > 0. [M-B@3,DAY]


#program timeslot.
{y(REGID,DAY,TS,PH4,0,S): ts(TS) } = 1 :- x(REGID,DAY,PH4,0,S).
{y(REGID,DAY+DAY2,TS,PH4,ORD,S): ts(TS)} = 1 :- x(REGID,DAY,_,N,_), reg(REGID,ORD,DAY2,PH4,PH3,PH2,PH1,S),ORD=N+1,day(DAY+DAY2).
:- y(REGID,DAY,TS,PH4,_,_), PH4 > 50, TS < 24.
:- y(REGID,DAY,TS,_,ORD,_), reg(REGID,ORD,_,_,PH3,PH2,PH1,S), TS-PH3-PH2-PH1<1.
res(REGID,DAY,TS..TS+PH4-1) :- y(REGID,DAY,TS,PH4,_,_), PH4>0.
chair(ID,REGID,DAY,TS) :- chair(ID,REGID,DAY), res(REGID,DAY,TS).
:-#count{REGID: chair(ID,REGID,DAY,TS)} > 1, chair(ID), day(DAY), ts(TS).
bed(ID,REGID,DAY,TS) :- bed(ID,REGID,DAY), res(REGID,DAY,TS).
:-#count{REGID: bed(ID,REGID,DAY,TS)} > 1, bed(ID), day(DAY), ts(TS).
support(REGID,DAY,TS) :- y(REGID,DAY,PH4,_,_,_), reg(REGID,ORD,_,_,PH3,PH2,_,_), PH2>0, PH4-PH3-PH2=TS, ats(TS).
numbReg(DAY,N,TS) :- N = #count{REGID: support(REGID,DAY,TS)}, day(DAY), ats(TS).
numMax(DAY,T) :- T = #max{N: numbReg(DAY,N,_)}, day(DAY).
numMin(DAY,T) :- T = #min{N: numbReg(DAY,N,_), N != 0}, day(DAY).
:~ numMax(DAY,M). [M@3,DAY]
:~ numMax(DAY,M), numMin(DAY,N), M-N > 0. [M-N@2]


#program nogood(p, d, ngid, bed, chair).
nogood(ngid).

unfeasable_subproblem_bed(p,1..5,ngid) :- bed = 1.
unfeasable_subproblem_chair(p,1..5,ngid) :- chair = 1.

nogood_bed(NGID,D) :- bed(_,X,D) : unfeasable_subproblem_bed(X,D,NGID); D=1, NGID=ngid.
nogood_bed(NGID,D) :- bed(_,X,D) : unfeasable_subproblem_bed(X,D,NGID); D=2, NGID=ngid.
nogood_bed(NGID,D) :- bed(_,X,D) : unfeasable_subproblem_bed(X,D,NGID); D=3, NGID=ngid.
nogood_bed(NGID,D) :- bed(_,X,D) : unfeasable_subproblem_bed(X,D,NGID); D=4, NGID=ngid.
nogood_bed(NGID,D) :- bed(_,X,D) : unfeasable_subproblem_bed(X,D,NGID); D=5, NGID=ngid.

nogood_chair(NGID,D) :- chair(_,X,D) : unfeasable_subproblem_chair(X,D,NGID); D=1, NGID=ngid.
nogood_chair(NGID,D) :- chair(_,X,D) : unfeasable_subproblem_chair(X,D,NGID); D=2, NGID=ngid.
nogood_chair(NGID,D) :- chair(_,X,D) : unfeasable_subproblem_chair(X,D,NGID); D=3, NGID=ngid.
nogood_chair(NGID,D) :- chair(_,X,D) : unfeasable_subproblem_chair(X,D,NGID); D=4, NGID=ngid.
nogood_chair(NGID,D) :- chair(_,X,D) : unfeasable_subproblem_chair(X,D,NGID); D=5, NGID=ngid.

:- nogood_bed(NGID,D), nogood_chair(NGID,D).

#show x/5.
#show y/6.
#show bed/3.
#show chair/3.
