$title run
$ontext
Run the GAMS benchmark code.
$offtext

$eolcom #
$include data_parameters.gms
$include algorithm_parameters.gms
$include solution_parameters.gms
$include variables.gms
$include equations.gms
$include models.gms
$include variable_bounds.gms
$include equation_definitions.gms
$include start_point.gms
#$include solve_comp.gms
#$include decomposition.gms
$include greedy.gms
$include solution_evaluation.gms
$include display_solution.gms
$include write_summary.gms
$include convert_solution.gms
$include write_solution_1.gms
$include write_solution_2.gms
