$title solution_evaluation_base
$ontext
compute solution values for base case
mimic GOComp solution evaluation procedure
$offtext

* independent variable values set from solution levels
* these values are needed in the solution file
busVoltMag(i)$Bus(i) = busVoltMagVar.l(i);
busVoltAng(i)$Bus(i) = busVoltAngVar.l(i);
genPowReal(i,j)$Gen(i,j) = genPowRealVar.l(i,j)$GenActive(i,j);
genPowImag(i,j)$Gen(i,j) = genPowImagVar.l(i,j)$GenActive(i,j);
swshAdmImag(i)$Swsh(i) = swshAdmImagVar.l(i)$SwshActive(i);

* derived variable values
loadPowReal(i,j)$Load(i,j)
  = LoadP(i,j)$LoadActive(i,j);
loadPowImag(i,j)$Load(i,j)
  = LoadQ(i,j)$LoadActive(i,j);
fxshPowReal(i,j)$Fxsh(i,j)
  = FxshG(i,j) * sqr(busVoltMag(i)) $FxshActive(i,j);
fxshPowImag(i,j)$Fxsh(i,j)
  = - FxshB(i,j) * sqr(busVoltMag(i)) $FxshActive(i,j);
lineCurrReal1(i1,i2,j)$Line(i1,i2,j)
  = (  LineG(i1,i2,j) * (busVoltMag(i1) * cos(busVoltAng(i1)) - busVoltMag(i2) * cos(busVoltAng(i2)))
     - LineB(i1,i2,j) * (busVoltMag(i1) * sin(busVoltAng(i1)) - busVoltMag(i2) * sin(busVoltAng(i2)))
     - 0.5 * LineBCh(i1,i2,j) * busVoltMag(i1) * sin(busVoltAng(i1)))
    $LineActive(i1,i2,j);
lineCurrImag1(i1,i2,j)$Line(i1,i2,j)
  = (  LineG(i1,i2,j) * (busVoltMag(i1) * sin(busVoltAng(i1)) - busVoltMag(i2) * sin(busVoltAng(i2)))
     + LineB(i1,i2,j) * (busVoltMag(i1) * cos(busVoltAng(i1)) - busVoltMag(i2) * cos(busVoltAng(i2)))
     + 0.5 * LineBCh(i1,i2,j) * busVoltMag(i1) * cos(busVoltAng(i1)))
    $LineActive(i1,i2,j);
lineCurrReal2(i1,i2,j)$Line(i1,i2,j)
  = (  LineG(i1,i2,j) * (busVoltMag(i2) * cos(busVoltAng(i2)) - busVoltMag(i1) * cos(busVoltAng(i1)))
     - LineB(i1,i2,j) * (busVoltMag(i2) * sin(busVoltAng(i2)) - busVoltMag(i1) * sin(busVoltAng(i1)))
     - 0.5 * LineBCh(i1,i2,j) * busVoltMag(i2) * sin(busVoltAng(i2)))
    $LineActive(i1,i2,j);
lineCurrImag2(i1,i2,j)$Line(i1,i2,j)
  = (  LineG(i1,i2,j) * (busVoltMag(i2) * sin(busVoltAng(i2)) - busVoltMag(i1) * sin(busVoltAng(i1)))
     + LineB(i1,i2,j) * (busVoltMag(i2) * cos(busVoltAng(i2)) - busVoltMag(i1) * cos(busVoltAng(i1)))
     + 0.5 * LineBCh(i1,i2,j) * busVoltMag(i2) * cos(busVoltAng(i2)))
    $LineActive(i1,i2,j);
linePowReal1(i1,i2,j)$Line(i1,i2,j)
  = (  lineCurrReal1(i1,i2,j) * busVoltMag(i1) * cos(busVoltAng(i1))
     + lineCurrImag1(i1,i2,j) * busVoltMag(i1) * sin(busVoltAng(i1)))
    $LineActive(i1,i2,j);
linePowImag1(i1,i2,j)$Line(i1,i2,j)
  = (  lineCurrReal1(i1,i2,j) * busVoltMag(i1) * sin(busVoltAng(i1))
     - lineCurrImag1(i1,i2,j) * busVoltMag(i1) * cos(busVoltAng(i1)))
    $LineActive(i1,i2,j);
linePowReal2(i1,i2,j)$Line(i1,i2,j)
  = (  lineCurrReal2(i1,i2,j) * busVoltMag(i2) * cos(busVoltAng(i2))
     + lineCurrImag2(i1,i2,j) * busVoltMag(i2) * sin(busVoltAng(i2)))
    $LineActive(i1,i2,j);
