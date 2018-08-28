function V_seg = Punto_LCA_femur_manual(V_seg)

    V_seg.mascara = (V_seg.mascara < 8).*(V_seg.mascara);
    a = V_seg.mascara ==1; %hueso
    b = V_seg.mascara ==2; %fisis
    vol = a+b;
   
    %Cortar por la mitad el femur (solo 1/2 lateral)
    vol2 = vol(1:size(vol,1),1:size(vol,1),(size(vol,3)/2): size(vol,3));
    
    %LM: lateral medial
    aplastado_LM = squeeze(sum(vol2,3));
       
    %Crear linea de Blumensaat
        imshow(aplastado_LM,[])
        hold on
        uiwait(msgbox('Poner dos puntos a lo largo de la linea de Blumensaat'));
        [y,x] = getpts();
        syms p
        m1 = (y(2)-y(1))/(x(2)-x(1));
        q = symfun(m1*(p-x(1))+y(1),[p]);
        plot([y(1),y(2)],[x(1),x(2)],'LineWidth',3)
        %poner punto más adelante de la linea
        uiwait(msgbox('Poner punto mas anterior/colineal'));
        [y,x_ant] = getpts();
        y_ant = q(x_ant);
    %Crear linea paralela 
        uiwait(msgbox('Poner punto mas distal/paralelo'));
        [y,x] = getpts();
        q2 = symfun(m1*(p-x(1))+y(1),[p]);
        x(2) = x(1) + 50;
        x(1) = x(1) - 50;
        y(1) = q2(x(1));
        y(2) = q2(x(2));
        plot([y(1),y(2)],[x(1),x(2)],'LineWidth',3)
    %Crear linea perpendicular
        uiwait(msgbox('Poner punto mas posterior/perpendicular'));
        [y,x] = getpts();
        m_perp = -1/m1;
        q3 = symfun(m_perp*(p-x(1))+y(1),[p]);
        x(2) = x(1) + 50;
        x(1) = x(1) - 50;
        y(1) = q3(x(1));
        y(2) = q3(x(2));
        plot([y(1),y(2)],[x(1),x(2)],'LineWidth',3)
        
        %Interseccion
        x2=solve(q==q3);
        y2=q(x2);
       
        x3=solve(q2==q3);
        y3=q2(x3);

%         scatter(y2,x2,100,'d','filled')
%         scatter(y3,x3,100,'s','filled')

%t=21.7%±2.5% h=33.2%±5.6% t=35.1%±3.5% h=55.3%±5.3%
t =(0.217+0.351)/2; 
h = (0.332+0.553)/2;
 
        xy = [x2,y2;x3,y3];
        d_ant = pdist(xy,'euclidean')*h;
        
        xy2 = [x2,y2;x_ant,y_ant];
        d_distal= pdist(xy2,'euclidean')*t;
        
        syms xx yy
        eqn1 = (xx-x2)^2 + (yy-y2)^2 == d_ant^2;
        eqn2 = m_perp*(xx-x2)== yy-y2;
        sol = solve([eqn1, eqn2], [xx, yy]);
        
        xSol = sol.xx;
        ySol = sol.yy;
        
%         scatter(ySol(1),xSol(1),100,'d','filled')
%         scatter(ySol(2),xSol(2),100,'s','filled')
        
        %Que la solucion sea la de al medio
        for i = 1:2
        if ySol(i)>y2 && ySol(i)<y3
            if xSol(i)>x2 && xSol(i)<x3
            resp = i;
            elseif xSol(i)<x2 && xSol(i)>x3
            resp = i;
            end
        elseif ySol(i)<y2 && ySol(i)>y3
            if xSol(i)>x2 && xSol(i)<x3
            resp = i;
            elseif xSol(i)<x2 && xSol(i)>x3
            resp = i;
            end
        end
        end
        scatter(ySol(resp),xSol(resp),100,'s','filled')
%         message = sprintf('Cual de las dos soluciones es la correcta?');
%         reply = questdlg(message,...
%             'Forma',...
%             'Diamante', 'Cuadrado', 'No','No');
% 
%         if strcmpi(reply,'Diamante')
%             resp = 1;
%         else
%             resp = 2;
%         end

        
        xSol = sol.xx(resp);
        ySol = sol.yy(resp);
       
        q5 = symfun(m1*(p-xSol)+ySol,[p]);
       
        x(2) = xSol + 50;
        x(1) = xSol - 50;
        y(1) = q5(x(1));
        y(2) = q5(x(2));
        plot([y(1),y(2)],[x(1),x(2)],'LineWidth',3)

        %Linea 6 e interseccion
        syms xx2 yy2
        eqn3 = (xx2-xSol)^2 + (yy2-ySol)^2 == d_distal^2;
        eqn4 = m1*(xx2-xSol)== yy2-ySol;
        sol = solve([eqn3, eqn4], [xx2, yy2]);
        xSol2 = sol.xx2;
        ySol2 = sol.yy2;
        
%         scatter(ySol2(1),xSol2(1),100,'d','filled')
%         scatter(ySol2(2),xSol2(2),100,'s','filled')
%         message = sprintf('Cual de las dos soluciones es la correcta?');
%         reply = questdlg(message,...
%             'Forma',...
%             'Diamante', 'Cuadrado', 'No','No');
%         
%         if strcmpi(reply, 'Diamante')
%             resp = 1;
%         else
%             resp = 2;
%         end
        %Que la solucion sea la de al medio
        
        for i = 1:2
        if ySol2(i)>y2 && ySol2(i)<y_ant
            if xSol2(i)>x2 && xSol2(i)<x_ant
            resp = i;
            elseif xSol2(i)<x2 && xSol2(i)>x_ant
            resp = i;
            end
        elseif ySol2(i)<y2 && ySol2(i)>y_ant
            if xSol2(i)>x2 && xSol2(i)<x_ant
            resp = i;
            elseif xSol2(i)<x2 && xSol2(i)>x_ant
            resp = i;
            end
        end
        end
        scatter(ySol2(resp),xSol2(resp),100,'d','filled')
        
        coordenada = [xSol2(resp),ySol2(resp)];
        uiwait(msgbox('Punto encontrado!'));
        
        

 
end