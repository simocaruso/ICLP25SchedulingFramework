#program base.
0 {x(REGID,PRI,OPROOMID,SHIFT,DAY): mss(OPROOMID,SHIFT,QUAL,DAY)} 1 :- registration(REGID,PRI,SURGDUR,_,QUAL,_,_).
:- #sum{SURGDUR, REGID: x(REGID,PRI,OPROOMID,SHIFT,_), registration(REGID,PRI,SURGDUR,_,QUAL,_,_)} > shift_duration-1, mss(OPROOMID,SHIFT,_,_).
:- registration(REGID,1,_,_,_,_,_), not x(REGID,1,_,_,_).
:~ M = #count {REGID: x(REGID,2,_,_,_)}. [totRegsP2 - M@3]
:~ M = #count {REGID: x(REGID,3,_,_,_)}. [totRegsP3 - M@2]

#program sub.
{y(REGID,PRI,SRGID,ANID,OPROOMID,SHIFT,DAY,TS): surgeon(SRGID,QUAL,SHIFT), an(ANID,QUAL,SHIFT), time(SHIFT,TS), TS+SURGDUR <= shift_duration} = 1 :- x(REGID,PRI,OPROOMID,SHIFT,DAY), registration(REGID,PRI,SURGDUR,_,QUAL,_,_).
:- #count {REGID: y(REGID,_,_,_,OPROOMID,SHIFT,DAY,TS), registration(REGID,_,SURGDUR,_,_,_,_), T>= TS, T<TS+SURGDUR} > 1, mss(OPROOMID,SHIFT,_,DAY), time(SHIFT,T).
:- #count {REGID: y(REGID,_,SRGID,_,_,SHIFT,_,TS)} > 1, surgeon(SRGID,_,SHIFT), time(SHIFT,TS).
:- #count {REGID: y(REGID,_,SRGID,_,_,SHIFT,_,TS), registration(REGID,_,SURGDUR,_,_,_,_), T>= TS, T<TS+SURGDUR} > 1, surgeon(SRGID,_,SHIFT), time(SHIFT,T).
:- #count {REGID: y(REGID,_,_,ANID,_,SHIFT,_,TS)} > 1, an(ANID,_,SHIFT), time(SHIFT,TS).
:- #count {REGID: y(REGID,_,_,ANID,_,SHIFT,_,TS), registration(REGID,_,SURGDUR,_,_,_,_), T>= TS, T<TS+SURGDUR} > 1, an(ANID,_,SHIFT), time(SHIFT,T).
:- #sum {SURGDUR, REGID : y(REGID,_,SRGID,_,_,_,DAY,_),registration(REGID,_,SURGDUR,_,_,_,_) } > sWT, surgeryTime(sWT,SRGID,DAY).
:- #sum {SURGDUR, REGID : y(REGID,_,_,ANID,_,_,DAY,_),registration(REGID,_,SURGDUR,_,_,_,_) } > aWT, anaesthetistWT(aWT,ANID,DAY).

#program nogood(p, or, shift, day, ngid).
nogood(ngid).
unfeasible_subproblem(p, or, shift, day, ngid).
:- x(REGID,PRI,OPROOMID,SHIFT,DAY) : registration(REGID,PRI,_,_,_,_,_), unfeasible_subproblem(REGID,OPROOMID,SHIFT,DAY,NGID); nogood(NGID), NGID=ngid.

#show x/5.
#show y/8.
