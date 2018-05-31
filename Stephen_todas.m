% Script para correr sobre toda las rodillas terminadas


folder = uigetdir();
DIM = dir(folder);
%Dir_out = '/Users/franciscofernandezschlein/Google Drive/Uc/LPFM/Terminadas_finales/';
%fields_out = {'femur','perone','tibia','rotula'};

Vol_femur = [];
Vol_tibia = [];
Vol_perone = [];
Info = {};
Name = {};
Status = [];
Ax_Y = [];


for k=1:numel(DIM)

    if not(DIM(k).isdir) && length(DIM(k).name) > 12
        
        fprintf('Processing..... %s \n', DIM(k).name);
        V_load = load([DIM(k).folder '/' DIM(k).name],'V_seg');
        V = V_load.V_seg;
        Ay = Angulos_Y(V);
        %V_out = Stephen_auto(V_out);
        %V_out = rmfield(V_out,fields_out);
        %Angulos_Y(end +1) = V_out.info{7};
        %save([Dir_out DIM(k).name],'V_out')
        [Vols,Check] = Volumenes_fisis(V);
        Info(end+1,1:6) = V.info';
        Vol_femur(end+1) = Vols.femur;
        Vol_tibia(end+1) = Vols.tibia;
        Vol_perone(end+1) = Vols.perone;
        Name{end+1} = DIM(k).name;
        Status(end+1,1:3) = Check;
        Ax_Y(end+1,:) = Ay;
        fprintf('Saved..... %s \n', DIM(k).name);
        
    end
    
end

Var_names = {'Nombre','Vol_femur','Vol_tibia','Vol_perone','Edad','Sexo','F_femur','F_tibia','F_perone','Ax_Y'};

t = table(Name',Vol_femur',Vol_tibia',Vol_perone', Info(:,5) , Info(:,6),Status(:,1),...
    Status(:,2),Status(:,3),Ax_Y);

t.Properties.VariableNames= Var_names;        
        