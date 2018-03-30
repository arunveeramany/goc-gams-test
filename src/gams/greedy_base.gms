$title greedy_base.gms
$ontext
solve base case in greedy heuristic
$offtext

# step 1 subproblem solve
solve subModelBase using nlp minimizing objVar;
MaxInfeas = subModelBase.maxinfes;

$include solution_evaluation_base.gms
$include convert_solution_base.gms
$include write_solution_base.gms
