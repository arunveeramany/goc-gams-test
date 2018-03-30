$title convert_solution_ctg
$ontext
Convert solution from per unit (p.u.) convention to the mixed convention
(some physical, some p.u.)
used in GOComp data and solution files.
Convert only those values that are reported in the COComp
solution files
$offtext

* independent variable values set from solution levels
* these values are needed in the solution file
busCtgVoltMagSol(i,k)$(Bus(i) and Ctg(k)) = busCtgVoltMag(i,k);
busCtgVoltAngSol(i,k)$(Bus(i) and Ctg(k)) = busCtgVoltAng(i,k) * 180 / pi;
genCtgPowImagSol(i,j,k)$(Gen(i,j) and Ctg(k)) = genCtgPowImag(i,j,k) * BaseMVA;
swshCtgAdmImagSol(i,k)$(Swsh(i) and Ctg(k)) = swshCtgAdmImag(i,k) * BaseMVA;
areaCtgPowRealChangeSol(i,k)$(Area(i) and Ctg(k)) = areaCtgPowRealChange(i,k) * BaseMVA;
