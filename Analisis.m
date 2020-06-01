%% Análisis Estadístico Gobbi Troclea

Medians = groupsummary(VariablesTroclea(:,6:end),'Categoria','median');
Iqr_Dpls = iqr(VariablesTroclea{Indice_controles_Tr==1,6:end-1});
Iqr_Control = iqr(VariablesTroclea{Indice_controles_Tr==0,6:end-1});

[Mu,CI_control] = Mean_CI(VariablesTroclea{Indice_controles_Tr==0,6:end-1});
[Mu,CI_Dis] = Mean_CI(VariablesTroclea{Indice_controles_Tr==1,6:end-1});

pos = (3:7);
Variables = {'BDP dist f1','BDP dist f2','BPD dist g1','BPD dist g2','BPD dist trocle'};
figure;
set(gcf,'color','white')

for k=1:length(pos)
    
    subplot(2,3,k);
    gca.Color = 'white';
    bar(Medians{:,pos(k)}');
    hold on;
    er = errorbar(Medians{:,pos(k)},  Medians{:,pos(k)} - [CI_control.Down(k) CI_Dis.Down(k)]');
    er.LineStyle = 'none';  
    er.LineWidth = 2;
    title(Variables(k),'FontSize',16);
    
end

[h,p] = ttest2(VariablesTroclea{Indice_controles_Tr==1,6:10},VariablesTroclea{Indice_controles_Tr==0,6:10});
%% Análisis Estadístico Gobbi Morfologia

Variables = [2:8,12:17,21:23];
[h,p] = ttest2(Morfologa{Indice_controles_M==1,Variables},Morfologa{Indice_controles_M==0,Variables});
aux = find(p <=0.05);
Var_utiles = [Variables(aux) 24];

Median = groupsummary(Morfologa(:,Var_utiles),'Categoria','median');
% Iqr_Dpls = iqr(Morfologa{Indice_controles_M==1,Variables(aux)});
% Iqr_Control = iqr(Morfologa{Indice_controles_M==0,Variables(aux)});

[Mu,CI_control] = Mean_CI(Morfologa{Indice_controles_M==0,Var_utiles});
[Mu,CI_Dis] = Mean_CI(Morfologa{Indice_controles_M==1,Var_utiles});

pos = (3:6);
Variables_Name = {'Prom Altura LM1','Prom Altura LM2','Max altura AP2','Max altura AP3'};
figure;
set(gcf,'color','white')

for k=1:length(pos)
    
    subplot(2,2,k);
    gca.Color = 'white';
    bar(Median{:,pos(k)}');
    hold on;
    er = errorbar(Median{:,pos(k)}', Median{:,pos(k)} - [CI_control.Down(k) CI_Dis.Down(k)]');
    er.LineStyle = 'none';
    er.LineWidth = 2;
    title(Variables_Name(k),'FontSize',16);
    
end

%%