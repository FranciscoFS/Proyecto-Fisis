function [MRI] = save_MRI(DIM)
    class = 1;
    
 
    for k = 1:numel(DIM) 
        
        x = dicomread(DIM(k).name);
        inf = dicominfo(DIM(k).name);
        
        if k < numel(DIM)
            
            chars_k = strsplit(DIM(k).name, "-");
            chars_k1 = strsplit(DIM(k+1).name, "-");
            
            if str2double(chars_k{2}) ~= str2double(chars_k1{2})
                
                MRI(k).name = DIM(k).name;
                MRI(k).data = x;
                MRI(k).corte = inf.SeriesDescription;
                MRI(k).class = class;
                MRI(k).PixelSpacing = inf.PixelSpacing;
                MRI(k).SliceThickness = inf.SliceThickness;
                
                
                class = class + 1;
          
            else 
                
                MRI(k).name = DIM(k).name;
                MRI(k).data = x;
                MRI(k).corte = inf.SeriesDescription;
                MRI(k).class = class;
                
                
            end
            
        else

            MRI(k).name = DIM(k).name;
            MRI(k).data = x;
            MRI(k).corte = inf.SeriesDescription;
            MRI(k).class = class;
            
        end
           
    end
    

    
end