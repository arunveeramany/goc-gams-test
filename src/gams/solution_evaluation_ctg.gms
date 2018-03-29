$title solution_evaluation_ctg
$ontext
compute solution values for contingencies
mimic GOComp solution evaluation procedure
$offtext

* independent variable values set from solution levels
* these values are needed in the solution file
busCtgVoltMag(i,k)$(Bus(i) and Ctg(k)) = busCtgVoltMagVar.l(i,k);
busCtgVoltAng(i,k)$(Bus(i) and Ctg(k)) = busCtgVoltAngVar.l(i,k);
genCtgPowImag(i,j,k)$(Gen(i,j) and Ctg(k)) = genCtgPowImagVar.l(i,j,k)$GenCtgActive(i,j,k);
swshCtgAdmImag(i,k)$(Swsh(i) and Ctg(k)) = swshCtgAdmImagVar.l(i,k)$SwshActive(i);
areaCtgPowRealChange(i,k)$(Area(i) and Ctg(k)) = areaCtgPowRealChangeVar.l(i,k)$areaCtgAffected(i,k); # todo - do we need a domain here?

* derived variable values
loadCtgPowReal(i,j,k)$(Load(i,j) and Ctg(k))
  = LoadP(i,j)$LoadActive(i,j);
loadCtgPowImag(i,j,k)$(Load(i,j) and Ctg(k))
  = LoadQ(i,j)$LoadActive(i,j);
fxshCtgPowReal(i,j,k)$(Fxsh(i,j) and Ctg(k))
  = FxshG(i,j) * sqr(busCtgVoltMag(i,k)) $FxshActive(i,j);
fxshCtgPowImag(i,j,k)$(Fxsh(i,j) and Ctg(k))
  = - FxshB(i,j) * sqr(busCtgVoltMag(i,k)) $FxshActive(i,j);
genCtgPowReal(i,j,k)$(Gen(i,j) and Ctg(k))
  = genPowReal(i,j)$(GenCtgActive(i,j,k) and not GenCtgParticipating(i,j,k))
  + max(GenPMin(i,j),
        min(GenPMax(i,j),
	      genPowReal(i,j)
            + GenPartFact(i,j)
	    * sum(i1$GenArea(i,j,i1),areaCtgPowRealChange(i1,k))))$GenCtgParticipating(i,j,k);
lineCtgCurrReal1(i1,i2,j,k)$(Line(i1,i2,j) and Ctg(k))
  = (  LineG(i1,i2,j) * (busCtgVoltMag(i1,k) * cos(busCtgVoltAng(i1,k)) - busCtgVoltMag(i2,k) * cos(busCtgVoltAng(i2,k)))
     - LineB(i1,i2,j) * (busCtgVoltMag(i1,k) * sin(busCtgVoltAng(i1,k)) - busCtgVoltMag(i2,k) * sin(busCtgVoltAng(i2,k)))
     - 0.5 * LineBCh(i1,i2,j) * busCtgVoltMag(i1,k) * sin(busCtgVoltAng(i1,k)))$LineCtgActive(i1,i2,j,k);
lineCtgCurrImag1(i1,i2,j,k)$(Line(i1,i2,j) and Ctg(k))
  = (  LineG(i1,i2,j) * (busCtgVoltMag(i1,k) * sin(busCtgVoltAng(i1,k)) - busCtgVoltMag(i2,k) * sin(busCtgVoltAng(i2,k)))
     + LineB(i1,i2,j) * (busCtgVoltMag(i1,k) * cos(busCtgVoltAng(i1,k)) - busCtgVoltMag(i2,k) * cos(busCtgVoltAng(i2,k)))
     + 0.5 * LineBCh(i1,i2,j) * busCtgVoltMag(i1,k) * cos(busCtgVoltAng(i1,k)))$LineCtgActive(i1,i2,j,k);
