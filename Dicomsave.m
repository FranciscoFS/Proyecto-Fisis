function V = Dicomsave(direccion)

    DICOMS = dir([direccion '/*.dcm']);
    Vol =[];
    contador = 0;
    
    for k=1:numel(DICOMS)
        
        if DICOMS(k).bytes > 0
            contador = contador +1;
            Vol(:,:,contador) = single(dicomread([DICOMS(k).folder '\' DICOMS(k).name]));
            
        else
            continue
        end
    end
    
    info = dicominfo([DICOMS(k).folder '\' DICOMS(k).name]);
    %info
    
    V.info{1,1} = info.PixelSpacing(1);
    V.info{2,1} = info.SliceThickness;
    V.info{3,1} = info.PatientBirthDate;
    %V.info{4,1} = info.PatientWeight;
    V.info{4,1} = info.PatientAge;
    V.info{5,1} = info.PatientSex;
    V.info{6,1} = [info.PatientName.FamilyName ' ' info.PatientName.GivenName] ;
    V.info{7,1} = info.PatientID;
    V.info{8,1} = info.StudyDescription;
    %V.info{9,1} = info.StudyComments;
    V.Vol = Vol;
end