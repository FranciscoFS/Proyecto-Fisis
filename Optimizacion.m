% Script de Optmizacion

ObjectiveFunction = @func_obj;

nvars = 2;    % Number of variables
LB = [-10 -10];   % Lower bound
UB = [10 10];  % Upper bound


[x,fval] = ga(ObjectiveFunction,nvars,[],[],[],[],LB,UB);