lineCtgCurrReal2(i1,i2,j,k)$(Line(i1,i2,j) and Ctg(k))
  = (  LineG(i1,i2,j) * (busCtgVoltMag(i2,k) * cos(busCtgVoltAng(i2,k)) - busCtgVoltMag(i1,k) * cos(busCtgVoltAng(i1,k)))
     - LineB(i1,i2,j) * (busCtgVoltMag(i2,k) * sin(busCtgVoltAng(i2,k)) - busCtgVoltMag(i1,k) * sin(busCtgVoltAng(i1,k)))
     - 0.5 * LineBCh(i1,i2,j) * busCtgVoltMag(i2,k) * sin(busCtgVoltAng(i2,k)))$LineCtgActive(i1,i2,j,k);
lineCtgCurrImag2(i1,i2,j,k)$(Line(i1,i2,j) and Ctg(k))
  = (  LineG(i1,i2,j) * (busCtgVoltMag(i2,k) * sin(busCtgVoltAng(i2,k)) - busCtgVoltMag(i1,k) * sin(busCtgVoltAng(i1,k)))
     + LineB(i1,i2,j) * (busCtgVoltMag(i2,k) * cos(busCtgVoltAng(i2,k)) - busCtgVoltMag(i1,k) * cos(busCtgVoltAng(i1,k)))
     + 0.5 * LineBCh(i1,i2,j) * busCtgVoltMag(i2,k) * cos(busCtgVoltAng(i2,k)))$LineCtgActive(i1,i2,j,k);
lineCtgPowReal1(i1,i2,j,k)$(Line(i1,i2,j) and Ctg(k))
  = (  lineCtgCurrReal1(i1,i2,j,k) * busCtgVoltMag(i1,k) * cos(busCtgVoltAng(i1,k))
     + lineCtgCurrImag1(i1,i2,j,k) * busCtgVoltMag(i1,k) * sin(busCtgVoltAng(i1,k)))$LineCtgActive(i1,i2,j,k);
lineCtgPowImag1(i1,i2,j,k)$(Line(i1,i2,j) and Ctg(k))
  = (  lineCtgCurrReal1(i1,i2,j,k) * busCtgVoltMag(i1,k) * sin(busCtgVoltAng(i1,k))
     - lineCtgCurrImag1(i1,i2,j,k) * busCtgVoltMag(i1,k) * cos(busCtgVoltAng(i1,k)))$LineCtgActive(i1,i2,j,k);
lineCtgPowReal2(i1,i2,j,k)$(Line(i1,i2,j) and Ctg(k))
  = (  lineCtgCurrReal2(i1,i2,j,k) * busCtgVoltMag(i2,k) * cos(busCtgVoltAng(i2,k))
     + lineCtgCurrImag2(i1,i2,j,k) * busCtgVoltMag(i2,k) * sin(busCtgVoltAng(i2,k)))$LineCtgActive(i1,i2,j,k);
lineCtgPowImag2(i1,i2,j,k)$(Line(i1,i2,j) and Ctg(k))
  = (  lineCtgCurrReal2(i1,i2,j,k) * busCtgVoltMag(i2,k) * sin(busCtgVoltAng(i2,k))
     - lineCtgCurrImag2(i1,i2,j,k) * busCtgVoltMag(i2,k) * cos(busCtgVoltAng(i2,k)))$LineCtgActive(i1,i2,j,k);
xfmrCtgCurrReal1(i1,i2,j,k)$(Xfmr(i1,i2,j) and Ctg(k))
  = (  XfmrGMag(i1,i2,j) * busCtgVoltMag(i1,k) * cos(busCtgVoltAng(i1,k))
     - XfmrBMag(i1,i2,j) * busCtgVoltMag(i1,k) * sin(busCtgVoltAng(i1,k))
     + (  XfmrG(i1,i2,j) * cos(XfmrAng(i1,i2,j))
        - XfmrB(i1,i2,j) * sin(XfmrAng(i1,i2,j)))
     * (  busCtgVoltMag(i1,k) / sqr(XfmrRatio(i1,i2,j)) * cos(busCtgVoltAng(i1,k) - XfmrAng(i1,i2,j))
        - busCtgVoltMag(i2,k) / XfmrRatio(i1,i2,j) * cos(busCtgVoltAng(i2,k)))
     - (  XfmrG(i1,i2,j) * sin(XfmrAng(i1,i2,j))
        + XfmrB(i1,i2,j) * cos(XfmrAng(i1,i2,j)))
     * (  busCtgVoltMag(i1,k) / sqr(XfmrRatio(i1,i2,j)) * sin(busCtgVoltAng(i1,k) - XfmrAng(i1,i2,j))
        - busCtgVoltMag(i2,k) / XfmrRatio(i1,i2,j) * sin(busCtgVoltAng(i2,k))))$XfmrCtgActive(i1,i2,j,k);
