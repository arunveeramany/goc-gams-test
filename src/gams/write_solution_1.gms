$title write_solution_1
$ontext
write solution1.txt file for
base case solution values
$offtext

$if not set solution1 $set solution1 solution1.txt

file solution1 /%solution1%/;

put solution1;
put '--bus section' /;
put 'I, VM, VA' /;
loop(i$Bus(i),
  put
    i.tl:0 ', '
    busVoltMag(i):0:10 ', '
    busVoltAng(i):0:10 /;
);
put '--generator section' /;
put 'I, ID, P, Q' /;
loop((i,j)$Gen(i,j),
  put
    i.tl:0 ', '
    j.tl:0 ', '
    genPowReal(i,j):0:10 ', '
    genPowImag(i,j):0:10 /;
);
put '--switched shunt section' /;
put 'I, B' /;
loop(i$Swsh(i),
  put
    i.tl:0 ', '
    swshAdmImag(i):0:10 /;
);
putclose;
