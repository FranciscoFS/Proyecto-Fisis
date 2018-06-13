%% Script para correr sobre toda las rodillas terminadas y obtener el excel
% con info relevante


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
Ax_Z = [];

for k=1:numel(DIM)

    if not(DIM(k).isdir) && length(DIM(k).name) > 12
        
        fprintf('Processing..... %s \n', DIM(k).name);
        V_load = load([DIM(k).folder '/' DIM(k).name],'V_seg');
        V_out = V_load.V_seg;
        Ay = Angulos_Y(V_out);
        %V_out = Stephen_auto(V_out);
        %V_out = rmfield(V_out,fields_out);
        %Angulos_Y(end +1) = V_out.info{7};
        %save([Dir_out DIM(k).name],'V_out')
        [Vols,Check] = Volumenes_fisis(V_out);
        Info(end+1,1:6) = V_out.info';
        Vol_femur(end+1) = Vols.femur;
        Vol_tibia(end+1) = Vols.tibia;
        Vol_perone(end+1) = Vols.perone;
        Name{end+1} = DIM(k).name;
        Status(end+1,1:3) = Check;
        Ax_Y(end+1,:) = Ay;
        Ax_Z(end+1) = Angulo_Z(V_out);
        fprintf('Saved..... %s \n', DIM(k).name);
        
    end
    
end

Var_names = {'Nombre','Vol_femur','Vol_tibia','Vol_perone','Rut','Edad','Sexo','F_femur','F_tibia','F_perone','Ax_Y','Ax_Z'};

t = table(Name',Vol_femur',Vol_tibia',Vol_perone',Info(:,3), Info(:,5) , Info(:,6),Status(:,1),...
    Status(:,2),Status(:,3),Ax_Y,Ax_Z');

t.Properties.VariableNames= Var_names;        

%% Crear la Base de Datos que se utilizará para la Optimización 
% - Se rotará Solo en Z, para poder obtener los puntos de stephen
%   automáticamente. 
% - Se excluyeran algunas variables, de tal modo que la base de datos no
%   sea tan pesada.
% - Solo se incluirán aquellos con VolF_femur > 0 (no tiene sentido los
%   otros)

folder = uigetdir();
DIM = dir(folder);
%Dir_out = '/Users/franciscofernandezschlein/Google Drive/Uc/LPFM/Terminadas_finales/';
fields_out = {'femur','perone','tibia','rotula','vol'};
contador = 0;
Base_datos = struct('Rodilla',[]);

for k=1:numel(DIM)

    if not(DIM(k).isdir) && length(DIM(k).name) > 12
        
        fprintf('Processing..... %s \n', DIM(k).name);
        V_load = load([DIM(k).folder '/' DIM(k).name],'V_seg');
        V_out = V_load.V_seg;
        [Volumenes,Check] = Volumenes_fisis(V_out);
        
        if Volumenes.femur > 0
            V_out = Stephen_auto(V_out);
            V_out = rmfield(V_out,fields_out);
            %save([Dir_out DIM(k).name],'V_out')
            %fprintf('Saved..... %s \n', DIM(k).name);
            contador = contador + 1;
            Base_datos(contador).Rodilla = V_out;
            
        else
            fprintf('No tenía Fisis..... %s \n', DIM(k).name);
        end
        
%         if  contador == 5
%             break
%         end

    end
    
end


        