xfmrCtgCurrImag1(i1,i2,j,k)$(Xfmr(i1,i2,j) and Ctg(k))
  = (  XfmrGMag(i1,i2,j) * busCtgVoltMag(i1,k) * sin(busCtgVoltAng(i1,k))
     + XfmrBMag(i1,i2,j) * busCtgVoltMag(i1,k) * cos(busCtgVoltAng(i1,k))
     + (  XfmrG(i1,i2,j) * cos(XfmrAng(i1,i2,j))
        - XfmrB(i1,i2,j) * sin(XfmrAng(i1,i2,j)))
     * (  busCtgVoltMag(i1,k) / sqr(XfmrRatio(i1,i2,j)) * sin(busCtgVoltAng(i1,k) - XfmrAng(i1,i2,j))
        - busCtgVoltMag(i2,k) / XfmrRatio(i1,i2,j) * sin(busCtgVoltAng(i2,k)))
     + (  XfmrG(i1,i2,j) * sin(XfmrAng(i1,i2,j))
        + XfmrB(i1,i2,j) * cos(XfmrAng(i1,i2,j)))
     * (  busCtgVoltMag(i1,k) / sqr(XfmrRatio(i1,i2,j)) * cos(busCtgVoltAng(i1,k) - XfmrAng(i1,i2,j))
        - busCtgVoltMag(i2,k) / XfmrRatio(i1,i2,j) * cos(busCtgVoltAng(i2,k))))$XfmrCtgActive(i1,i2,j,k);
xfmrCtgCurrReal2(i1,i2,j,k)$(Xfmr(i1,i2,j) and Ctg(k))
  = (  XfmrG(i1,i2,j)
     * (  busCtgVoltMag(i2,k) * cos(busCtgVoltAng(i2,k))
        - busCtgVoltMag(i1,k) / XfmrRatio(i1,i2,j) * cos(busCtgVoltAng(i1,k) - XfmrAng(i1,i2,j)))
     - XfmrB(i1,i2,j)
     * (  busCtgVoltMag(i2,k) * sin(busCtgVoltAng(i2,k))
        - busCtgVoltMag(i1,k) / XfmrRatio(i1,i2,j) * sin(busCtgVoltAng(i1,k) - XfmrAng(i1,i2,j))))$XfmrCtgActive(i1,i2,j,k);
xfmrCtgCurrImag2(i1,i2,j,k)$(Xfmr(i1,i2,j) and Ctg(k))
  = (  XfmrG(i1,i2,j)
     * (  busCtgVoltMag(i2,k) * sin(busCtgVoltAng(i2,k))
        - busCtgVoltMag(i1,k) / XfmrRatio(i1,i2,j) * sin(busCtgVoltAng(i1,k) - XfmrAng(i1,i2,j)))
     +    XfmrB(i1,i2,j)
     * (  busCtgVoltMag(i2,k) * cos(busCtgVoltAng(i2,k))
        - busCtgVoltMag(i1,k) / XfmrRatio(i1,i2,j) * cos(busCtgVoltAng(i1,k) - XfmrAng(i1,i2,j))))$XfmrCtgActive(i1,i2,j,k);
xfmrCtgPowReal1(i1,i2,j,k)$(Xfmr(i1,i2,j) and Ctg(k))
  = (  xfmrCtgCurrReal1(i1,i2,j,k) * busCtgVoltMag(i1,k) * cos(busCtgVoltAng(i1,k))
     + xfmrCtgCurrImag1(i1,i2,j,k) * busCtgVoltMag(i1,k) * sin(busCtgVoltAng(i1,k)))$XfmrCtgActive(i1,i2,j,k);
