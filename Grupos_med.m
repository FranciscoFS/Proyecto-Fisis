clear all
total_alumnos = 12;
n_grupos = total_alumnos/3;
comb = nchoosek(1:total_alumnos,2);%combinaciones

%Matriz de puntajes
%M = zeros(total_alumnos,total_alumnos);
M = randi([0 1], total_alumnos,total_alumnos);

% for i = 1:size(comb,1)
%     comb(i,3) = M(comb(i,1),comb(i,2))+M(comb(i,2),comb(i,1));%puntajes
% end

%combinaciones
comb_grupos = nchoosek(1:total_alumnos, n_grupos);

%% 
for i = 1:size(comb_grupos,1)
    parejas_grupo = nchoosek([comb_grupos(i,:)],2);
    for p = 1:size(parejas_grupo,1)
        parejas_grupo(p,3) = M(parejas_grupo(p,1),parejas_grupo(p,2))+M(parejas_grupo(p,2),parejas_grupo(p,1));%puntajes
    end
    suma(i,1) = sum(parejas_grupo(:,3));
end
comb_grupos(:,end+1) =suma;%felicidad por grupo en la ultima columna

%%
grupos_3 = nchoosek([comb_grupos(:,end)],3);

for i = 1:size(grupos_3,1)
     varianza(i,1) = var(grupos_3(i,:));
end
grupos_3(:,end+1) =varianza;

%%
x = 1:size(grupos_3,1);
plot(x,grupos_3(:,end))
minimo=min(grupos_3(:,end));
[row,col] = find(grupos_3(:,end)==minimo);
[row,col] = find(comb_grupos(:,end)==grupos_3(row(1,1),1));
size(row,1)
grupos_finales = comb_grupos(row,:);

