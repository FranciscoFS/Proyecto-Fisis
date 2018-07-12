function d = Diametro_femur(V_seg)
ant=0;
post=0;
V_seg.mascara = V_seg.mascara == 1;
for i = 1: size(V_seg.mascara,3)
    if find(V_seg.mascara(:,:,i),1)>0
        ant = i;
        for n = 1:size(V_seg.mascara,3)
            if find(V_seg.mascara(:,:,size(V_seg.mascara,3)-n),1)>0
                post = size(V_seg.mascara,3)-n;
              break  
            end
        
        end
        break
    end
end
 d = (post-ant)*V_seg.info{2,1};
end