registration(1000,2,1,10,1,0,1). registration(1001,3,3,9,1,0,1). registration(1002,1,2,8,1,0,1). registration(1003,1,3,11,1,0,1). registration(1004,3,3,10,1,0,1). registration(1005,3,1,9,1,0,1). registration(1006,3,3,9,1,0,1). registration(1007,2,1,10,1,0,1). registration(1008,2,3,9,1,0,1). registration(1009,1,2,8,1,0,1). registration(1010,1,3,8,1,0,1). registration(1011,2,3,5,1,0,1). registration(1012,3,3,10,1,0,1). registration(1013,3,2,7,1,0,1). registration(1014,2,2,9,1,0,1). registration(1015,3,3,7,1,0,1). registration(2000,2,2,8,2,0,1). registration(2001,2,1,12,2,0,1). registration(2002,3,2,10,2,0,1). registration(2003,2,1,8,2,0,1). registration(2004,3,1,11,2,0,1). registration(2005,2,1,7,2,1,1). registration(2006,3,1,8,2,0,1). registration(2007,3,1,9,2,0,1). registration(2008,2,2,12,2,0,1). registration(2009,3,1,9,2,0,1). registration(2010,2,2,9,2,0,1). registration(2011,2,2,7,2,0,1). registration(2012,2,2,10,2,0,1). registration(2013,2,1,9,2,2,1). registration(3000,2,2,10,3,0,1). registration(3001,3,2,12,3,0,1). registration(3002,1,2,7,3,0,1). registration(3003,2,2,17,3,0,1). registration(3004,1,3,9,3,0,1). registration(3005,3,2,11,3,0,1). registration(3006,2,2,12,3,1,1). registration(3007,1,2,14,3,0,1). registration(3008,1,2,9,3,0,1). registration(3009,3,2,11,3,0,1). registration(3010,3,2,14,3,0,1). registration(3011,3,2,7,3,0,1). registration(3012,3,2,12,3,0,1). registration(3013,3,2,11,3,0,1). registration(4000,3,2,8,4,0,0). registration(4001,1,1,7,4,0,0). registration(4002,1,2,8,4,0,0). registration(4003,2,2,6,4,0,0). registration(4004,3,1,6,4,0,0). registration(4005,1,2,5,4,0,0). registration(4006,3,2,6,4,0,0). registration(4007,3,2,8,4,0,0). registration(4008,2,2,6,4,0,0). registration(4009,2,2,5,4,0,0). registration(4010,2,1,7,4,0,0). registration(4011,3,2,7,4,0,0). registration(5000,3,2,2,5,0,0). registration(5001,3,1,1,5,0,0). registration(5002,2,2,1,5,0,0). registration(5003,2,2,3,5,0,0). registration(5004,3,2,5,5,0,0). registration(5005,3,2,3,5,0,0). registration(5006,2,2,3,5,0,0). registration(5007,3,2,4,5,0,0). registration(5008,1,2,2,5,0,0). registration(5009,2,2,3,5,0,0). registration(5010,2,2,2,5,0,0). registration(5011,2,1,3,5,0,0). registration(5012,3,1,3,5,2,0). registration(5013,2,2,3,5,0,0). #const totRegsP1 = 12. #const totRegsP2 = 28. #const totRegsP3 = 30. 

%*mss(1-day)*%
mss(1,1,1,1). mss(1,2,1,1). mss(2,1,1,1). mss(2,2,1,1). mss(3,1,1,1). mss(3,2,1,1). mss(4,1,2,1). mss(4,2,2,1). mss(5,1,2,1). mss(5,2,2,1). mss(6,1,3,1). mss(6,2,3,1). mss(7,1,3,1). mss(7,2,3,1). mss(8,1,4,1). mss(8,2,4,1). mss(9,1,5,1). mss(9,2,5,1). mss(10,1,5,1). mss(10,2,5,1).

#const shift_duration = 5.

%time predicate with 5slots
% time(SHIFT,ST)
time(1,1..5). time(2,1..5).

% config (1)
%*surgeons (20) *%
%surgeon(SRGID,SPECID,SHIFT),(1-day) 
surgeon(10,1,1). surgeon(11,1,1). surgeon(12,1,1). surgeon(13,1,2). surgeon(14,1,2). surgeon(15,1,2).
surgeon(21,2,1). surgeon(22,2,1). surgeon(23,2,2). surgeon(24,2,2).  
surgeon(31,3,1). surgeon(32,3,1). surgeon(33,3,2). surgeon(34,3,2).
surgeon(41,4,1). surgeon(42,4,2).
surgeon(51,5,1). surgeon(52,5,1). surgeon(53,5,2). surgeon(54,5,2).

% work time for surgeons
%*surgeryTime(sWT,SRID,DAY),(1-day) *%
#const sWT = 4.
surgeryTime(sWT,10,1). surgeryTime(sWT,11,1).surgeryTime(sWT,12,1).surgeryTime(sWT,13,1).surgeryTime(sWT,14,1).surgeryTime(sWT,15,1).
surgeryTime(sWT,21,1). surgeryTime(sWT,22,1).surgeryTime(sWT,23,1).surgeryTime(sWT,24,1).
surgeryTime(sWT,31,1). surgeryTime(sWT,32,1).surgeryTime(sWT,33,1).surgeryTime(sWT,34,1).
surgeryTime(sWT,41,1). surgeryTime(sWT,42,1).
surgeryTime(sWT,51,1). surgeryTime(sWT,52,1).surgeryTime(sWT,53,1). surgeryTime(sWT,54,1).

%*Anaesthetists(20), an(ANID,SPECID,SHIFT), (1-Day)*%
an(11,1,1). an(12,1,1). an(13,1,1). an(14,1,1). an(15,1,1). an(16,1,1). an(11,1,2). an(12,1,2). an(13,1,2). an(14,1,2). an(15,1,2). an(16,1,2).
an(21,2,1). an(22,2,1). an(23,2,1). an(24,2,1). an(21,2,2). an(22,2,2). an(23,2,2). an(24,2,2).
an(31,3,1). an(32,3,1). an(33,3,1). an(34,3,1). an(31,3,2). an(32,3,2). an(33,3,2). an(34,3,2).
an(41,4,1). an(42,4,1). an(41,4,2). an(42,4,2). 
an(51,5,1). an(52,5,1). an(53,5,1). an(54,5,1).an(51,5,2). an(52,5,2). an(53,5,2). an(54,5,2).

% work time for anaesthetists
%*anaesthetistWT(aWT,ANID,DAY),(1-day)*%
#const aWT = 6.
anaesthetistWT(aWT,11,1).anaesthetistWT(aWT,12,1).anaesthetistWT(aWT,13,1).anaesthetistWT(aWT,14,1). anaesthetistWT(aWT,15,1).anaesthetistWT(aWT,16,1).
anaesthetistWT(aWT,21,1).anaesthetistWT(aWT,22,1).anaesthetistWT(aWT,23,1).anaesthetistWT(aWT,24,1).
anaesthetistWT(aWT,31,1).anaesthetistWT(aWT,32,1).anaesthetistWT(aWT,33,1).anaesthetistWT(aWT,34,1).
anaesthetistWT(aWT,41,1).anaesthetistWT(aWT,42,1).
anaesthetistWT(aWT,51,1).anaesthetistWT(aWT,52,1).anaesthetistWT(aWT,53,1).anaesthetistWT(aWT,54,1).