linePowImag2(i1,i2,j)$Line(i1,i2,j)
  = (  lineCurrReal2(i1,i2,j) * busVoltMag(i2) * sin(busVoltAng(i2))
     - lineCurrImag2(i1,i2,j) * busVoltMag(i2) * cos(busVoltAng(i2)))
    $LineActive(i1,i2,j);
xfmrCurrReal1(i1,i2,j)$Xfmr(i1,i2,j)
  = (  XfmrGMag(i1,i2,j) * busVoltMag(i1) * cos(busVoltAng(i1))
     - XfmrBMag(i1,i2,j) * busVoltMag(i1) * sin(busVoltAng(i1))
     + (  XfmrG(i1,i2,j) * cos(XfmrAng(i1,i2,j))
        - XfmrB(i1,i2,j) * sin(XfmrAng(i1,i2,j)))
     * (  busVoltMag(i1) / sqr(XfmrRatio(i1,i2,j)) * cos(busVoltAng(i1) - XfmrAng(i1,i2,j))
        - busVoltMag(i2) / XfmrRatio(i1,i2,j) * cos(busVoltAng(i2)))
     - (  XfmrG(i1,i2,j) * sin(XfmrAng(i1,i2,j))
        + XfmrB(i1,i2,j) * cos(XfmrAng(i1,i2,j)))
     * (  busVoltMag(i1) / sqr(XfmrRatio(i1,i2,j)) * sin(busVoltAng(i1) - XfmrAng(i1,i2,j))
        - busVoltMag(i2) / XfmrRatio(i1,i2,j) * sin(busVoltAng(i2))))
    $XfmrActive(i1,i2,j);
xfmrCurrImag1(i1,i2,j)$Xfmr(i1,i2,j)
  = (  XfmrGMag(i1,i2,j) * busVoltMag(i1) * sin(busVoltAng(i1))
     + XfmrBMag(i1,i2,j) * busVoltMag(i1) * cos(busVoltAng(i1))
     + (  XfmrG(i1,i2,j) * cos(XfmrAng(i1,i2,j))
        - XfmrB(i1,i2,j) * sin(XfmrAng(i1,i2,j)))
     * (  busVoltMag(i1) / sqr(XfmrRatio(i1,i2,j)) * sin(busVoltAng(i1) - XfmrAng(i1,i2,j))
        - busVoltMag(i2) / XfmrRatio(i1,i2,j) * sin(busVoltAng(i2)))
     + (  XfmrG(i1,i2,j) * sin(XfmrAng(i1,i2,j))
        + XfmrB(i1,i2,j) * cos(XfmrAng(i1,i2,j)))
     * (  busVoltMag(i1) / sqr(XfmrRatio(i1,i2,j)) * cos(busVoltAng(i1) - XfmrAng(i1,i2,j))
        - busVoltMag(i2) / XfmrRatio(i1,i2,j) * cos(busVoltAng(i2))))
    $XfmrActive(i1,i2,j);
xfmrCurrReal2(i1,i2,j)$Xfmr(i1,i2,j)
  = (  XfmrG(i1,i2,j)
     * (  busVoltMag(i2) * cos(busVoltAng(i2))
        - busVoltMag(i1) / XfmrRatio(i1,i2,j) * cos(busVoltAng(i1) - XfmrAng(i1,i2,j)))
     - XfmrB(i1,i2,j)
     * (  busVoltMag(i2) * sin(busVoltAng(i2))
        - busVoltMag(i1) / XfmrRatio(i1,i2,j) * sin(busVoltAng(i1) - XfmrAng(i1,i2,j))))
    $XfmrActive(i1,i2,j);
xfmrCurrImag2(i1,i2,j)$Xfmr(i1,i2,j)
  = (  XfmrG(i1,i2,j)
     * (  busVoltMag(i2) * sin(busVoltAng(i2))
        - busVoltMag(i1) / XfmrRatio(i1,i2,j) * sin(busVoltAng(i1) - XfmrAng(i1,i2,j)))
     + XfmrB(i1,i2,j)
     * (  busVoltMag(i2) * cos(busVoltAng(i2))
        - busVoltMag(i1) / XfmrRatio(i1,i2,j) * cos(busVoltAng(i1) - XfmrAng(i1,i2,j))))
    $XfmrActive(i1,i2,j);
xfmrPowReal1(i1,i2,j)$Xfmr(i1,i2,j)
  = (  xfmrCurrReal1(i1,i2,j) * busVoltMag(i1) * cos(busVoltAng(i1))
     + xfmrCurrImag1(i1,i2,j) * busVoltMag(i1) * sin(busVoltAng(i1)))
    $XfmrActive(i1,i2,j);
xfmrPowImag1(i1,i2,j)$Xfmr(i1,i2,j)
  = (  xfmrCurrReal1(i1,i2,j) * busVoltMag(i1) * sin(busVoltAng(i1))
     - xfmrCurrImag1(i1,i2,j) * busVoltMag(i1) * cos(busVoltAng(i1)))
    $XfmrActive(i1,i2,j);
