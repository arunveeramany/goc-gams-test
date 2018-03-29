$title solution_evaluation
$ontext
compute solution values
mimic GOComp solution evaluation procedure
$offtext

* independent variable values set from solution levels
* these values are needed in the solution file
busVoltMag(i)$Bus(i) = busVoltMagVar.l(i);
busVoltAng(i)$Bus(i) = busVoltAngVar.l(i);
genPowReal(i,j)$Gen(i,j) = genPowRealVar.l(i,j)$GenActive(i,j);
genPowImag(i,j)$Gen(i,j) = genPowImagVar.l(i,j)$GenActive(i,j);
swshAdmImag(i)$Swsh(i) = swshAdmImagVar.l(i)$SwshActive(i);
busCtgVoltMag(i,k)$(Bus(i) and Ctg(k)) = busCtgVoltMagVar.l(i,k);
busCtgVoltAng(i,k)$(Bus(i) and Ctg(k)) = busCtgVoltAngVar.l(i,k);
genCtgPowImag(i,j,k)$(Gen(i,j) and Ctg(k)) = genCtgPowImagVar.l(i,j,k)$GenCtgActive(i,j,k);
swshCtgAdmImag(i,k)$(Swsh(i) and Ctg(k)) = swshCtgAdmImagVar.l(i,k)$SwshActive(i);
areaCtgPowRealChange(i,k)$(Area(i) and Ctg(k)) = areaCtgPowRealChangeVar.l(i,k)$areaCtgAffected(i,k); # todo - do we need a domain here?

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
sumBusPowRealBalanceViol = sum(i$Bus(i), BusPowRealBalanceViol(i));
sumBusPowImagBalanceViol = sum(i$Bus(i), BusPowImagBalanceViol(i));
sumBusCtgPowRealBalanceViol = sum((i,k)$(Bus(i) and Ctg(k)), BusCtgPowRealBalanceViol(i,k));
sumBusCtgPowImagBalanceViol = sum((i,k)$(Bus(i) and Ctg(k)), BusCtgPowImagBalanceViol(i,k));
sumBusCtgVoltMagPowImagCompViol = sum((i,k)$(Bus(i) and Ctg(k)), BusCtgVoltMagPowImagCompViol(i,k));
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
maxBusPowRealBalanceViol = smax(i$Bus(i), BusPowRealBalanceViol(i));
maxBusPowImagBalanceViol = smax(i$Bus(i), BusPowImagBalanceViol(i));
maxBusCtgPowRealBalanceViol = smax((i,k)$(Bus(i) and Ctg(k)), BusCtgPowRealBalanceViol(i,k));
maxBusCtgPowImagBalanceViol = smax((i,k)$(Bus(i) and Ctg(k)), BusCtgPowImagBalanceViol(i,k));
maxBusCtgVoltMagPowImagCompViol = smax((i,k)$(Bus(i) and Ctg(k)), BusCtgVoltMagPowImagCompViol(i,k));
