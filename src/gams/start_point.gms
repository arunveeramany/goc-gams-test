$title start_point
$ontext
set a start point for the optimization model
$offtext

* variables
$ontext
  totalCostVar
  genCostVar(i,j)
  genPlCoeffVar(i,j,i1)
  busVoltMagVar(i)
  busVoltAngVar(i)
  loadPowRealVar(i,j)
  loadPowImagVar(i,j)
  fxshPowRealVar(i,j)
  fxshPowImagVar(i,j)
  genPowRealVar(i,j)
  genPowImagVar(i,j)
  lineCurrReal1Var(i1,i2,j)
  lineCurrImag1Var(i1,i2,j)
  lineCurrReal2Var(i1,i2,j)
  lineCurrImag2Var(i1,i2,j)
  linePowReal1Var(i1,i2,j)
  linePowImag1Var(i1,i2,j)
  linePowReal2Var(i1,i2,j)
  linePowImag2Var(i1,i2,j)
  xfmrCurrReal1Var(i1,i2,j)
  xfmrCurrImag1Var(i1,i2,j)
  xfmrCurrReal2Var(i1,i2,j)
  xfmrCurrImag2Var(i1,i2,j)
  xfmrPowReal1Var(i1,i2,j)
  xfmrPowImag1Var(i1,i2,j)
  xfmrPowReal2Var(i1,i2,j)
  xfmrPowImag2Var(i1,i2,j)
  swshPowImagVar(i)
  swshAdmImagVar(i)
  busCtgVoltMagVar(i,k)
  busCtgVoltAngVar(i,k)
  loadCtgPowRealVar(i,j,k)
  loadCtgPowImagVar(i,j,k)
  fxshCtgPowRealVar(i,j,k)
  fxshCtgPowImagVar(i,j,k)
  genCtgPowRealVar(i,j,k)
  genCtgPowImagVar(i,j,k)
  lineCtgCurrReal1Var(i1,i2,j,k)
  lineCtgCurrImag1Var(i1,i2,j,k)
  lineCtgCurrReal2Var(i1,i2,j,k)
  lineCtgCurrImag2Var(i1,i2,j,k)
  lineCtgPowReal1Var(i1,i2,j,k)
  lineCtgPowImag1Var(i1,i2,j,k)
  lineCtgPowReal2Var(i1,i2,j,k)
  lineCtgPowImag2Var(i1,i2,j,k)
  xfmrCtgCurrReal1Var(i1,i2,j,k)
  xfmrCtgCurrImag1Var(i1,i2,j,k)
  xfmrCtgCurrReal2Var(i1,i2,j,k)
  xfmrCtgCurrImag2Var(i1,i2,j,k)
  xfmrCtgPowReal1Var(i1,i2,j,k)
  xfmrCtgPowImag1Var(i1,i2,j,k)
  xfmrCtgPowReal2Var(i1,i2,j,k)
  xfmrCtgPowImag2Var(i1,i2,j,k)
  swshCtgPowImagVar(i,k)
  swshCtgAdmImagVar(i,k)
  areaCtgPowRealChangeVar(i,k);
$offtext

*busVoltMagVar.l(i) = 1.0;
*busVoltAngVar.l(i) = 0.0;

* fix operating point for case14_0
$ontext
busVoltMagVar.fx('1') = 1.06;
busVoltMagVar.fx('2') = 1.045;
busVoltMagVar.fx('3') = 1.01;
busVoltMagVar.fx('4') = 1.01767;
busVoltMagVar.fx('5') = 1.01951;
busVoltMagVar.fx('6') = 1.07;
busVoltMagVar.fx('7') = 1.06152;
busVoltMagVar.fx('8') = 1.09;
busVoltMagVar.fx('9') = 1.05593;
busVoltMagVar.fx('10') = 1.05098;
busVoltMagVar.fx('11') = 1.05691;
busVoltMagVar.fx('12') = 1.05519;
busVoltMagVar.fx('13') = 1.05038;
busVoltMagVar.fx('14') = 1.03553;

busVoltAngVar.fx('1') = 0.0;
busVoltAngVar.fx('2') = -0.086962775;
busVoltAngVar.fx('3') = -0.222094893;
busVoltAngVar.fx('4') = -0.17999406;
busVoltAngVar.fx('5') = -0.153133443;
busVoltAngVar.fx('6') = -0.248203273;
busVoltAngVar.fx('7') = -0.233169007;
busVoltAngVar.fx('8') = -0.233169007;
busVoltAngVar.fx('9') = -0.26072601;
busVoltAngVar.fx('10') = -0.263497593;
busVoltAngVar.fx('11') = -0.258144668;
busVoltAngVar.fx('12') = -0.263118857;
busVoltAngVar.fx('13') = -0.264527337;
busVoltAngVar.fx('14') = -0.279839111;

genPowRealVar.fx('1','1') = 2.32392;
genPowRealVar.fx('2','1') = 0.4;
genPowRealVar.fx('3','1') = 0;
genPowRealVar.fx('6','1') = 0;
genPowRealVar.fx('8','1') = 0;

genPowImagVar.fx('1','1') = -0.16549;
genPowImagVar.fx('2','1') = 0.43556;
genPowImagVar.fx('3','1') = 0.25075;
genPowImagVar.fx('6','1') = 0.1273;
genPowImagVar.fx('8','1') = 0.17623;
$offtext
