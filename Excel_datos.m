%% Script para correr sobre toda las rodillas terminadas y obtener el excel
% con info relevante


%DIM = dir('/Users/franciscofernandezschlein/Google Drive/Uc/LPFM/Base_datos_procesada/');
%DIM = dir('G:\GoogleDrive\Uc\LPFM\Base_datos_procesada\');
DIM = dir('D:\Drive\Uc\LPFM\Base_Datos_Procesada_(Completa)');

Vol_femur = [];
Vol_tibia = [];
Vol_perone = [];
Info = {};
Name = {};
Status = [];
Ax_Y = [];
Ax_X = [];
Ax_Z = [];
Vol_epifisiario_F = [];
Dist_FF = [];
D_Femur = [];
D_Tibia = [];
VBF_Total = [];
D_Fisis_Stephen_proximal = [];
D_Fisis_Stephen_distal = [];
Dist_FF_Proy_S = [];
Dist_FisisT = [];
Dist_FisisT_Proy_S = [];
Vol_epifisiario_T = [];
Rodilla = {};

for k=1:numel(DIM)

    if not(DIM(k).isdir) && length(DIM(k).name) > 12
        
        fprintf('Cargando y Calculando..... %s \n', DIM(k).name);
        V_load = load([DIM(k).folder '/' DIM(k).name],'V_out');
        V_out = V_load.V_out;
        Ay = Angulos_Y(V_out);
        Ax = Angulo_X(V_out);
        [Vols,Check] = Volumenes_fisis(V_out);
        Volumenes_bajo_fisis = V_epifisis_femur(V_out);
        Dist_Fisis_Femur = Dist_fisis_femur(V_out);
        Dist_Fisis_Tibia = Dist_fisis_tibia(V_out);
        Dist_Fisis_stephen = Dist_Fisis_Stephen(V_out,5);
        Info(end+1,1:6) = V_out.info(1:6);
        Vol_femur(end+1) = Vols.femur;
        Vol_tibia(end+1) = Vols.tibia;
        Vol_perone(end+1) = Vols.perone;
        Name{end+1} = DIM(k).name;
        Status(end+1,1:3) = Check;
        Ax_Y(end+1,:) = Ay;
        Ax_X(end+1,:) = Ax;
        Ax_Z(end+1) = V_out.info{7};
        Vol_epifisiario_F(end+1) = Volumenes_bajo_fisis{1};
        VBF_Total(end+1) = Volumenes_bajo_fisis{2};
        Dist_FF(end+1) = Dist_Fisis_Femur{1};
        Dist_FF_Proy_S(end+1) = Dist_Fisis_Femur{2};
        D_Femur(end+1) = Diametro_femur(V_out);
        D_Tibia(end+1) = Diametro_tibia(V_out);
        D_Fisis_Stephen_proximal(end+1) = Dist_Fisis_stephen{2};
        D_Fisis_Stephen_distal(end+1) = Dist_Fisis_stephen{1};
        Dist_FisisT(end+1) = Dist_Fisis_Tibia{1};
        Dist_FisisT_Proy_S(end+1) = Dist_Fisis_Tibia{2};
        Vol_epifisiario_T(end+1) = V_epifisis_tibia(V_out);
        Rodilla{end+1} = V_out;
        
        fprintf('Procesado..... %s \n', DIM(k).name);
        
    end
    
end

Var_names = {'Nombre','Vol_Ffemur','Vol_Ftibia','Vol_Fperone','Rut','Edad','Peso','Sexo','F_femur','F_tibia','F_perone','Ax_Y','Ax_X','Ax_Z',...
    'Dist_FF','Dist_FF_Proy_S','Vol_bajo_fisis','VBF_Total','D_Femur','D_Tibia','Dist_Fisis_Stephen_proximal','Dist_Fisis_Stephen_distal'...
   ,'Dist_Fisis_tibia', 'Dist_Fisis_tibia_Proy_S','Vol_epifisiario_Tibia','Datos'};

%Var_names2 = {'Nombre','Vol_Ffemur','Vol_Ftibia','Vol_Fperone','Rut','Edad','Peso','Sexo','F_femur','F_tibia','F_perone','Ax_Y','Ax_X','Ax_Z',...
%    'Dist_FF','Dist_FF_Proy_S','Vol_bajo_fisis','VBF_Total','D_Femur','D_Tibia','Dist_Fisis_Stephen_proximal','Dist_Fisis_Stephen_distal'...
%   ,'Dist_Fisis_tibia', 'Dist_Fisis_tibia_Proy_S','Vol_epifisiario_Tibia','Datos'};

t = table(Name',Vol_femur',Vol_tibia',Vol_perone',Info(:,3), Info(:,5) ,Info(:,4), Info(:,6),Status(:,1),...
    Status(:,2),Status(:,3),Ax_Y,Ax_X,Ax_Z',Dist_FF',Dist_FF_Proy_S',Vol_epifisiario_F',VBF_Total',D_Femur',D_Tibia',D_Fisis_Stephen_proximal'...
    ,D_Fisis_Stephen_distal',Dist_FisisT',Dist_FisisT_Proy_S',Vol_epifisiario_T',Rodilla');

%t2 = table(Name',Vol_femur',Vol_tibia',Vol_perone',Info(:,3), Info(:,5) ,Info(:,4), Info(:,6),Status(:,1),...
%     Status(:,2),Status(:,3),Ax_Y,Ax_X,Ax_Z',Dist_FF',Dist_FF_Proy_S',Vol_epifisiario_F',VBF_Total',D_Femur',D_Tibia',D_Fisis_Stephen'...
%     ,Dist_FisisT',Dist_FisisT_Proy_S',Vol_epifisiario_T',Rodilla');


t.Properties.VariableNames= Var_names;
%t2.Properties.VariableNames = Var_names2;

for k=1:size(t,1)
    t.Edad{k} = str2double(t.Edad{k}(2:3));
    %t2.Edad{k} = str2double(t2.Edad{k}(2:3));
end
%% Crear la Base de Datos que se utilizará para la Optimización y para el excel tambi�en

% - Se rotará Solo en Z, para poder obtener los puntos de stephen
%   automáticamente. 
% - Se excluyeran algunas variables, de tal modo que la base de datos no
%   sea tan pesada.
% - Solo se incluirán aquellos con VolF_femur > 0 (no tiene sentido los
%   otros)
% - En la estructura solo los que tienen FISIS, pero en la carpeta se
% guardaran todas las Rodillas alivianadas con info relevante.

folder = uigetdir();
DIM = dir(folder);
%Dir_out = '/Users/franciscofernandezschlein/Google Drive/Uc/LPFM/Base_datos_procesada/';
%Dir_out = '/Users/franciscofernandezschlein/Google Drive/Uc/LPFM/Base_datos_procesada2/';
%Dir_out = 'D:\Drive\Uc\LPFM\Base_Datos_Procesada_(Completa)_2\';
%fields_out = {'femur','perone','tibia','rotula','vol'};
fields_out = {'femur','perone','tibia','rotula','vol'};
contador = 0;
Base_datos = struct('Rodilla',[]);

for k=1:numel(DIM)

    if not(DIM(k).isdir) && length(DIM(k).name) > 12
        
        fprintf('Processing..... %s \n', DIM(k).name);
        V_load = load([DIM(k).folder '/' DIM(k).name],'V_seg');
        V_out = V_load.V_seg;
        [Volumenes,Check] = Volumenes_fisis(V_out);
        
       % if Volumenes.femur > 0
            
            V_out = Stephen_auto(V_out);
            V_out = rmfield(V_out,fields_out);
            %V_out.vol = rmfield(V_out.vol,'filt');
            %save([Dir_out DIM(k).name],'V_out')
            fprintf('Saved..... %s \n', DIM(k).name);
            contador = contador + 1;
            Base_datos(contador).Rodilla = V_out;
            
      %  else
            
%             V_out.mascara = (V_out.mascara < 8).*(V_out.mascara);
%             Az = Angulo_Z(V_out);
%             Eje = 'Z';
%             V_out = Rotar(V_out,Az,Eje);
%             V_out.info{7} = Az;
%             V_out = rmfield(V_out,fields_out);
%             save([Dir_out DIM(k).name],'V_out')
%             fprintf('No tenia Fisis, pero....Saved..... %s \n', DIM(k).name);
            
      %  end
        
    end
    
end


        