function Out = Cilindro_Fisis(alpha,beta,d,p,Rodilla)

    Hueso = Rodilla.mascara ==1;
    Cilindro = Crear_solo_cilindro2(Rodilla, alpha, beta,p,d);
    Union = ((Cilindro >0)  + (Hueso >0)) == 2;
    isosurface(Union)
    Union = sum(Union(:));
    Out = (Union/sum(Cilindro(:) ==1));
    
end



    