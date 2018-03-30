$title greedy_setup.gms
$ontext
set up solver options, etc., for greedy method
$offtext

VoltMagViolPen = 1e3;
PowFlowMagViolPen = 1e5;
CurrFlowMagViolPen = 1e5;
PowBalanceViolPen = 1e5;
VoltMagBoundSoft = 0;
PowFlowMagBoundSoft = 0;
CurrFlowMagBoundSoft = 0;
PowBalanceSoft = 1;
# why do we need soft constraints for power and current bounds?
# if we fix generator bus voltage magnitudes in contingency
# to those in the base case then the flows on adjacent lines
# are fixed. This is OK as long as some of the adjacent lines
# do not go out of service
# anyway I am not sure if this is necessary.

option
  limrow = 0
  limcol = 0
  solprint = off
  nlp = ipopth # knitro, ipopt, ipopth
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
* might want to play with opttol, ftol, ftol_iters in order to terminate with a suboptimal solution more quickly
*opttol 1e-3
*ftol 1e-5
*ftol_iters 3
* not good, just use default
*pivot 1e-12
*maxcgit 10
* 1: exact hessian from GAMS, 6: L-BFGS (maybe lower memory? seems slower and lower quality solution)
*hessopt 6

* penalty/relaxation approach to constraints
* if penalties are explicitly formulated in the model
* then it may be good to prevent Knitro from adding new penalties
* if penalties are not explicitly formulated in the model
* then we may need to tell Knitro to add them

* not good - just use default
*bar_feasible 3

bar_pencons 1
*bar_penaltycons 2
*bar_penaltyrule

* default is 2 - relax inequalities. 0 says no relaxation
bar_relaxcons 0

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

* ipopth options file
* ipopth is pretty good
* need to experiment with options and scaling
$onecho > ipopth.opt
#max_iter 10
#hessian_approximation limited-memory
acceptable_tol 1e-3
acceptable_iter 5
$offecho

subModelBase.optfile = 1;
subModelCtg.optfile = 1;
#subModelBase.holdfixed = 1;
#subModelCtg.holdfixed = 1;
subModelBase.dictfile = 0;
subModelCtg.dictfile = 0;

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
