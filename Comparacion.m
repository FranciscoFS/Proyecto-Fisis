% Scrip para realizar comparación entre ayudantes para una Rodilla X

N = 2; %Numero de Participantes
Pacientes = struct();

for k = 1:N
    
    [FileName,PathName,~] = uigetfile();
    Pacientes(k).Rodillas = load([PathName FileName]);
    
end

Matriz_comparacion = [];

for kk=1:numel(Pacientes)
    
    for ii = 1:numel(Pacientes)
        
        Matriz(kk,ii) = comparar(Pacientes(kk).Rodillas.V_seg,Pacientes(ii).Rodillas.V_seg);
        
    end
    
end

    