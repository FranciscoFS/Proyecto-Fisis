clear all
A = 20;
N_disks = 1000;
Disk = cell(1,N_disks);
Disk_T = zeros(200,200,A);

disp('Creando Discos......')

for ii=1:N_disks
   
    Mascara = zeros(200,200,A);
    
    c = randi([5 10],1);

    [X,Y,~] = meshgrid(1:200,1:200,1:c);

    a = randi([26 40],1);
    b = randi([20 23],1);
    
    alpha = randi([-20 20],1);
    beta = randi([-20 20],1);

    d = (((X-(100+alpha))/a).^2 + ((Y-(100+beta))/b).^2  <= 1);
    
    Mascara(:,:,(A/2-round(c/2))+1:(A/2+floor(c/2))) = d;
    
    Disk_T = Disk_T + Mascara;
    
end

   

%% Plot

disp('PLoting...')

Disk_T = Disk_T./max(Disk_T(:));
Indice = (Disk_T(:) > 0);
[X,Y,Z] = meshgrid(1:200,1:200,1:A);
scatter3(X(Indice),Y(Indice),Z(Indice),5,Disk_T(Indice));
daspect([1 1 1]); zlim([0 30]);
