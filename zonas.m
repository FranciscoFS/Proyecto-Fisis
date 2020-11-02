function Fisis_4 = zonas(Fisisin,Puntos,pocentaje)

    pos_s = [];
    
    Fisis1 = Fisisin(:,:,1:Puntos(2));
    [dumm,c,dumm] = ind2sub(size(Fisis1),find(Fisis1 == 1));
    Salto = (max(c) - min(c))*pocentaje;
    pos = min(c) + Salto;
    pos_s(1) = pos;
    Fisis1 = Fisis1(:,1:pos,:);
    

    Fisis2 = Fisisin(:,:,(Puntos(2)+1):Puntos(3));
    [dumm,c,dumm] = ind2sub(size(Fisis2),find(Fisis2 == 1));
    Salto = (max(c) - min(c))*pocentaje;
    pos = min(c) + Salto;  
    pos_s(2) = pos;
    Fisis2 = Fisis2(:,1:pos,:);
    
    Fisis3 = Fisisin(:,:,(Puntos(3)+1):Puntos(1));
    [dumm,c,dumm] = ind2sub(size(Fisis3),find(Fisis3 == 1));
    Salto = (max(c) - min(c))*pocentaje;
    pos = min(c) + Salto;  
    pos_s(3) = pos;
    Fisis3 = Fisis3(:,1:pos,:);
    
    try
        Fisis4 = Fisisin(:,:,(Puntos(1)+1):end);
        [dumm,c,dumm] = ind2sub(size(Fisis4),find(Fisis4 == 1));
        Salto = (max(c) - min(c))*pocentaje;
        pos = min(c) + Salto;
        pos_s(4) = pos;
        Fisis4 = Fisis4(:,1:pos,:);
        
    catch
        Fisis4 = Fisis4(:,1:pos_s(3),:);
    end

    Fisis_4{1} = Fisis1;
    Fisis_4{2} = Fisis2;
    Fisis_4{3} = Fisis3;
    Fisis_4{4} = Fisis4;
    
%     figure; 
%     pos_s
%     imshow(squeeze(sum(Fisisin,1)),[])
%     hold on;
%     p1 = repmat(pos_s(1),[1,Puntos(2)]);
%     p2 = repmat(pos_s(2),[1,(Puntos(3) - Puntos(2))]);
%     p3 = repmat(pos_s(3),[1,(Puntos(1) - Puntos(3))]);
%     p4 = repmat(pos_s(4),[1,(size(squeeze(sum(Fisisin,1)),2) - Puntos(1))]);
%     plot(1:size(squeeze(sum(Fisisin,1)),2),[p1 p2 p3 p4])
    
    
end
    

    