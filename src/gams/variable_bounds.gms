$title variable_bounds
$ontext
set bounds on variables.
$offtext

* global bounds independent of any decomposition algorithm
genPlCoeffVar.lo(i,j,i1)$GenPl(i,j,i1) = 0;
busVoltMagVar.up(i)$Bus(i) = BusVMax(i);
busVoltMagVar.lo(i)$Bus(i) = BusVMin(i);
busPowRealBalanceOverViolVar.lo(i)$Bus(i) = 0;
busPowRealBalanceUnderViolVar.lo(i)$Bus(i) = 0;
busPowImagBalanceOverViolVar.lo(i)$Bus(i) = 0;
busPowImagBalanceUnderViolVar.lo(i)$Bus(i) = 0;
genPowRealVar.up(i,j)$GenActive(i,j) = GenPMax(i,j);
genPowRealVar.lo(i,j)$GenActive(i,j) = GenPMin(i,j);
genPowImagVar.up(i,j)$GenActive(i,j) = GenQMax(i,j);
genPowImagVar.lo(i,j)$GenActive(i,j) = GenQMin(i,j);
lineCurrMag1BoundViolVar.lo(i1,i2,j)$LineActive(i1,i2,j) = 0;
lineCurrMag2BoundViolVar.lo(i1,i2,j)$LineActive(i1,i2,j) = 0;
xfmrPowMag1BoundViolVar.lo(i1,i2,j)$XfmrActive(i1,i2,j) = 0;
xfmrPowMag2BoundViolVar.lo(i1,i2,j)$XfmrActive(i1,i2,j) = 0;
swshAdmImagVar.up(i)$SwshActive(i) = SwshBMax(i);
swshAdmImagVar.lo(i)$SwshActive(i) = SwshBMin(i);
busCtgVoltMagVar.up(i,k)$(Bus(i) and Ctg(k)) = BusVMax(i);
busCtgVoltMagVar.lo(i,k)$(Bus(i) and Ctg(k)) = BusVMin(i);
busCtgPowRealBalanceOverViolVar.lo(i,k)$(Bus(i) and Ctg(k)) = 0;
busCtgPowRealBalanceUnderViolVar.lo(i,k)$(Bus(i) and Ctg(k)) = 0;
busCtgPowImagBalanceOverViolVar.lo(i,k)$(Bus(i) and Ctg(k)) = 0;
busCtgPowImagBalanceUnderViolVar.lo(i,k)$(Bus(i) and Ctg(k)) = 0;
#genCtgPowRealVar.up(i,j,k)$GenCtgActive(i,j,k) = GenPMax(i,j);
#genCtgPowRealVar.lo(i,j,k)$GenCtgActive(i,j,k) = GenPMin(i,j);
genCtgPowImagVar.up(i,j,k)$GenCtgActive(i,j,k) = GenQMax(i,j);
genCtgPowImagVar.lo(i,j,k)$GenCtgActive(i,j,k) = GenQMin(i,j);
lineCtgCurrMag1BoundViolVar.lo(i1,i2,j,k)$LineCtgActive(i1,i2,j,k) = 0;
lineCtgCurrMag2BoundViolVar.lo(i1,i2,j,k)$LineCtgActive(i1,i2,j,k) = 0;
xfmrCtgPowMag1BoundViolVar.lo(i1,i2,j,k)$XfmrCtgActive(i1,i2,j,k) = 0;
xfmrCtgPowMag2BoundViolVar.lo(i1,i2,j,k)$XfmrCtgActive(i1,i2,j,k) = 0;
swshCtgAdmImagVar.up(i,k)$(SwshActive(i) and Ctg(k)) = SwshBMax(i);
swshCtgAdmImagVar.lo(i,k)$(SwshActive(i) and Ctg(k)) = SwshBMin(i);
genCtgPowRealOverVar.lo(i,j,k)$genCtgParticipating(i,j,k) = 0;
genCtgPowRealUnderVar.lo(i,j,k)$genCtgParticipating(i,j,k) = 0;
busCtgVoltMagOverVar.lo(i,k)$BusCtgVoltMagMaintDom(i,k) = 0;
busCtgVoltMagUnderVar.lo(i,k)$BusCtgVoltMagMaintDom(i,k) = 0;
