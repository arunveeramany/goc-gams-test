$title run_greedy
$ontext
Run the GAMS benchmark code, greedy heuristic.
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
$include greedy_setup.gms
$include greedy_base.gms
$include greedy_ctg.gms
$include display_solution.gms
$include write_summary.gms
