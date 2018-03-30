$title data
$ontext
Declares and reads model data stored in GDX.
Data defined here uses a naming convention with
upper case initial letters of words, lower case thereafter,
and no separating characters between words, as in

  GridOptimizationCompetition

N.b. GAMS is not case sensitive.
$offtext

$if not set ingdx $set ingdx data.gdx

sets
  Num
  Ident
  Name
  Bus(Num)
  Load(Num,Ident)
  Fxsh(Num,Ident)
  Gen(Num,Ident)
  Line(Num,Num,Ident)
  Xfmr(Num,Num,Ident)
  Area(Num)
  Swsh(Num)
  Ctg(Name)
  LoadActive(Num,Ident)
  FxshActive(Num,Ident)
  GenActive(Num,Ident)
  LineActive(Num,Num,Ident)
  XfmrActive(Num,Num,Ident)
  SwshActive(Num)
  CtgActive(Name)
  GenBusVReg(Num,Ident,Num)
  GenPl(Num,Ident,Num)
  GenArea(Num,Ident,Num)
  GenCtgInactive(Num,Ident,Name)
  LineCtgInactive(Num,Num,Ident,Name)
  XfmrCtgInactive(Num,Num,Ident,Name)
  GenCtgActive(Num,Ident,Name)
  LineCtgActive(Num,Num,Ident,Name)
  XfmrCtgActive(Num,Num,Ident,Name)
  AreaCtgAffected(Num,Name)
  BusCtgVoltMagMaintDom(Num,Name)
  GenBusCtgVoltMagMaintDom(Num,Ident,Num,Name)
;

alias(Num,i,i0,i1,i2,i3,i4);
alias(Ident,j,j0,j1,j2,j3,j4);
alias(Name,k,k0,k1,k2,k3,k4);

parameters
  BaseMVA
  BusBaseKV
  BusVMax(Num)
  BusVMin(Num)
  LoadP(Num,Ident)
  LoadQ(Num,Ident)
  FxshG(Num,Ident)
  FxshB(Num,Ident)
  GenQMax(Num,Ident)
  GenQMin(Num,Ident)
  GenPMax(Num,Ident)
  GenPMin(Num,Ident)
  GenPartFact(Num,Ident)
  LineG(Num,Num,Ident)
  LineB(Num,Num,Ident)
  LineBCh(Num,Num,Ident)
  LineFlowMax(Num,Num,Ident)
  XfmrGMag(Num,Num,Ident)
  XfmrBMag(Num,Num,Ident)
  XfmrG(Num,Num,Ident)
  XfmrB(Num,Num,Ident)
  XfmrRatio(Num,Num,Ident)
  XfmrAng(Num,Num,Ident)
  XfmrFlowMax(Num,Num,Ident)
  SwshBMax(Num)
  SwshBMin(Num)
  GenPlX(Num,Ident,Num)
  GenPlY(Num,Ident,Num)
;

$gdxin '%ingdx%'
$loaddc Num
$loaddc Ident
$loaddc Name
$loaddc Bus
$loaddc Load
$loaddc Fxsh
$loaddc Gen
$loaddc Line
$loaddc Xfmr
$loaddc Area
$loaddc Swsh
$loaddc Ctg
$loaddc LoadActive
$loaddc FxshActive
$loaddc GenActive
$loaddc LineActive
$loaddc XfmrActive
$loaddc SwshActive
$loaddc GenBusVReg
$loaddc GenPl
$loaddc GenArea
$loaddc GenCtgInactive
$loaddc LineCtgInactive
$loaddc XfmrCtgInactive
$loaddc AreaCtgAffected
$loaddc BaseMVA
$loaddc BusBaseKV
$loaddc BusVMax
$loaddc BusVMin
$loaddc LoadP
$loaddc LoadQ
$loaddc FxshG
$loaddc FxshB
$loaddc GenQMax
$loaddc GenQMin
$loaddc GenPMax
$loaddc GenPMin
$loaddc GenPartFact
$loaddc LineG
$loaddc LineB
$loaddc LineBCh
$loaddc LineFlowMax
$loaddc XfmrGMag
$loaddc XfmrBMag
$loaddc XfmrG
$loaddc XfmrB
$loaddc XfmrRatio
$loaddc XfmrAng
$loaddc XfmrFlowMax
$loaddc SwshBMax
$loaddc SwshBMin
$loaddc GenPlX
$loaddc GenPlY
$gdxin

* compute from loaded data
* might want to put these in a separate gams file
GenCtgActive(i,j,k)$(GenActive(i,j) and Ctg(k) and not GenCtgInactive(i,j,k)) = yes;
LineCtgActive(i1,i2,j,k)$(LineActive(i1,i2,j) and Ctg(k) and not LineCtgInactive(i1,i2,j,k)) = yes;
XfmrCtgActive(i1,i2,j,k)$(XfmrActive(i1,i2,j) and Ctg(k) and not XfmrCtgInactive(i1,i2,j,k)) = yes;
* compute gen_area from bus_area?
* compute area_ctg_affected?
* useful sets and params
set
  GenCtgParticipating(Num,Ident,Name)
  GenAreaCtgParticipating(Num,Ident,Num,Name);
GenAreaCtgParticipating(i,j,i1,k)$(GenArea(i,j,i1) and AreaCtgAffected(i1,k) and GenCtgActive(i,j,k)) = yes;
GenCtgParticipating(i,j,k)$GenCtgActive(i,j,k) = sum(i1$GenAreaCtgParticipating(i,j,i1,k),1);
GenBusCtgVoltMagMaintDom(i1,j1,i,k)
  $(GenCtgActive(i1,j1,k) and GenBusVReg(i1,j1,i) and GenQMin(i1,j1) < GenQMax(i1,j1)) = yes;
BusCtgVoltMagMaintDom(i,k)
  $(sum((i1,j1)$GenBusCtgVoltMagMaintDom(i1,j1,i,k),1) > 0) = yes;
display
  genCtgParticipating
  genAreaCtgParticipating;

display
  Num
  Ident
  Name
  Bus
  Load
  Fxsh
  Gen
  Line
  Xfmr
  Area
  Swsh
  Ctg
  LoadActive
  FxshActive
  GenActive
  LineActive
  XfmrActive
  SwshActive
  GenBusVReg
  GenPl
  GenArea
  GenCtgInactive
  LineCtgInactive
  XfmrCtgInactive
  AreaCtgAffected
  BaseMVA
  BusBaseKV
  BusVMax
  BusVMin
  LoadP
  LoadQ
  FxshG
  FxshB
  GenQMax
  GenQMin
  GenPMax
  GenPMin
  GenPartFact
  LineG
  LineB
  LineBCh
  LineFlowMax
  XfmrGMag
  XfmrBMag
  XfmrG
  XfmrB
  XfmrRatio
  XfmrAng
  XfmrFlowMax
  SwshBMax
  SwshBMin
  GenPlX
  GenPlY
;
