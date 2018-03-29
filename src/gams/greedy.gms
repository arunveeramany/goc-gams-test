$title greedy
$ontext
Run a greedy huristic algorithm.
This should return a feasible solution unless the data contains trivial bound errors.
The solution obtained in this way may make extensive use of contraint violation variables
and thus may be far from optimal.
$offtext

VoltMagViolPen = 1e3;
PowFlowMagViolPen = 1e3;
CurrFlowMagViolPen = 1e3;
PowBalanceViolPen = 1e3;
VoltMagBoundSoft = 0;
PowFlowMagBoundSoft = 1;
CurrFlowMagBoundSoft = 1;
PowBalanceSoft = 1;

option
  limrow = 0
  limcol = 0
  solprint = off
  nlp = knitro # knitro, ipopt, ipopth
  mpec = knitro # knitro, nlpec: NLP reformulation of equilibrium constraints
;

* nlpec options file
$onecho > nlpec.opt
* knitro, ipopt
subsolver knitro
subsolveropt 1
initmu 1e-2
*finalmu 0.0
*numsolves 1
aggregate full
$offecho

* nlpec options file 2
$onecho > nlpec.op2
* knitro, ipopt
subsolver knitro
subsolveropt 1
initmu 1e-2
finalmu 0.0
numsolves 4
aggregate full
$offecho

* knitro options file
$onecho > knitro.opt
* 1: barrier/direct, 2: barrier/cg (lower memory, slower - too slow in base case and in some contingencies)
algorithm 1
*feastol 1e-8 # keep default
# might want to play with opttol, ftol, ftol_iters in order to terminate with a suboptimal solution more quickly
*opttol 1e-3
*ftol 1e-5
*ftol_iters 3
*pivot 1e-12 # not good, just use default
maxcgit 10
* 1: exact hessian from GAMS, 6: L-BFGS (maybe lower memory? seems slower and lower quality solution)
hessopt 1

* penalty/relaxation approach to constraints
* if penalties are explicitly formulated in the model
* then it may be good to prevent Knitro from adding new penalties
* if penalties are not explicitly formulated in the model
* then we may need to tell Knitro to add them
*bar_feasible 3 # not good - just use default
*bar_pencons 1
*bar_penaltycons 2
*bar_penaltyrule
bar_relaxcons 0 # default is 2 - relax inequalities. 0 says no relaxation

*bar_initpi_mpec 1e-3 # mpec smoothing parameter (?) - maybe want to drive this to 0
secret 1093 x 1e-4
$offecho

* knitro options file 2
$onecho > knitro.op2
*secret 1093 x 0.0
$offecho

* ipopt options file
$onecho > ipopt.opt
$offecho

subModelBase.optfile = 1;
subModelCtg.optfile = 1;

file
  LogDetailed /'log_detailed.txt'/
  LogFile /'log.txt'/;

* setup log files
LogDetailed.ap = 0;
put LogDetailed;
put 'Grid Optimization Competition' /;
put 'algorithm detailed log' /;
put 'Ctg, Time, MaxInfeas, MaxCompViol, MaxSoftViol' /;
putclose;
LogDetailed.ap = 1;
LogFile.ap = 0;
put LogFile;
put 'Grid Optimization Competition' /;
put 'algorithm log' /;
put 'Time, MaxInfeasBase, MaxSoftViol, MaxInfeasCtg, MaxCompViolCtg, MaxSoftViolCtg' /;
putclose;
LogFile.ap = 1;

* initialization
#GenPowReal(i,j)$GenActive(i,j) = 0;
GenPowRealCoeff1(i,j)$GenActive(i,j) = 0;
GenPowRealCoeff2(i,j)$GenActive(i,j) = 0;
#GenCtgPowRealDup(i,j,k)$GenCtgActive(i,j,k) = 0;
#GenCtgPowRealMult(i,j,k)$GenCtgActive(i,j,k) = 0;
BusVoltMag(i)$Bus(i) = max(BusVMin(i),min(BusVMax(i),1.0));
BusVoltMagCoeff1(i)$Bus(i) = 0;
BusVoltMagCoeff2(i)$Bus(i) = 0;
BusCtgVoltMag(i,k)$(Bus(i) and Ctg(k)) = BusVoltMag(i);
CtgActive(k)$Ctg(k) = no;

* variable initialization
BusVoltMagVar.l(i)$Bus(i) = BusVoltMag(i);
BusCtgVoltMagVar.l(i,k)$(Bus(i) and Ctg(k)) = BusCtgVoltMag(i,k);

* iterations
put LogDetailed;
put 'main iterations' /;
putclose;
put LogFile;
put 'main iterations' /;
putclose;

# step 1 subproblem solve
solve subModelBase using nlp minimizing objVar;
MaxInfeas = subModelBase.maxinfes;

# process solution
$include solution_evaluation_base.gms
#GenPowReal(i,j)$GenActive(i,j) = GenPowRealVar.l(i,j);
#BusVoltMag(i)$Bus(i) = BusVoltMagVar.l(i);

# write solution1
$include convert_solution.gms
$include write_solution_1.gms

# write to log

