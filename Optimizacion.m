% Script de Optmizacion

ObjectiveFunction = @func_obj;

nvars = 2;    % Number of variables
LB = [-45 -45];   % Lower bound
UB = [45 45];  % Upper bound


[x,fval] = ga(ObjectiveFunction,nvars,[],[],[],[],LB,UB, ...
    ConstraintFunction);


