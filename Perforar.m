function [distancias_a_fisis] = Perforar(a1,a2,mm,h,f,V_seg,coordenada)
%No se si hay que volver a crearlas?!...

info = V_seg.info;
%Primera version: solo 90 grados como a1 y a2

distancias_a_fisis = [];
pixel = info{1,1};

	%1 distancias_a_fisis(i).arriba =	Distancia a primer punto de fisis arriba
    for a= coordenada(3):(coordenada(3)+ mm)
        fila_baja = 0;
        encontrado = 0;
        im = f(:,:,a)
        c = coordenada(2);
        
        while (encontrado == 0 && c > 0)
            if im(coordenada(1),c) == 1
                fila_baja = c;
                encontrado = 1;
            end
            c = c-1
        end        
        if encontrado == 1
            distancias_a_fisis.arriba(a-coordenada(3)+1) = abs(coordenada(2)-fila_baja)*pixel;
        else
         distancias_a_fisis.arriba(a-coordenada(3)+1) = 0;
        end
            
        
    end


	%2 distancias_a_fisis(i).abajo = 	Distancia a primer punto de fisis abajo
    
    for a= coordenada(3):(coordenada(3)+ mm)
        fila_alta = coordenada(2);
        encontrado = 0;
        im = f(:,:,a);
        c = coordenada(2);
        
        while (encontrado == 0 && c < size(im,2))
            if im(coordenada(1),c) == 1
                fila_alta = c;
                encontrado = 1;
            end
            c=c+1;
        end
        if encontrado == 1
            distancias_a_fisis.abajo(a-coordenada(3)+1) = abs(coordenada(2)-fila_alta)*pixel;
        else
            distancias_a_fisis.abajo(a-coordenada(3)+1) = 0;
        end
    end
       
	%3 distancias_a_fisis(i).izquierda=	Distancia a primer punto de fisis izquierda
    
    for a= coordenada(3):(coordenada(3)+ mm)
        col_izq = coordenada(1);
        encontrado = 0;
        im = f(:,:,a);
        c = coordenada(1);
        while (encontrado == 0 && c > 0)
            if im(c,coordenada(2)) == 1
                col_izq = c;
                encontrado = 1;
            end
            c = c-1;
        end
        if encontrado == 1
            distancias_a_fisis.izq(a-coordenada(3)+1) = abs(coordenada(1)-col_izq)*pixel;
        else
            distancias_a_fisis.izq(a-coordenada(3)+1) = 0;
        end
    end
    
	%4 distancias_a_fisis(i).derecha =	Distancia a primer punto de fisis derecha

    for a= coordenada(3):(coordenada(3)+ mm)
        col_der = coordenada(1);
        encontrado = 0;
        im = f(:,:,a);
        c = coordenada(1);
        while (encontrado == 0 && c < size(im,1))
            if im(c,coordenada(2)) == 1
                col_der = c;
                encontrado = 1;
            end
            c = c+1;
        end
        if encontrado == 1
            distancias_a_fisis.der(a-coordenada(3)+1) = abs(coordenada(1)-col_der)*pixel;
        else
            distancias_a_fisis.der(a-coordenada(3)+1) = 0;
        end

    end
end
