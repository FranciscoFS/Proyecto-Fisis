clear all

folder = uigetdir();
DIM = dir(folder);

Nombre_carpeta = {};
PatientID = {};
Numero = [];
PixelSpacing = {};
SliceThickness = [];
PatientBirthDate = {};
PatientWeight = [];
PatientAge = {};
PatientSex = {};
InstanceCreationDate = {};
FamilyName = {};
GivenName = {};
InstitutionName = {};
StudyDescription = {};

for k=1:numel(DIM)
    
    if DIM(k).isdir && not(isempty(str2num(DIM(k).name)))
        
        MRIS = dir([DIM(k).folder '/' DIM(k).name '/*.dcm']);
        fprintf('Saving..... %s \n', DIM(k).name);
        
        info=dicominfo([MRIS(1).folder '\' MRIS(1).name]);
        
        Nombre_carpeta{k-2} = DIM(k).name;
        FamilyName{k-2} = info.PatientName.FamilyName;
        GivenName{k-2} = info.PatientName.GivenName;
        PatientID{k-2} = info.PatientID;
        Numero(k-2) = k-2;
        PixelSpacing{k-2} = info.PixelSpacing;
        SliceThickness(k-2) = info.SliceThickness;
        PatientBirthDate{k-2} = info.PatientBirthDate;
        PatientWeight(k-2) = info.PatientWeight;
        PatientAge{k-2} = info.PatientAge;
        PatientSex{k-2} = info.PatientSex;
        InstanceCreationDate{k-2} = info.InstanceCreationDate;
        InstitutionName{k-2} = info.InstitutionName;
        StudyDescription{k-2} = info.StudyDescription;
        fprintf('%s ..... Saved \n', DIM(k).name);
        info = 0;
        
        oldname = fullfile(MRIS(1).folder);
        newname = [fullfile(folder) '\' num2str(k-2) ' x'];
        movefile(oldname,newname);
        
        
    else
        continue
    end
    
    disp(['END' ' ' num2str(k) '/' num2str(numel(DIM))])
end
%%
Nombre_carpeta = Nombre_carpeta';
FamilyName = FamilyName';
GivenName = GivenName';
PatientID = PatientID';
Numero = Numero';
PixelSpacing = PixelSpacing';
SliceThickness = SliceThickness';
PatientBirthDate = PatientBirthDate';
PatientWeight = PatientWeight';
PatientAge = PatientAge';
PatientSex = PatientSex';
InstanceCreationDate = InstanceCreationDate';
InstitutionName = InstitutionName';
StudyDescription = StudyDescription';

%%
T = table(Numero,Nombre_carpeta,GivenName,FamilyName,PatientID,PixelSpacing,SliceThickness,PatientBirthDate,PatientWeight,PatientAge,PatientSex,InstanceCreationDate, InstitutionName, StudyDescription);

%%
writetable(T,'Rodillas.xls')