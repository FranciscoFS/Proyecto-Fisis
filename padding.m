function Out = padding(X,Largo)

    if Largo == size(X,2)

        Out = X;
        
    else 
        
        Mid = Largo/2;
        Out = NaN(1,Largo);
        pos = find(X == 0);
        
        if mod(length(X),2)
            Out((Mid +1 - (length(X)/2) -0.5):Mid + (length(X)/2 - 0.5)) = X';
        else
            Out((Mid +1 - length(X)/2):Mid + length(X)/2) = X';
        end
    end

end