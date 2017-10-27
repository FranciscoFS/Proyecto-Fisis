function [distancias_a_fisis] = Perforar(input)
%No se si hay que volver a crearlas?!...

a1 = input(1);
a2 = input(2);
mm = input(3);
h = input(4);
f = input(5);
info = input(6).info;
coordenada = input(7);

%Primera version: solo 90 grados como a1 y a2

distancias_a_fisis = [];
pixel = info{1,1};

	%1 distancias_a_fisis(i).arriba =	Distancia a primer punto de fisis arriba
    fila_baja = 0;
    encontrado = 0;
    for a= coordenada(3):(coordenada(3)+ mm)
        im = f(:,:,a);
        for c = coordenada(2):-1:1
            if im(coordenada(1),c) == 1
                fila_baja = c;
                encontrado = 1;
            end
        end
        if encontrado == 1
            distancias_a_fisis.arriba(a-coordenada(3)) = abs(coordenada(2)-fila_baja)*pixel;
            encontrado = 0;
        else %si no hay fisi ahi
            distancias_a_fisis.arriba(a-coordenada(3)) = -1;
        end
    end


	%2 distancias_a_fisis(i).abajo = 	Distancia a primer punto de fisis abajo
    
    fila_alta = coordenada(2);
    encontrado = 0;
    for a= coordenada(3):(coordenada(3)+ mm)
        im = f(:,:,a);
        for c = coordenada(2):size(im,2)
            if im(coordenada(1),c) == 1
                fila_alta = c;
                encontrado = 1;
            end
        end
        if encontrado == 1
            distancias_a_fisis.abajo(a-coordenada(3)) = abs(coordenada(2)-fila_alta)*pixel;
            encontrado = 0;
        else %si no hay fisis ahi
            distancias_a_fisis.abajo(a-coordenada(3)) = -1;
        end
       
	%3 distancias_a_fisis(i).izquierda=	Distancia a primer punto de fisis izquierda
    
    col_izq = coordenada(1);
    encontrado = 0;
    for a= coordenada(3):(coordenada(3)+ mm)
        im = f(:,:,a);
        for c = coordenada(1):-1:1
            if im(c,coordenada(2)) == 1
                col_izq = c;
                encontrado = 1;
            end
        end
        if encontrado == 1
            distancias_a_fisis.izq(a-coordenada(3)) = abs(coordenada(1)-col_izq)*pixel;
            encontrado = 0;
        else %si no hay fisis ahi
            distancias_a_fisis.izq(a-coordenada(3)) = -1;
        end
    
   	
	%4 distancias_a_fisis(i).derecha =	Distancia a primer punto de fisis derecha
    col_der = coordenada(1);
    encontrado = 0;
    for a= coordenada(3):(coordenada(3)+ mm)
        im = f(:,:,a);
        for c = coordenada(1):size(im,1)
            if im(c,coordenada(2)) == 1
                col_der = c;
                encontrado = 1;
            end
        end
        if encontrado == 1
            distancias_a_fisis.der(a-coordenada(3)) = abs(coordenada(1)-col_der)*pixel;
            encontrado = 0;
        else %si no hay fisis ahi
            distancias_a_fisis.der(a-coordenada(3)) = -1;
        end

end
