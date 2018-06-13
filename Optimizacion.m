% Script de Optmizacion

ObjectiveFunction = @func_obj;

nvars = 2;    % Number of variables
LB = [-45 -45];   % Lower bound
UB = [45 45];  % Upper bound

options = optimoptions('ga','MaxGenerations',1000,...
    'MaxStallGenerations',Inf,'PlotFcn',@gaplotbestf,'Display','iter');
[x,fval] = ga(ObjectiveFunction,2,[],[],[],[],LB,UB,[],options);

%%

options2 = optimoptions('PlotFcn'
[x2,fval2] = simulannealbnd(@func_obj,[0,0],LB,UB);