xfmrPowReal2(i1,i2,j)$Xfmr(i1,i2,j)
  = (  xfmrCurrReal2(i1,i2,j) * busVoltMag(i2) * cos(busVoltAng(i2))
     + xfmrCurrImag2(i1,i2,j) * busVoltMag(i2) * sin(busVoltAng(i2)))
    $XfmrActive(i1,i2,j);
xfmrPowImag2(i1,i2,j)$Xfmr(i1,i2,j)
  = (  xfmrCurrReal2(i1,i2,j) * busVoltMag(i2) * sin(busVoltAng(i2))
     - xfmrCurrImag2(i1,i2,j) * busVoltMag(i2) * cos(busVoltAng(i2)))
    $XfmrActive(i1,i2,j);
swshPowImag(i)$Swsh(i)
  = - SwshAdmImag(i) * sqr(busVoltMag(i)) $SwshActive(i);

* derived cost
genPlCoeff(i,j,i1)$(GenActive(i,j) and GenPl(i,j,i1)) = 0; # TODO fix this
loop((i,j)$GenActive(i,j),
  loop(i1$GenPl(i,j,i1),
    if(GenPlX(i,j,i1) = genPowReal(i,j),
      genPlCoeff(i,j,i1) = 1;
      break;);
    if(GenPlX(i,j,i1) < genPowReal(i,j) and genPowReal(i,j) < GenPlX(i,j,i1+1),
      genPlCoeff(i,j,i1+1) = (genPowReal(i,j) - GenPlX(i,j,i1)) / (GenPlX(i,j,i1+1) - GenPlX(i,j,i1));
      genPlCoeff(i,j,i1) = 1 - genPlCoeff(i,j,i1+1);
      break;);););
genCost(i,j)$GenActive(i,j)
  = sum(i1$GenPl(i,j,i1), GenPlY(i,j,i1) * genPlCoeff(i,j,i1));
cost
  = sum((i,j)$GenActive(i,j), genCost(i,j));

* constraint violation values
busVoltMagLoViol(i)$Bus(i)
  = max(0, BusVMin(i) - busVoltMag(i));
busVoltMagUpViol(i)$Bus(i)
  = max(0, busVoltMag(i) - BusVMax(i));
genPowRealLoViol(i,j)$Gen(i,j)
  = max(0, GenPMin(i,j)$GenActive(i,j) - genPowReal(i,j));
genPowRealUpViol(i,j)$Gen(i,j)
  = max(0, genPowReal(i,j) - GenPMax(i,j)$GenActive(i,j));
genPowImagLoViol(i,j)$Gen(i,j)
  = max(0, GenQMin(i,j)$GenActive(i,j) - genPowImag(i,j));
genPowImagUpViol(i,j)$Gen(i,j)
  = max(0, genPowImag(i,j) - GenQMax(i,j)$GenActive(i,j));
lineCurrMag1UpViol(i1,i2,j)$Line(i1,i2,j)
  = max(0,
          sqrt(  sqr(LineCurrReal1(i1,i2,j))
	       + sqr(LineCurrImag1(i1,i2,j)))
	- LineFlowMax(i1,i2,j)$LineActive(i1,i2,j));
lineCurrMag2UpViol(i1,i2,j)$Line(i1,i2,j)
  = max(0,
          sqrt(  sqr(LineCurrReal2(i1,i2,j))
	       + sqr(LineCurrImag2(i1,i2,j)))
	- LineFlowMax(i1,i2,j)$LineActive(i1,i2,j));
xfmrPowMag1UpViol(i1,i2,j)$Xfmr(i1,i2,j)
  = max(0,
          sqrt(  sqr(XfmrPowReal1(i1,i2,j))
	       + sqr(XfmrPowImag1(i1,i2,j)))
	- XfmrFlowMax(i1,i2,j)$XfmrActive(i1,i2,j));
xfmrPowMag2UpViol(i1,i2,j)$Xfmr(i1,i2,j)
  = max(0,
          sqrt(  sqr(XfmrPowReal2(i1,i2,j))
	       + sqr(XfmrPowImag2(i1,i2,j)))
	- XfmrFlowMax(i1,i2,j)$XfmrActive(i1,i2,j));
swshAdmImagLoViol(i)$Swsh(i)
  = max(0, SwshBMin(i)$SwshActive(i) - swshAdmImag(i));
swshAdmImagUpViol(i)$Swsh(i)
  = max(0, swshAdmImag(i) - SwshBMax(i)$SwshActive(i));
