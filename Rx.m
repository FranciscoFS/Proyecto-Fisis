function X = Rx(Vol)

    X = zeros(size(Vol(:,:,3)));

    for k = 1:size(Vol,3)
        
        Slide = im2double(Vol(:,:,k));
        X = X + Slide;
        
    end


end