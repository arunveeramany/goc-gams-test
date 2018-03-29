$title admm
$ontext
Run the ADMM algorithm.
$offtext

RegParam = 1e2;
MaxIter = 16;

VoltMagViolPen = 1e3;
PowFlowMagViolPen = 1e3;
CurrFlowMagViolPen = 1e3;
PowBalanceViolPen = 1e3;
VoltMagBoundSoft = 0;
PowFlowMagBoundSoft = 0;
CurrFlowMagBoundSoft = 0;
PowBalanceSoft = 1;

option
  limrow = 0
  limcol = 0
  solprint = off
  nlp = knitro # knitro, ipopt
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
* 1: barrier/direct, 2: barrier/cg (slower)
algorithm 1
*feastol 1e-8
*opttol 1e-3
*ftol 1e-3
*ftol_iters 3
pivot 1e-12
maxcgit 10

*bar_feasible 3 # not good - just use default on all of these
*bar_penaltycons 2
*bar_penaltyrule
*bar_relaxcons 3 # default is 2 - relax inequalities

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
put 'Iter, Ctg, Time, MaxInfeas, MaxCompViol, MaxSoftViol, MaxDev' /;
putclose;
LogDetailed.ap = 1;
LogFile.ap = 0;
put LogFile;
put 'Grid Optimization Competition' /;
put 'algorithm log' /;
put 'Iter, Time, MaxInfeasBase, MaxSoftViol, MaxInfeasCtg, MaxCompViolCtg, MaxSoftViol, MaxDev, PrResid, DuResid' /;
putclose;
LogFile.ap = 1;

* initialization
IterNum = 0;
Done = 0;
UnconditionallyInfeas = 0;
ConditionallyFeas = 0;
CtgUnconditionallyInfeas(k)$Ctg(k) = 0;
CtgConditionallyFeas(k)$Ctg(k) = 0;
GenPowReal(i,j)$GenActive(i,j) = 0;
GenPowRealCoeff1(i,j)$GenActive(i,j) = 0;
GenPowRealCoeff2(i,j)$GenActive(i,j) = 0;
GenCtgPowRealDup(i,j,k)$GenCtgActive(i,j,k) = 0;
GenCtgPowRealMult(i,j,k)$GenCtgActive(i,j,k) = 0;
BusVoltMag(i)$Bus(i) = 0;
BusVoltMagCoeff1(i)$Bus(i) = 0;
BusVoltMagCoeff2(i)$Bus(i) = 0;
BusCtgVoltMagDup(i,k)$(Bus(i) and Ctg(k)) = 0;
BusCtgVoltMagMult(i,k)$(Bus(i) and Ctg(k)) = 0;
CtgActive(k)$Ctg(k) = no;

