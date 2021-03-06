%% Fotos

clear all

folder = uigetdir();
DIM = dir(folder);
p = genpath(folder);
addpath(p);
warning('off','all')


for k=1:numel(DIM)
    
    if DIM(k).isdir && length(DIM(k).name) > 5
        
        MRIS = dir([DIM(k).folder '/' DIM(k).name '/*.dcm']);
        fprintf('Saving..... %s \n', DIM(k).name);
        MRI = save_MRI(MRIS);
        Name_data = DIM(k).name; 
        save(Name_data,'MRI') ;
        fprintf('%s ..... Saved \n', DIM(k).name);
        
    else
        continue
    end
    
    disp(['END' ' ' num2str(k) '/' num2str(numel(DIM))])
end