xfmrCtgPowImag1(i1,i2,j,k)$(Xfmr(i1,i2,j) and Ctg(k))
  = (  xfmrCtgCurrReal1(i1,i2,j,k) * busCtgVoltMag(i1,k) * sin(busCtgVoltAng(i1,k))
     - xfmrCtgCurrImag1(i1,i2,j,k) * busCtgVoltMag(i1,k) * cos(busCtgVoltAng(i1,k)))$XfmrCtgActive(i1,i2,j,k);
xfmrCtgPowReal2(i1,i2,j,k)$(Xfmr(i1,i2,j) and Ctg(k))
  = (  xfmrCtgCurrReal2(i1,i2,j,k) * busCtgVoltMag(i2,k) * cos(busCtgVoltAng(i2,k))
     + xfmrCtgCurrImag2(i1,i2,j,k) * busCtgVoltMag(i2,k) * sin(busCtgVoltAng(i2,k)))$XfmrCtgActive(i1,i2,j,k);
xfmrCtgPowImag2(i1,i2,j,k)$(Xfmr(i1,i2,j) and Ctg(k))
  = (  xfmrCtgCurrReal2(i1,i2,j,k) * busCtgVoltMag(i2,k) * sin(busCtgVoltAng(i2,k))
     - xfmrCtgCurrImag2(i1,i2,j,k) * busCtgVoltMag(i2,k) * cos(busCtgVoltAng(i2,k)))$XfmrCtgActive(i1,i2,j,k);
swshCtgPowImag(i,k)$(Swsh(i) and Ctg(k))
  = - swshCtgAdmImag(i,k) * sqr(busCtgVoltMag(i,k)) $SwshActive(i);

* derived cost

* constraint violation values
busCtgVoltMagLoViol(i,k)$(Bus(i) and Ctg(k))
  = max(0, BusVMin(i) - busCtgVoltMag(i,k));
busCtgVoltMagUpViol(i,k)
  = max(0, busCtgVoltMag(i,k) - BusVMax(i));
genCtgPowRealLoViol(i,j,k)$(Gen(i,j) and Ctg(k))
  = max(0, GenPMin(i,j)$GenCtgActive(i,j,k) - genCtgPowReal(i,j,k));
genCtgPowRealUpViol(i,j,k)$(Gen(i,j) and Ctg(k))
  = max(0, genCtgPowReal(i,j,k) - GenPMax(i,j)$GenCtgActive(i,j,k));
genCtgPowImagLoViol(i,j,k)$(Gen(i,j) and Ctg(k))
  = max(0, GenQMin(i,j)$GenCtgActive(i,j,k) - genCtgPowImag(i,j,k));
genCtgPowImagUpViol(i,j,k)$(Gen(i,j) and Ctg(k))
  = max(0, genCtgPowImag(i,j,k) - GenQMax(i,j)$GenCtgActive(i,j,k));
lineCtgCurrMag1UpViol(i1,i2,j,k)$(Line(i1,i2,j) and Ctg(k))
  = max(0,
          sqrt(  sqr(LineCtgCurrReal1(i1,i2,j,k))
	       + sqr(LineCtgCurrImag1(i1,i2,j,k)))
	- LineFlowMax(i1,i2,j)$LineCtgActive(i1,i2,j,k));
lineCtgCurrMag2UpViol(i1,i2,j,k)$(Line(i1,i2,j) and Ctg(k))
  = max(0,
          sqrt(  sqr(LineCtgCurrReal2(i1,i2,j,k))
	       + sqr(LineCtgCurrImag2(i1,i2,j,k)))
	- LineFlowMax(i1,i2,j)$LineCtgActive(i1,i2,j,k));
xfmrCtgPowMag1UpViol(i1,i2,j,k)$(Xfmr(i1,i2,j) and Ctg(k))
  = max(0,
          sqrt(  sqr(XfmrCtgPowReal1(i1,i2,j,k))
	       + sqr(XfmrCtgPowImag1(i1,i2,j,k)))
	- XfmrFlowMax(i1,i2,j)$XfmrCtgActive(i1,i2,j,k));
xfmrCtgPowMag2UpViol(i1,i2,j,k)$(Xfmr(i1,i2,j) and Ctg(k))
  = max(0,
          sqrt(  sqr(XfmrCtgPowReal2(i1,i2,j,k))
	       + sqr(XfmrCtgPowImag2(i1,i2,j,k)))
	- XfmrFlowMax(i1,i2,j)$XfmrCtgActive(i1,i2,j,k));
