    function [x] = Aproximar(x)
    
    if (x - fix(x)) >= 0.5
        x = ceil(x);
    else
        x = floor(x);
    end
    
    end