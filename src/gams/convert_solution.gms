$title convert_solution
$ontext
Convert solution from per unit (p.u.) convention to the mixed convention
(some physical, some p.u.)
used in GOComp data and solution files.
Convert only those values that are reported in the COComp
solution files
$offtext

* independent variable values set from solution levels
* these values are needed in the solution file
#busVoltMag(i)$Bus(i)
busVoltAng(i)$Bus(i) = busVoltAng(i) * 180 / pi;
genPowReal(i,j)$Gen(i,j) = genPowReal(i,j) * BaseMVA;
genPowImag(i,j)$Gen(i,j) = genPowImag(i,j) * BaseMVA;
swshAdmImag(i)$Swsh(i) = swshAdmImag(i) * BaseMVA;
#busCtgVoltMag(i,k)$(Bus(i) and Ctg(k))
busCtgVoltAng(i,k)$(Bus(i) and Ctg(k)) = busCtgVoltAng(i,k) * 180 / pi;
genCtgPowImag(i,j,k)$(Gen(i,j) and Ctg(k)) = genCtgPowImag(i,j,k) * BaseMVA;
swshCtgAdmImag(i,k)$(Swsh(i) and Ctg(k)) = swshCtgAdmImag(i,k) * BaseMVA;
areaCtgPowRealChange(i,k)$(Area(i) and Ctg(k)) = areaCtgPowRealChange(i,k) * BaseMVA;

* derived variable values
* and
* derived cost
* do not bother converting these
* as they are not reported to the GOComp solution files
$ontext
loadPowReal(i,j)$Load(i,j)
loadPowImag(i,j)$Load(i,j)
fxshPowReal(i,j)$Fxsh(i,j)
fxshPowImag(i,j)$Fxsh(i,j)
lineCurrReal1(i1,i2,j)$Line(i1,i2,j)
lineCurrImag1(i1,i2,j)$Line(i1,i2,j)
lineCurrReal2(i1,i2,j)$Line(i1,i2,j)
lineCurrImag2(i1,i2,j)$Line(i1,i2,j)
linePowReal1(i1,i2,j)$Line(i1,i2,j)
linePowImag1(i1,i2,j)$Line(i1,i2,j)
linePowReal2(i1,i2,j)$Line(i1,i2,j)
linePowImag2(i1,i2,j)$Line(i1,i2,j)
xfmrCurrReal1(i1,i2,j)$Xfmr(i1,i2,j)
xfmrCurrImag1(i1,i2,j)$Xfmr(i1,i2,j)
xfmrCurrReal2(i1,i2,j)$Xfmr(i1,i2,j)
xfmrCurrImag2(i1,i2,j)$Xfmr(i1,i2,j)
xfmrPowReal1(i1,i2,j)$Xfmr(i1,i2,j)
xfmrPowImag1(i1,i2,j)$Xfmr(i1,i2,j)
xfmrPowReal2(i1,i2,j)$Xfmr(i1,i2,j)
xfmrPowImag2(i1,i2,j)$Xfmr(i1,i2,j)
swshPowImag(i)$Swsh(i)
loadCtgPowReal(i,j,k)$(Load(i,j) and Ctg(k))
loadCtgPowImag(i,j,k)$(Load(i,j) and Ctg(k))
fxshCtgPowReal(i,j,k)$(Fxsh(i,j) and Ctg(k))
fxshCtgPowImag(i,j,k)$(Fxsh(i,j) and Ctg(k))
genCtgPowReal(i,j,k)$(Gen(i,j) and Ctg(k))
lineCtgCurrReal1(i1,i2,j,k)$(Line(i1,i2,j) and Ctg(k))
lineCtgCurrImag1(i1,i2,j,k)$(Line(i1,i2,j) and Ctg(k))
lineCtgCurrReal2(i1,i2,j,k)$(Line(i1,i2,j) and Ctg(k))
lineCtgCurrImag2(i1,i2,j,k)$(Line(i1,i2,j) and Ctg(k))
lineCtgPowReal1(i1,i2,j,k)$(Line(i1,i2,j) and Ctg(k))
lineCtgPowImag1(i1,i2,j,k)$(Line(i1,i2,j) and Ctg(k))
lineCtgPowReal2(i1,i2,j,k)$(Line(i1,i2,j) and Ctg(k))
lineCtgPowImag2(i1,i2,j,k)$(Line(i1,i2,j) and Ctg(k))
xfmrCtgCurrReal1(i1,i2,j,k)$(Xfmr(i1,i2,j) and Ctg(k))
xfmrCtgCurrImag1(i1,i2,j,k)$(Xfmr(i1,i2,j) and Ctg(k))
xfmrCtgCurrReal2(i1,i2,j,k)$(Xfmr(i1,i2,j) and Ctg(k))
xfmrCtgCurrImag2(i1,i2,j,k)$(Xfmr(i1,i2,j) and Ctg(k))
xfmrCtgPowReal1(i1,i2,j,k)$(Xfmr(i1,i2,j) and Ctg(k))
xfmrCtgPowImag1(i1,i2,j,k)$(Xfmr(i1,i2,j) and Ctg(k))
xfmrCtgPowReal2(i1,i2,j,k)$(Xfmr(i1,i2,j) and Ctg(k))
xfmrCtgPowImag2(i1,i2,j,k)$(Xfmr(i1,i2,j) and Ctg(k))
swshCtgPowImag(i,k)$(Swsh(i) and Ctg(k))
genPlCoeff(i,j,i1)$(GenActive(i,j) and GenPl(i,j,i1)) = 0; # TODO fix this
genCost(i,j)$GenActive(i,j)
cost
$offtext