swshCtgAdmImagLoViol(i,k)$(Swsh(i) and Ctg(k))
  = max(0, SwshBMin(i)$SwshActive(i) - swshCtgAdmImag(i,k));
swshCtgAdmImagUpViol(i,k)$(Swsh(i) and Ctg(k))
  = max(0, swshCtgAdmImag(i,k) - SwshBMax(i)$SwshActive(i));
busCtgPowRealBalanceViol(i,k)$(Bus(i) and Ctg(k))
  = abs(  sum(j$GenCtgActive(i,j,k), genCtgPowReal(i,j,k))
        - sum(j$LoadActive(i,j), loadCtgPowReal(i,j,k))
        - sum(j$FxshActive(i,j), fxshCtgPowReal(i,j,k))
        - sum((i2,j)$LineCtgActive(i,i2,j,k), lineCtgPowReal1(i,i2,j,k))
        - sum((i1,j)$LineCtgActive(i1,i,j,k), lineCtgPowReal2(i1,i,j,k))
        - sum((i2,j)$XfmrCtgActive(i,i2,j,k), xfmrCtgPowReal1(i,i2,j,k))
        - sum((i1,j)$XfmrCtgActive(i1,i,j,k), xfmrCtgPowReal2(i1,i,j,k)));
busCtgPowImagBalanceViol(i,k)$(Bus(i) and Ctg(k))
  = abs(  sum(j$GenCtgActive(i,j,k), genCtgPowImag(i,j,k))
        - sum(j$LoadActive(i,j), loadCtgPowImag(i,j,k))
        - sum(j$FxshActive(i,j), fxshCtgPowImag(i,j,k))
        - sum((i2,j)$LineCtgActive(i,i2,j,k), lineCtgPowImag1(i,i2,j,k))
        - sum((i1,j)$LineCtgActive(i1,i,j,k), lineCtgPowImag2(i1,i,j,k))
        - sum((i2,j)$XfmrCtgActive(i,i2,j,k), xfmrCtgPowImag1(i,i2,j,k))
        - sum((i1,j)$XfmrCtgActive(i1,i,j,k), xfmrCtgPowImag2(i1,i,j,k))
        - swshCtgPowImag(i,k)$SwshActive(i));
busCtgVoltMagPowImagCompViol(i,k)$BusCtgVoltMagMaintDom(i,k)
  = max(min(max(0, busVoltMag(i) - busCtgVoltMag(i,k)),
            max(0, sum((i1,j1)$GenBusCtgVoltMagMaintDom(i1,j1,i,k),
      	               GenQMax(i1,j1) - genCtgPowImag(i1,j1,k)))),
        min(max(0, busCtgVoltMag(i,k) - busVoltMag(i)),
            max(0, sum((i1,j1)$GenBusCtgVoltMagMaintDom(i1,j1,i,k),
      	               genCtgPowImag(i1,j1,k) - GenQMin(i1,j1)))));

