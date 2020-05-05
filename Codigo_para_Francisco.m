Codigo_distancia

[x,y] = getpts();

%Linea basal
syms p q
if x(2) == x(1)
    x(2) = x(2) +1;
end
if y(2) == y(1)
    y(2) = y(2) +1;
end
m1 = (y(2)-y(1))/(x(2)-x(1));
q = symfun(m1*(p-x(1))+y(1),[p]);


%Linea Perpendicular
m_perp = -1/m1;
syms q2
q2 = symfun(m_perp*(p-x(3))+y(3),[p]);
x2=solve(q==q2);
y2=q2(x2);
%Puntos de la linea 1
P3 = [x(3),y(3)];
P4 = [eval(x2),eval(y2)]; %Interseccion en la linea

distancia = pdist([P3;P4],'euclidean')*V_seg.info{1,1}; %Aqui multiplicar por el dx promedio por ejemplo

