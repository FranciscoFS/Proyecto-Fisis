function [Vol_New] = Vol_registration(MovVol, MovRef, FixVol, FixRef)

        %a = 1.250000e-02;
        [optimizer,metric] = imregconfig('monomodal');
        %optimizer.MaximumStepLength = a;
        
        Vol_New = imregister(MovVol, MovRef, FixVol, FixRef, 'affine', optimizer, metric);
        
        
        
end