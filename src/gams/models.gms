$title models
$ontext
declare and define models used by the Grid Optimization Competition
$offtext

models
  powerFlowBase /
    busPowRealBalance
    busPowImagBalance
    loadPowRealDef
    loadPowImagDef
    fxshPowRealDef
    fxshPowImagDef
    lineCurrMag1Bound
    lineCurrMag2Bound
    lineCurrReal1Def
    lineCurrImag1Def
    lineCurrReal2Def
    lineCurrImag2Def
    linePowReal1Def
    linePowImag1Def
    linePowReal2Def
    linePowImag2Def
    xfmrPowMag1Bound
    xfmrPowMag2Bound
    xfmrCurrReal1Def
    xfmrCurrImag1Def
    xfmrCurrReal2Def
    xfmrCurrImag2Def
    xfmrPowReal1Def
    xfmrPowImag1Def
    xfmrPowReal2Def
    xfmrPowImag2Def
    swshPowImagDef /
  powerFlowCtg /
    busCtgPowRealBalance
    busCtgPowImagBalance
    loadCtgPowRealDef
    loadCtgPowImagDef
    fxshCtgPowRealDef
    fxshCtgPowImagDef
    lineCtgCurrMag1Bound
    lineCtgCurrMag2Bound
    lineCtgCurrReal1Def
    lineCtgCurrImag1Def
    lineCtgCurrReal2Def
    lineCtgCurrImag2Def
    lineCtgPowReal1Def
    lineCtgPowImag1Def
    lineCtgPowReal2Def
    lineCtgPowImag2Def
    xfmrCtgPowMag1Bound
    xfmrCtgPowMag2Bound
    xfmrCtgCurrReal1Def
    xfmrCtgCurrImag1Def
    xfmrCtgCurrReal2Def
    xfmrCtgCurrImag2Def
    xfmrCtgPowReal1Def
    xfmrCtgPowImag1Def
    xfmrCtgPowReal2Def
    xfmrCtgPowImag2Def
    swshCtgPowImagDef
    /
  costModel /
    costDef
    genCostExpansionByPl
    genPowRealExpansionByPl # turn this off for the tamu cases until cost function covers pmin,pmax
    genExpansionByPl /
  reactionComplementarityModel /
    genCtgPowRealMaint
    genCtgPowRealDroop
    genCtgPowRealMaxBound.genCtgPowRealUnderVar
    genCtgPowRealMinBound.genCtgPowRealOverVar
    busCtgVoltMagMaint
    busCtgPowImagMaxBound.busCtgVoltMagUnderVar
    busCtgPowImagMinBound.busCtgVoltMagOverVar /
  reactionModel /
    genCtgPowRealMaint
    genCtgPowRealDroop
    #genCtgPowRealMaxBound
    #genCtgPowRealMinBound
    busCtgVoltMagMaint
    #busCtgPowImagMaxBound
    #busCtgPowImagMinBound
    /
  fullComplementarityModel /
    powerFlowBase
    powerFlowCtg
    costModel
    reactionComplementarityModel
    /
  fullModel /
    powerFlowBase
    powerFlowCtg
    costModel
    reactionModel
    /
  subModelBase /
    powerFlowBase
    costModel
    objDefSubBase /
  subModelCtg /
    powerFlowCtg
    #reactionComplementarityModel
    reactionModel
    objDefSubCtg /;