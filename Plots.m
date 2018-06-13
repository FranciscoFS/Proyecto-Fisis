% Script Gráficos

% Boxplot de las fifis 

A = t.Vol_femur(t.Vol_femur>0);
B = t.Vol_tibia(t.Vol_tibia>0);
C = t.Vol_perone(t.Vol_perone>0);

group = [ones(size(A));
         2 * ones(size(B));
         3 * ones(size(C))];

figure
boxplot([A; B; C],group)
ax = gca;
ax.YLabel.FontSize = 20;
ax.XLabel.FontSize = 20;
set(ax,'XTickLabel',{'Femur','Tibia','Perone'})

%% Box plots entre sexo

ind = t.Vol_femur > 0;

figure
boxplot(t.Vol_femur(ind),t.Sexo(ind));
ax = gca;
set(ax,'XTickLabel',{'Masculino','Femenino'})
[h,p,ci,~] = ttest2(Femur(Sexo == 'F'),Femur(Sexo == 'M'),'alpha',0.05);





%% Prueba de Normalidad

mu = mean(t.Vol_perone(t.Vol_perone>0));
sigma = std(t.Vol_perone(t.Vol_perone>0));

[f,x_values] = ecdf(t.Vol_perone(t.Vol_perone>0));
F = plot(x_values,f);
set(F,'LineWidth',2);
hold on;
G = plot(x_values,normcdf(x_values,mu,sigma),'r-');
set(G,'LineWidth',2);
legend([F G],...
       'Empirical CDF','Standard Normal CDF',...
       'Location','SE')

   
 %% Test chi- cuadrado
 

 Test_dist = makedist('normal','mu',mu,'sigma',sigma);
 
 [h1,p1,stats] = chi2gof(t.Vol_perone(t.Vol_perone>0))
 [h2,p2,ksstat,cv] = kstest(t.Vol_perone(t.Vol_perone>0),'CDF',Test_dist)

