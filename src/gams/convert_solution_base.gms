$title convert_solution_base
$ontext
Convert solution from per unit (p.u.) convention to the mixed convention
(some physical, some p.u.)
used in GOComp data and solution files.
Convert only those values that are reported in the COComp base case file
solution files
$offtext

* independent variable values set from solution levels
* these values are needed in the solution file
busVoltMagSol(i)$Bus(i) = busVoltMag(i);
busVoltAngSol(i)$Bus(i) = busVoltAng(i) * 180 / pi;
genPowRealSol(i,j)$Gen(i,j) = genPowReal(i,j) * BaseMVA;
genPowImagSol(i,j)$Gen(i,j) = genPowImag(i,j) * BaseMVA;
swshAdmImagSol(i)$Swsh(i) = swshAdmImag(i) * BaseMVA;