busPowRealBalanceViol(i)$Bus(i)
  = abs(  sum(j$GenActive(i,j), genPowReal(i,j))
        - sum(j$LoadActive(i,j), loadPowReal(i,j))
        - sum(j$FxshActive(i,j), fxshPowReal(i,j))
        - sum((i2,j)$LineActive(i,i2,j), linePowReal1(i,i2,j))
        - sum((i1,j)$LineActive(i1,i,j), linePowReal2(i1,i,j))
        - sum((i2,j)$XfmrActive(i,i2,j), xfmrPowReal1(i,i2,j))
        - sum((i1,j)$XfmrActive(i1,i,j), xfmrPowReal2(i1,i,j)));
busPowImagBalanceViol(i)$Bus(i)
  = abs(  sum(j$GenActive(i,j), genPowImag(i,j))
        - sum(j$LoadActive(i,j), loadPowImag(i,j))
        - sum(j$FxshActive(i,j), fxshPowImag(i,j))
        - sum((i2,j)$LineActive(i,i2,j), linePowImag1(i,i2,j))
        - sum((i1,j)$LineActive(i1,i,j), linePowImag2(i1,i,j))
        - sum((i2,j)$XfmrActive(i,i2,j), xfmrPowImag1(i,i2,j))
        - sum((i1,j)$XfmrActive(i1,i,j), xfmrPowImag2(i1,i,j))
        - swshPowImag(i)$SwshActive(i));

* compute summaries
sumBusVoltMagLoViol = sum(i$Bus(i), BusVoltMagLoViol(i));
sumBusVoltMagUpViol = sum(i$Bus(i), BusVoltMagUpViol(i));
sumGenPowRealLoViol = sum((i,j)$Gen(i,j), GenPowRealLoViol(i,j));
sumGenPowRealUpViol = sum((i,j)$Gen(i,j), GenPowRealUpViol(i,j));
sumGenPowImagLoViol = sum((i,j)$Gen(i,j), GenPowImagLoViol(i,j));
sumGenPowImagUpViol = sum((i,j)$Gen(i,j), GenPowImagUpViol(i,j));
sumLineCurrMag1UpViol = sum((i1,i2,j)$Line(i1,i2,j), LineCurrMag1UpViol(i1,i2,j));
sumLineCurrMag2UpViol = sum((i1,i2,j)$Line(i1,i2,j), LineCurrMag2UpViol(i1,i2,j));
sumXfmrPowMag1UpViol = sum((i1,i2,j)$Xfmr(i1,i2,j), XfmrPowMag1UpViol(i1,i2,j));
sumXfmrPowMag2UpViol = sum((i1,i2,j)$Xfmr(i1,i2,j), XfmrPowMag2UpViol(i1,i2,j));
sumSwshAdmImagLoViol = sum(i$Swsh(i), SwshAdmImagLoViol(i));
sumSwshAdmImagUpViol = sum(i$Swsh(i), SwshAdmImagUpViol(i));
sumBusPowRealBalanceViol = sum(i$Bus(i), BusPowRealBalanceViol(i));
sumBusPowImagBalanceViol = sum(i$Bus(i), BusPowImagBalanceViol(i));
maxBusVoltMagLoViol = smax(i$Bus(i), BusVoltMagLoViol(i));
maxBusVoltMagUpViol = smax(i$Bus(i), BusVoltMagUpViol(i));
maxGenPowRealLoViol = smax((i,j)$Gen(i,j), GenPowRealLoViol(i,j));
maxGenPowRealUpViol = smax((i,j)$Gen(i,j), GenPowRealUpViol(i,j));
maxGenPowImagLoViol = smax((i,j)$Gen(i,j), GenPowImagLoViol(i,j));
maxGenPowImagUpViol = smax((i,j)$Gen(i,j), GenPowImagUpViol(i,j));
maxLineCurrMag1UpViol = smax((i1,i2,j)$Line(i1,i2,j), LineCurrMag1UpViol(i1,i2,j));
maxLineCurrMag2UpViol = smax((i1,i2,j)$Line(i1,i2,j), LineCurrMag2UpViol(i1,i2,j));
maxXfmrPowMag1UpViol = smax((i1,i2,j)$Xfmr(i1,i2,j), XfmrPowMag1UpViol(i1,i2,j));
maxXfmrPowMag2UpViol = smax((i1,i2,j)$Xfmr(i1,i2,j), XfmrPowMag2UpViol(i1,i2,j));
maxSwshAdmImagLoViol = smax(i$Swsh(i), SwshAdmImagLoViol(i));
maxSwshAdmImagUpViol = smax(i$Swsh(i), SwshAdmImagUpViol(i));
maxBusPowRealBalanceViol = smax(i$Bus(i), BusPowRealBalanceViol(i));
maxBusPowImagBalanceViol = smax(i$Bus(i), BusPowImagBalanceViol(i));
