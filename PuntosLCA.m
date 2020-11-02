%% Calculo puntos

Pendientes = 1:numel(BD_F_LCA_ang);
aux = 0;
BD_F_Intra = struct([]);

%%
for k=Pendientes
    
    Rodilla = BD_F_LCA_ang(k).Rodilla;
    Rodilla_new = Punto_LCA_femur_manual(Rodilla);
    BD_F_Intra(k).Rodilla = Punto_LCA_tibia_2(Rodilla_new);
    
end

%% Calculo ICC

Old = {};
New = {};

for k = Pendientes
    
    Rodilla_old  = BD_F_LCA_ang(k).Rodilla;
    Rodilla_new = BD_F_Intra(k).Rodilla;
    Old(k,1:3) = Rodilla_old.info(10:12);
    New(k,1:3) = Rodilla_new.info(10:12);
    
end

%% ICC Femur
ICCs = zeros(4,4);

Old_F = cell2mat(Old(:,3));
New_F = cell2mat(New(:,3));
Old_T = cell2mat(Old(:,2));
New_T = cell2mat(New(:,2));

[ICCs(1,1), ICCs(1,2), ICCs(1,3), F, df1, df2, ICCs(1,4)] = ICC([Old_F(:,1) New_F(:,1)],'A-1',0.05,0.5);
[ICCs(2,1), ICCs(2,2), ICCs(2,3), F, df1, df2, ICCs(2,4)] = ICC([Old_F(:,2) New_F(:,2)],'A-1',0.05,0.5);
[ICCs(3,1), ICCs(3,2), ICCs(3,3), F, df1, df2, ICCs(3,4)] = ICC([Old_T(:,2) New_T(:,2)],'A-1',0.05,0.5);
[ICCs(4,1), ICCs(4,2), ICCs(4,3), F, df1, df2, ICCs(4,4)] = ICC([Old_T(:,3) New_T(:,3)],'A-1',0.05,0.5);


Coeficientes = array2table(ICCs,'RowNames',{'FemurX','FemurY','TibiaX','TibiaY'},...
   'VariableNames',{'ICC','ICC_L','ICC_U','P'});
 