* iterations
put LogDetailed;
put 'main iterations' /;
putclose;
put LogFile;
put 'main iterations' /;
putclose;
while(not Done,
  IterNum = IterNum + 1;

  # last iteration if conditionally feasible
  if(ConditionallyFeas,
    Done = 1;
  );

  # step 1 subproblem solve
  if(not ConditionallyFeas,
    if(IterNum >= 2,
      GenPowRealCoeff1(i,j)$GenActive(i,j) = sum(k$GenCtgActive(i,j,k), GenCtgPowRealMult(i,j,k) - RegParam * GenCtgPowRealDup(i,j,k));
      GenPowRealCoeff2(i,j)$GenActive(i,j) = 0.5 * RegParam * sum(k$GenCtgActive(i,j,k), 1);
      BusVoltMagCoeff1(i)$Bus(i) = sum(k$Ctg(k), BusCtgVoltMagMult(i,k) - RegParam * BusCtgVoltMagDup(i,k));
      BusVoltMagCoeff2(i)$Bus(i) = 0.5 * RegParam * card(Ctg);
    else
      GenPowRealCoeff1(i,j)$GenActive(i,j) = 0;
      GenPowRealCoeff2(i,j)$GenActive(i,j) = 0;
      BusVoltMagCoeff1(i)$Bus(i) = 0;
      BusVoltMagCoeff2(i)$Bus(i) = 0;
    );
    solve subModelBase using nlp minimizing objVar;
    if(subModelBase.maxinfes > 1e-6,
      UnconditionallyInfeas = 1;
    );
    GenPowRealChange(i,j)$GenActive(i,j) = GenPowRealVar.l(i,j) - GenPowReal(i,j);
    BusVoltMagChange(i)$Bus(i) = BusVoltMagVar.l(i) - BusVoltMag(i);
    GenPowReal(i,j)$GenActive(i,j) = GenPowRealVar.l(i,j);
    BusVoltMag(i)$Bus(i) = BusVoltMagVar.l(i);
    MaxInfeas = subModelBase.maxinfes;
  );

  # fix complementarities on last iter
  if(ConditionallyFeas,

    # first diagnose complemetarities at current point
$ontext
    genCtgPowRealOverFix(i,j,k)$GenCtgParticipating(i,j,k)
      = 1$(  genCtgPowRealVar.l(i,j,k)
           - GenPMin(i,j)
           - genCtgPowRealOverVar.l(i,j,k) > 0);
    genCtgPowRealUnderFix(i,j,k)$GenCtgParticipating(i,j,k)
      = 1$(  GenPMax(i,j)
           - genCtgPowRealVar.l(i,j,k)
           - genCtgPowRealUnderVar.l(i,j,k) > 0);
    busCtgVoltMagOverFix(i,k)$BusCtgVoltMagMaintDom(i,k)
      = 1$(  sum((i1,j1)$GenBusCtgVoltMagMaintDom(i1,j1,i,k),
                 genCtgPowImagVar.l(i1,j1,k) - GenQMin(i1,j1))
           - busCtgVoltMagOverVar.l(i,k) > 0);
    busCtgVoltMagUnderFix(i,k)$BusCtgVoltMagMaintDom(i,k)
      = 1$(  sum((i1,j1)$GenBusCtgVoltMagMaintDom(i1,j1,i,k),
                 GenQMax(i1,j1) - genCtgPowImagVar.l(i1,j1,k))
           - busCtgVoltMagUnderVar.l(i,k) > 0);
$offtext
    genCtgPowRealOverFix(i,j,k)$GenCtgParticipating(i,j,k)
      = 1$(genCtgPowRealOverVar.l(i,j,k) < 1e-6);
    genCtgPowRealUnderFix(i,j,k)$GenCtgParticipating(i,j,k)
      = 1$(genCtgPowRealUnderVar.l(i,j,k) < 1e-6);
    busCtgVoltMagOverFix(i,k)$BusCtgVoltMagMaintDom(i,k)
      = 1$(busCtgVoltMagOverVar.l(i,k) < 1e-6);
    busCtgVoltMagUnderFix(i,k)$BusCtgVoltMagMaintDom(i,k)
      = 1$(busCtgVoltMagUnderVar.l(i,k) < 1e-6);
    GenCtgPowRealFixLo(i,j,k)$GenCtgParticipating(i,j,k)
      = 1$(not genCtgPowRealOverFix(i,j,k));
    GenCtgPowRealFixUp(i,j,k)$GenCtgParticipating(i,j,k)
      = 1$(not genCtgPowRealUnderFix(i,j,k));
    GenCtgPowImagFixLo(i,j,k)$sum(i1$GenBusCtgVoltMagMaintDom(i,j,i1,k),1)
      = 1$sum(i1$(GenBusCtgVoltMagMaintDom(i,j,i1,k) and not busCtgVoltMagOverFix(i1,k)), 1);
    GenCtgPowImagFixUp(i,j,k)$sum(i1$GenBusCtgVoltMagMaintDom(i,j,i1,k),1)
      = 1$sum(i1$(GenBusCtgVoltMagMaintDom(i,j,i1,k) and not busCtgVoltMagUnderFix(i1,k)), 1);

    # then fix
$ontext
    genCtgPowRealOverVar.fx(i,j,k)$genCtgPowRealOverFix(i,j,k) = 0;
    genCtgPowRealUnderVar.fx(i,j,k)$genCtgPowRealUnderFix(i,j,k) = 0;
    busCtgVoltMagOverVar.fx(i,k)$busCtgVoltMagOverFix(i,k) = 0;
    busCtgVoltMagUnderVar.fx(i,k)$busCtgVoltMagUnderFix(i,k) = 0;
    genCtgPowRealVar.fx(i,j,k)$GenCtgPowRealFixLo(i,j,k) = GenPMin(i,j);
    genCtgPowRealVar.fx(i,j,k)$GenCtgPowRealFixUp(i,j,k) = GenPMax(i,j);
    genCtgPowImagVar.fx(i,j,k)$GenCtgPowImagFixLo(i,j,k) = GenQMin(i,j);
    genCtgPowImagVar.fx(i,j,k)$GenCtgPowImagFixUp(i,j,k) = GenQMax(i,j);
$offtext
  );

  # loop over contingencies to solve decomposable step 2 subproblem
  loop(k0$(Ctg(k0) and not UnconditionallyInfeas),
  #loop(k0$(Ctg(k0) and sameas(k0,'LINE-187-191-1')),

    # set up problem: active contingency and penalties
    CtgActive(k) = no;
    CtgActive(k0) = yes;
    GenPowRealCoeff1(i,j)$GenCtgActive(i,j,k0) = -GenCtgPowRealMult(i,j,k0) - RegParam * GenPowReal(i,j);
    GenPowRealCoeff2(i,j)$GenCtgActive(i,j,k0) = 0.5 * RegParam;
    BusVoltMagCoeff1(i)$Bus(i) = -BusCtgVoltMagMult(i,k0) - RegParam * BusVoltMag(i);
    BusVoltMagCoeff2(i)$Bus(i) = 0.5 * RegParam;

    # first solve with linking variables fixed to try to confirm current point is a solution
    # if infeas try again with linking variables only penalized
    # if still infeas then the whole problem is infeasible
    GenPowRealVar.fx(i,j)$GenActive(i,j) = GenPowReal(i,j);
    BusVoltMagVar.fx(i)$Bus(i) = BusVoltMag(i);
    solve subModelCtg using mpec minimizing objVar;
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
    if((not ConditionallyFeas) and
       (subModelCtg.maxinfes > 1e-6 or
        CtgMaxCompViol(k0) > 1e-3),
      CtgConditionallyFeas(k0) = 0;
      GenPowRealVar.lo(i,j)$GenActive(i,j) = GenPMin(i,j);
      GenPowRealVar.up(i,j)$GenActive(i,j) = GenPMax(i,j);
      BusVoltMagVar.lo(i)$Bus(i) = BusVMin(i);
      BusVoltMagVar.up(i)$Bus(i) = BusVMax(i);
      solve subModelCtg using mpec minimizing objVar;
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
      if(subModelCtg.maxinfes > 1e-6 or
         CtgMaxCompViol(k0) > 1e-3,
        CtgUnconditionallyInfeas(k0) = 1;
	UnconditionallyInfeas = 1;
	Done = 1;
      );
    else
      CtgConditionallyFeas(k0) = 1;
    );

    # process solution
    GenCtgPowRealDup(i,j,k0)$GenCtgActive(i,j,k0) = GenPowRealVar.l(i,j);
    BusCtgVoltMagDup(i,k0)$Bus(i) = BusVoltMagVar.l(i);
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
      IterNum:0:0 ', '
      k0.tl:0:0 ', '
      timeelapsed:0:0 ', '
      CtgMaxInfeas(k0):0:10 ', '
      CtgMaxCompViol(k0):0:10 ', '
      CtgMaxSoftViol(k0):0:10 ', '
      0:0:10 /;
    putclose;
  );
  if(not ConditionallyFeas,
    ConditionallyFeas = 1$(
      sum(k$(Ctg(k) and not CtgConditionallyFeas(k)), 1) = 0);
  );

  # log entry
  put LogFile;
  put
    IterNum:0:0 ', '
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
    smax(k$Ctg(k), CtgMaxSoftViol(k)):0:10 ', '
    smax((i,j,k)$GenCtgActive(i,j,k), abs(GenCtgPowRealDup(i,j,k) - GenPowReal(i,j))):0:10 ', '
    sqrt(  sum((i,j,k)$GenCtgActive(i,j,k), sqr(GenCtgPowRealDup(i,j,k) - GenPowReal(i,j)))
         + sum((i,k)$(Bus(i) and Ctg(k)), sqr(BusCtgVoltMagDup(i,k) - BusVoltMag(i)))):0:10 ', '
    sqrt(  sum((i,j)$GenActive(i,j), sqr(GenPowRealChange(i,j)))
         + sum((i)$Bus(i), sqr(BusVoltMagChange(i)))):0:10 ', '
    /;
  putclose;

  # multiplier update
  if(IterNum <= MaxIter - 3,
    GenCtgPowRealMult(i,j,k)$GenCtgActive(i,j,k)
      = GenCtgPowRealMult(i,j,k)
      - RegParam * (GenCtgPowRealDup(i,j,k) - GenPowReal(i,j));
    BusCtgVoltMagMult(i,k)$(Bus(i) and Ctg(k))
      = BusCtgVoltMagMult(i,k)
      - RegParam * (BusCtgVoltmagDup(i,k) - BusVoltMag(i));
  );

  # check termination criteria
  if(IterNum ge MaxIter,
    Done = 1;
  );
  if(UnconditionallyInfeas,
    Done = 1;
  );
);
