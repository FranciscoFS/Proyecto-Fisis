%% Correlacion Interobservador

DIM = dir('C:\Users\Francisco Fernandez\Desktop\Interobs');
Mascaras = struct();
Contador = 1;
for k=1:numel(DIM)
    
    if not(DIM(k).isdir)
        V_load = load([DIM(k).folder '/' DIM(k).name],'V_seg');
        Mascaras(Contador).mask = V_load.V_seg.mascara(:);
        Mascaras(Contador).name = DIM(k).name;
        Contador = Contador + 1;
    end
end
        
%%
Pares = [1 8; 2 5; 3 6; 4 7];

for k = 1:4
    Correlaciones(k) = corr(Mascaras(Pares(k,1)).mask,Mascaras(Pares(k,2)).mask);
end
[h,p,ci,stats] = ttest(Correlaciones);
