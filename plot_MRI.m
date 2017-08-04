function plot_MRI(V)
    % Esta wea plotea las cosas Volumétricas
    
    [M,N,Z] = size(V);
    montage(reshape(V,M,N,1,Z),'DisplayRange',[]);
    
end