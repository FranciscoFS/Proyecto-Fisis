function [I_out] = filtro_gabriel(I,R,alpha,beta)

    %Inputs
    % I, es la imagen, es 2D
    % R, es la Máscara
    % alpha y Beta, son parámetros que regulan el filtro

    slice = R;
    im = I;
    I_out = zeros(size(I));
  
    for ii = 1:size(im,1)

        for jj = 1:size(im,2)

            if slice(ii,jj) == 1

                I_out(ii,jj) = im(ii,jj) + im(ii,jj)^alpha;

                if im(ii,jj) > 1

                   I_out(ii,jj) = 1;
                end

            else

                I_out(ii,jj) = im(ii,jj)/beta;

            end
        end 
    end
    
end