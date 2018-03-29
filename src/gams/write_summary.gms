$title write_summary
$ontext
write a summary of the solution and other generic information, e.g. start point, execution time
$offtext

$if not set summary_file $set summary_file summary.txt

file summary /'%summary_file%'/;

put summary;
put 'Terminal point summary:' /;
put 'cost: ' cost:0:10 /;
put 'maxBusVoltMagLoViol: ' maxBusVoltMagLoViol:0:10 /;
put 'maxBusVoltMagUpViol: ' maxBusVoltMagUpViol:0:10 /;
put 'maxGenPowRealLoViol: ' maxGenPowRealLoViol:0:10 /;
put 'maxGenPowRealUpViol: ' maxGenPowRealUpViol:0:10 /;
put 'maxGenPowImagLoViol: ' maxGenPowImagLoViol:0:10 /;
put 'maxGenPowImagUpViol: ' maxGenPowImagUpViol:0:10 /;
put 'maxLineCurrMag1UpViol: ' maxLineCurrMag1UpViol:0:10 /;
put 'maxLineCurrMag2UpViol: ' maxLineCurrMag2UpViol:0:10 /;
put 'maxXfmrPowMag1UpViol: ' maxXfmrPowMag1UpViol:0:10 /;
put 'maxXfmrPowMag2UpViol: ' maxXfmrPowMag2UpViol:0:10 /;
put 'maxSwshAdmImagLoViol: ' maxSwshAdmImagLoViol:0:10 /;
put 'maxSwshAdmImagUpViol: ' maxSwshAdmImagUpViol:0:10 /;
put 'maxBusCtgVoltMagLoViol: ' maxBusCtgVoltMagLoViol:0:10 /;
put 'maxBusCtgVoltMagUpViol: ' maxBusCtgVoltMagUpViol:0:10 /;
put 'maxGenCtgPowRealLoViol: ' maxGenCtgPowRealLoViol:0:10 /;
put 'maxGenCtgPowRealUpViol: ' maxGenCtgPowRealUpViol:0:10 /;
put 'maxGenCtgPowImagLoViol: ' maxGenCtgPowImagLoViol:0:10 /;
put 'maxGenCtgPowImagUpViol: ' maxGenCtgPowImagUpViol:0:10 /;
put 'maxLineCtgCurrMag1UpViol: ' maxLineCtgCurrMag1UpViol:0:10 /;
put 'maxLineCtgCurrMag2UpViol: ' maxLineCtgCurrMag2UpViol:0:10 /;
put 'maxXfmrCtgPowMag1UpViol: ' maxXfmrCtgPowMag1UpViol:0:10 /;
put 'maxXfmrCtgPowMag2UpViol: ' maxXfmrCtgPowMag2UpViol:0:10 /;
put 'maxSwshCtgAdmImagLoViol: ' maxSwshCtgAdmImagLoViol:0:10 /;
put 'maxSwshCtgAdmImagUpViol: ' maxSwshCtgAdmImagUpViol:0:10 /;
put 'maxBusPowRealBalanceViol: ' maxBusPowRealBalanceViol:0:10 /;
put 'maxBusPowImagBalanceViol: ' maxBusPowImagBalanceViol:0:10 /;
put 'maxBusCtgPowRealBalanceViol: ' maxBusCtgPowRealBalanceViol:0:10 /;
put 'maxBusCtgPowImagBalanceViol: ' maxBusCtgPowImagBalanceViol:0:10 /;
put 'maxBusCtgVoltMagPowImagCompViol: ' maxBusCtgVoltMagPowImagCompViol:0:10 /;
putclose;