* compute summaries
sumBusCtgVoltMagLoViol = sum((i,k)$(Bus(i) and Ctg(k)), BusCtgVoltMagLoViol(i,k));
sumBusCtgVoltMagUpViol = sum((i,k)$(Bus(i) and Ctg(k)), BusCtgVoltMagUpViol(i,k));
sumGenCtgPowRealLoViol = sum((i,j,k)$(Gen(i,j) and Ctg(k)), GenCtgPowRealLoViol(i,j,k));
sumGenCtgPowRealUpViol = sum((i,j,k)$(Gen(i,j) and Ctg(k)), GenCtgPowRealUpViol(i,j,k));
sumGenCtgPowImagLoViol = sum((i,j,k)$(Gen(i,j) and Ctg(k)), GenCtgPowImagLoViol(i,j,k));
sumGenCtgPowImagUpViol = sum((i,j,k)$(Gen(i,j) and Ctg(k)), GenCtgPowImagUpViol(i,j,k));
sumLineCtgCurrMag1UpViol = sum((i1,i2,j,k)$(Line(i1,i2,j) and Ctg(k)), LineCtgCurrMag1UpViol(i1,i2,j,k));
sumLineCtgCurrMag2UpViol = sum((i1,i2,j,k)$(Line(i1,i2,j) and Ctg(k)), LineCtgCurrMag2UpViol(i1,i2,j,k));
sumXfmrCtgPowMag1UpViol = sum((i1,i2,j,k)$(Xfmr(i1,i2,j) and Ctg(k)), XfmrCtgPowMag1UpViol(i1,i2,j,k));
sumXfmrCtgPowMag2UpViol = sum((i1,i2,j,k)$(Xfmr(i1,i2,j) and Ctg(k)), XfmrCtgPowMag2UpViol(i1,i2,j,k));
sumSwshCtgAdmImagLoViol = sum((i,k)$(Swsh(i) and Ctg(k)), SwshCtgAdmImagLoViol(i,k));
sumSwshCtgAdmImagUpViol = sum((i,k)$(Swsh(i) and Ctg(k)), SwshCtgAdmImagUpViol(i,k));
sumBusCtgPowRealBalanceViol = sum((i,k)$(Bus(i) and Ctg(k)), BusCtgPowRealBalanceViol(i,k));
sumBusCtgPowImagBalanceViol = sum((i,k)$(Bus(i) and Ctg(k)), BusCtgPowImagBalanceViol(i,k));
sumBusCtgVoltMagPowImagCompViol = sum((i,k)$(Bus(i) and Ctg(k)), BusCtgVoltMagPowImagCompViol(i,k));
maxBusCtgVoltMagLoViol = smax((i,k)$(Bus(i) and Ctg(k)), BusCtgVoltMagLoViol(i,k));
maxBusCtgVoltMagUpViol = smax((i,k)$(Bus(i) and Ctg(k)), BusCtgVoltMagUpViol(i,k));
maxGenCtgPowRealLoViol = smax((i,j,k)$(Gen(i,j) and Ctg(k)), GenCtgPowRealLoViol(i,j,k));
maxGenCtgPowRealUpViol = smax((i,j,k)$(Gen(i,j) and Ctg(k)), GenCtgPowRealUpViol(i,j,k));
maxGenCtgPowImagLoViol = smax((i,j,k)$(Gen(i,j) and Ctg(k)), GenCtgPowImagLoViol(i,j,k));
maxGenCtgPowImagUpViol = smax((i,j,k)$(Gen(i,j) and Ctg(k)), GenCtgPowImagUpViol(i,j,k));
maxLineCtgCurrMag1UpViol = smax((i1,i2,j,k)$(Line(i1,i2,j) and Ctg(k)), LineCtgCurrMag1UpViol(i1,i2,j,k));
maxLineCtgCurrMag2UpViol = smax((i1,i2,j,k)$(Line(i1,i2,j) and Ctg(k)), LineCtgCurrMag2UpViol(i1,i2,j,k));
maxXfmrCtgPowMag1UpViol = smax((i1,i2,j,k)$(Xfmr(i1,i2,j) and Ctg(k)), XfmrCtgPowMag1UpViol(i1,i2,j,k));
maxXfmrCtgPowMag2UpViol = smax((i1,i2,j,k)$(Xfmr(i1,i2,j) and Ctg(k)), XfmrCtgPowMag2UpViol(i1,i2,j,k));
maxSwshCtgAdmImagLoViol = smax((i,k)$(Swsh(i) and Ctg(k)), SwshCtgAdmImagLoViol(i,k));
maxSwshCtgAdmImagUpViol = smax((i,k)$(Swsh(i) and Ctg(k)), SwshCtgAdmImagUpViol(i,k));
maxBusCtgPowRealBalanceViol = smax((i,k)$(Bus(i) and Ctg(k)), BusCtgPowRealBalanceViol(i,k));
maxBusCtgPowImagBalanceViol = smax((i,k)$(Bus(i) and Ctg(k)), BusCtgPowImagBalanceViol(i,k));
maxBusCtgVoltMagPowImagCompViol = smax((i,k)$(Bus(i) and Ctg(k)), BusCtgVoltMagPowImagCompViol(i,k));
