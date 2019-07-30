%% Revisar bien el lado de la rodilla

folder = uigetdir();
DIM = dir(folder);
Datos = cell(numel(Base_datos),3);

for k = 1:numel(Base_datos)
    
    Nombre = Base_datos(k).RM.info{6,1};
    Pos = find(strcmpi(regexprep(Nombre,' ','_'),{DIM.name}) == 1);
    p = strsplit(genpath([DIM(Pos).folder '/' DIM(Pos).name]),';');
    
    DICOMS = dir([p{3} '/*.dcm']);
    info = dicominfo([DICOMS(1).folder '\' DICOMS(1).name]);
    Datos{k,1} = regexprep(Nombre,' ','_');
    Datos{k,2} = info.StudyComments;
    Datos{k,3} = info.StudyDescription;
    Datos{k,4} = info.RequestedProcedureDescription;
    
end