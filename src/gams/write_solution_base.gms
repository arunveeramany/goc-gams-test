$title write_solution_base
$ontext
write solution1.txt file for
base case solution values
$offtext

$if not set solution1 $set solution1 solution1.txt

file solution1 /'%solution1%'/;

put solution1;
put '--bus section' /;
put 'I, VM, VA' /;
loop(i$Bus(i),
  put
    i.tl:0 ', '
    busVoltMagSol(i):0:10 ', '
    busVoltAngSol(i):0:10 /;
);
put '--generator section' /;
put 'I, ID, P, Q' /;
loop((i,j)$Gen(i,j),
  put
    i.tl:0 ', '
    j.tl:0 ', '
    genPowRealSol(i,j):0:10 ', '
    genPowImagSol(i,j):0:10 /;
);
put '--switched shunt section' /;
put 'I, B' /;
loop(i$Swsh(i),
  put
    i.tl:0 ', '
    swshAdmImagSol(i):0:10 /;
);
putclose;