# fix some complementarities
genCtgPowRealOverVar.fx(i,j,k)$genCtgActive(i,j,k) = 0;
genCtgPowRealUnderVar.fx(i,j,k)$genCtgActive(i,j,k) = 0;
busCtgVoltMagOverVar.fx(i,k)$(Bus(i) and Ctg(k)) = 0;
busCtgVoltMagUnderVar.fx(i,k)$(Bus(i) and Ctg(k)) = 0;
#genCtgPowRealVar.fx(i,j,k)$GenCtgPowRealFixLo(i,j,k) = GenPMin(i,j);
#genCtgPowRealVar.fx(i,j,k)$GenCtgPowRealFixUp(i,j,k) = GenPMax(i,j);
#genCtgPowImagVar.fx(i,j,k)$GenCtgPowImagFixLo(i,j,k) = GenQMin(i,j);
#genCtgPowImagVar.fx(i,j,k)$GenCtgPowImagFixUp(i,j,k) = GenQMax(i,j);

# loop over contingencies to solve decomposable step 2 subproblem
loop(k0$Ctg(k0),

  CtgActive(k) = no;
  CtgActive(k0) = yes;
  GenPowRealVar.fx(i,j)$GenActive(i,j) = GenPowReal(i,j);
  BusVoltMagVar.fx(i)$Bus(i) = BusVoltMag(i);
  solve subModelCtg using nlp minimizing objVar;
  CtgMaxInfeas(k0) = subModelCtg.maxinfes;
  CtgMaxCompViol(k0) = max(
    smax((i,j)$GenCtgParticipating(i,j,k0),
        min(genCtgPowRealOverVar.l(i,j,k0), 
            genCtgPowRealVar.l(i,j,k0) - GenPMin(i,j))),
    smax((i,j)$GenCtgParticipating(i,j,k0),
        min(genCtgPowRealUnderVar.l(i,j,k0), 
            GenPMax(i,j) - genCtgPowRealVar.l(i,j,k0))),
    smax(i$BusCtgVoltMagMaintDom(i,k0),
        min(busCtgVoltMagOverVar.l(i,k0),
	    sum((i1,j1)$GenBusCtgVoltMagMaintDom(i1,j1,i,k0),
	        genCtgPowImagVar.l(i1,j1,k0) - GenQMin(i1,j1)))),
    smax(i$BusCtgVoltMagMaintDom(i,k0),
        min(busCtgVoltMagUnderVar.l(i,k0),
	    sum((i1,j1)$GenBusCtgVoltMagMaintDom(i1,j1,i,k0),
	        GenQMax(i1,j1) - genCtgPowImagVar.l(i1,j1,k0)))));
  CtgMaxSoftViol(k0) = max(
    smax(i$Bus(i),
         busCtgPowRealBalanceOverViolVar.l(i,k0))$PowBalanceSoft,
    smax(i$Bus(i),
         busCtgPowRealBalanceUnderViolVar.l(i,k0))$PowBalanceSoft,
    smax(i$Bus(i),
         busCtgPowImagBalanceOverViolVar.l(i,k0))$PowBalanceSoft,
    smax(i$Bus(i),
         busCtgPowImagBalanceUnderViolVar.l(i,k0))$PowBalanceSoft,
    smax((i1,i2,j)$LineCtgActive(i1,i2,j,k0),
         lineCtgCurrMag1BoundViolVar.l(i1,i2,j,k0))$CurrFlowMagBoundSoft,
    smax((i1,i2,j)$LineCtgActive(i1,i2,j,k0),
         lineCtgCurrMag2BoundViolVar.l(i1,i2,j,k0))$CurrFlowMagBoundSoft,
    smax((i1,i2,j)$XfmrCtgActive(i1,i2,j,k0),
         xfmrCtgPowMag1BoundViolVar.l(i1,i2,j,k0))$PowFlowMagBoundSoft,
    smax((i1,i2,j)$XfmrCtgActive(i1,i2,j,k0),
         xfmrCtgPowMag2BoundViolVar.l(i1,i2,j,k0))$PowFlowMagBoundSoft);

  put LogDetailed;
  put
    k0.tl:0:0 ', '
    timeelapsed:0:0 ', '
    CtgMaxInfeas(k0):0:10 ', '
    CtgMaxCompViol(k0):0:10 ', '
    CtgMaxSoftViol(k0):0:10 /;
  putclose;
);

# log entry
put LogFile;
put
  timeelapsed:0:0 ', '
  MaxInfeas:0:10 ', '
  max(
    smax(i$Bus(i),
         busPowRealBalanceOverViolVar.l(i))$PowBalanceSoft,
    smax(i$Bus(i),
	 busPowRealBalanceUnderViolVar.l(i))$PowBalanceSoft,
    smax(i$Bus(i),
	 busPowImagBalanceOverViolVar.l(i))$PowBalanceSoft,
    smax(i$Bus(i),
	 busPowImagBalanceUnderViolVar.l(i))$PowBalanceSoft,
    smax((i1,i2,j)$LineActive(i1,i2,j),
         lineCurrMag1BoundViolVar.l(i1,i2,j))$CurrFlowMagBoundSoft,
    smax((i1,i2,j)$LineActive(i1,i2,j),
         lineCurrMag2BoundViolVar.l(i1,i2,j))$CurrFlowMagBoundSoft,
    smax((i1,i2,j)$XfmrActive(i1,i2,j),
         xfmrPowMag1BoundViolVar.l(i1,i2,j))$PowFlowMagBoundSoft,
    smax((i1,i2,j)$XfmrActive(i1,i2,j),
         xfmrPowMag2BoundViolVar.l(i1,i2,j))$PowFlowMagBoundSoft):0:10 ', '
  smax(k$Ctg(k), CtgMaxInfeas(k)):0:10 ', '
  smax(k$Ctg(k), CtgMaxCompViol(k)):0:10 ', '
  smax(k$Ctg(k), CtgMaxSoftViol(k)):0:10 /;
putclose;

