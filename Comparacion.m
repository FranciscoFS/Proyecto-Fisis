% Scrip para realizar comparaci�n entre ayudantes para una Rodilla X

N = 1; %Numero de Participantes
Pacientes = struct();
Datos = [];

for k = 1:N
    
    [FileName,PathName,FilterIndex] = uigetfile('MultiSelect','on');
    
    for i = 1:length(FileName)
        
        Pacientes(k).Rodilla(i) = load([PathName FileName{i}]);
        
    end
    
    Datos(:,k) = Med(Pacientes(k).Rodilla)';
    
end

Tabla = array2table(Datos);
Tabla.Properties.VariableNames = {'Observador1','Observador2','Observador3','Observador4','Observador5'};


%%

Matriz_comparacion = [];

for kk=1:numel(Pacientes)
    
    for ii = 1:numel(Pacientes)
        
        Matriz(kk,ii) = comparar(Pacientes(kk).Rodillas.V_seg,Pacientes(ii).Rodillas.V_seg)*100;
        
    end
    
end

    