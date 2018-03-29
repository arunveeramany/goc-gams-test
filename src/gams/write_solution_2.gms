$title write_solution_2
$ontext
write solution2.txt file for
contingency solution values
$offtext

$if not set solution2 $set solution2 solution2.txt

file solution2 /%solution2%/;

put solution2;
put '--contingency bus section' /;
put 'CTG, I, VM, VA' /;
loop(k$Ctg(k),
  loop(i$Bus(i),
    put
      k.tl:0 ', '
      i.tl:0 ', '
      busCtgVoltMag(i,k):0:10 ', '
      busCtgVoltAng(i,k):0:10 /;
  );
);
put '--contingency generator section' /;
put 'CTG, I, ID, Q' /;
loop(k$Ctg(k),
  loop((i,j)$Gen(i,j),
    put
      k.tl:0 ', '
      i.tl:0 ', '
      j.tl:0 ', '
      genCtgPowImag(i,j,k):0:10 /;
  );
);
put '--contingency switched shunt section' /;
put 'CTG, I, B' /;
loop(k$Ctg(k),
  loop(i$Swsh(i),
    put
      k.tl:0 ', '
      i.tl:0 ', '
      swshCtgAdmImag(i,k):0:10 /;
  );
);
put '--contingency area section' /;
put 'CTG, AREA, DELTA' /;
loop(k$Ctg(k),
  loop(i$Area(i),
    put
      k.tl:0 ', '
      i.tl:0 ', '
      areaCtgPowRealChange(i,k):0:10 /;
  );
);
putclose;
