$title equations
$ontext
declare equations used by the Grid Optimization Competitions models
Names use the equation name convention, with names composed of multiple words
with no separating character, each word in lower case letters except that
the initial letter of each word is capitalized, except for the first word
of a name, which is all lower case:

  gridOptimizationCompetition
  
$offtext

equations
  costDef
  objDefSubBase
  objDefSubCtg
  genCostExpansionByPl(i,j)
  genPowRealExpansionByPl(i,j)
  genExpansionByPl(i,j)
  busPowRealBalance(i)
  busPowImagBalance(i)
  loadPowRealDef(i,j)
  loadPowImagDef(i,j)
  fxshPowRealDef(i,j)
  fxshPowImagDef(i,j)
  lineCurrMag1Bound(i1,i2,j)
  lineCurrMag2Bound(i1,i2,j)
  lineCurrReal1Def(i1,i2,j)
  lineCurrImag1Def(i1,i2,j)
  lineCurrReal2Def(i1,i2,j)
  lineCurrImag2Def(i1,i2,j)
  linePowReal1Def(i1,i2,j)
  linePowImag1Def(i1,i2,j)
  linePowReal2Def(i1,i2,j)
  linePowImag2Def(i1,i2,j)
  xfmrPowMag1Bound(i1,i2,j)
  xfmrPowMag2Bound(i1,i2,j)
  xfmrCurrReal1Def(i1,i2,j)
  xfmrCurrImag1Def(i1,i2,j)
  xfmrCurrReal2Def(i1,i2,j)
  xfmrCurrImag2Def(i1,i2,j)
  xfmrPowReal1Def(i1,i2,j)
  xfmrPowImag1Def(i1,i2,j)
  xfmrPowReal2Def(i1,i2,j)
  xfmrPowImag2Def(i1,i2,j)
  swshPowImagDef(i)
  busCtgPowRealBalance(i,k)
  busCtgPowImagBalance(i,k)
  loadCtgPowRealDef(i,j,k)
  loadCtgPowImagDef(i,j,k)
  fxshCtgPowRealDef(i,j,k)
  fxshCtgPowImagDef(i,j,k)
  lineCtgCurrMag1Bound(i1,i2,j,k)
  lineCtgCurrMag2Bound(i1,i2,j,k)
  lineCtgCurrReal1Def(i1,i2,j,k)
  lineCtgCurrImag1Def(i1,i2,j,k)
  lineCtgCurrReal2Def(i1,i2,j,k)
  lineCtgCurrImag2Def(i1,i2,j,k)
  lineCtgPowReal1Def(i1,i2,j,k)
  lineCtgPowImag1Def(i1,i2,j,k)
  lineCtgPowReal2Def(i1,i2,j,k)
  lineCtgPowImag2Def(i1,i2,j,k)
  xfmrCtgPowMag1Bound(i1,i2,j,k)
  xfmrCtgPowMag2Bound(i1,i2,j,k)
  xfmrCtgCurrReal1Def(i1,i2,j,k)
  xfmrCtgCurrImag1Def(i1,i2,j,k)
  xfmrCtgCurrReal2Def(i1,i2,j,k)
  xfmrCtgCurrImag2Def(i1,i2,j,k)
  xfmrCtgPowReal1Def(i1,i2,j,k)
  xfmrCtgPowImag1Def(i1,i2,j,k)
  xfmrCtgPowReal2Def(i1,i2,j,k)
  xfmrCtgPowImag2Def(i1,i2,j,k)
  swshCtgPowImagDef(i,k)
  genCtgPowRealMaint(i,j,k)
  genCtgPowRealDroop(i,j,k)
  genCtgPowRealMaxBound(i,j,k)
  genCtgPowRealMinBound(i,j,k)
  busCtgVoltMagMaint(i,k)
  busCtgPowImagMaxBound(i,k)
  busCtgPowImagMinBound(i,k);
