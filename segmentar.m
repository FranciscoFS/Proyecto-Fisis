function [handles] = segmentar(handles,condicion)
    
    while condicion
    
    Indice = handles.Indice;
    Valor_cluster = find(Indice ==1);
    N  = sum(handles.Indice); % Numero de Clusters
    Words = ["Femur","Fisis Femur","Tibia","Fisis Tibia", "Perone","Fisis Perone","Rotula","Background"];
    Words= cellstr(Words(logical(handles.Indice)));
    colores = ["g.","r.", "b.", "y.","m.","c.","k.", "w."];
    colores = cellstr(colores(logical(handles.Indice)));
    k = handles.v;

        falto = 0;
        L_i = {};
        Vector_i = {};
        
        Im_seg = 1- handles.V_seg.vol.filt(:,:,k);
        Im =handles.V_seg.vol.filt(:,:,k);

        Change = 1;

        while Change

            %close(f1)
            f1 = figure('units', 'normalize', 'outerposition',[0.5 0 0.5 1]);
            imshow(handles.V_seg.vol.orig(:,:,k),'InitialMagnification','fit');title('Imagen de referencia');
            f2 = figure('units', 'normalize', 'outerposition',[0 0 0.5 1]);
            imshow(Im, [],'InitialMagnification','fit');title(['Imagen ' num2str(k)  ' de ' num2str(size(handles.V_seg.vol.filt,3))]);
            hold on

            for ii = 1:N
                
                
                    title(['Imagen ' num2str(k)  ' de ' num2str(size(handles.V_seg.vol.filt,3)) ': ' Words{ii}]);  
                    if falto == 1

                        for jj = 1:N
                          %  if m(jj)
                                plot(Puntos{jj,1}, Puntos{jj,2},colores{jj},'Markersize',12);
                            %end
                        end
                        message = sprintf(['Te faltaron puntos en '  Words{ii} '?']);
                        reply = questdlg(message, 'Fisis', 'Yes', 'No','No');

                        if strcmpi(reply, 'No')
                            continue;
                        elseif strcmpi(reply, 'Yes')
                            [Puntos_nuevos{ii,1}, Puntos_nuevos{ii,2}] = getpts();
                            Puntos{ii,1} = [Puntos{ii,1};Puntos_nuevos{ii,1}];
                            Puntos{ii,2} = [Puntos{ii,2};Puntos_nuevos{ii,2}];
                        end
                    else
                        uiwait(msgbox(['Ingrese las semillas del ' Words{ii} ', con el ultimo haga doble click o click derecho. Si NO hay, SOLO ponga 1 punto en algun lugar que no sea de las partes anteriores']));
                        [Puntos{ii,1}, Puntos{ii,2}] = getpts();
                    end
                    
                Vector_i{ii} = [sub2ind(size(Im_seg),uint16(Puntos{ii,2}'),uint16(Puntos{ii,1}'))];
                L_i{ii}  = [Valor_cluster(ii)*ones(1,length(Puntos{ii,1}))];
                 
            end

            axis equal
            axis tight
            axis off
            hold on;

            close(f1,f2)
            L = [];
            Vector = [];

            for kk=1:N  
                L = [L L_i{kk}];
                Vector = [Vector Vector_i{kk}];
            end  
            
            [mask,~] = random_walker(Im,Vector,L);

            f3 = figure('units', 'normalize', 'outerposition',[0 0 1 1]);
            subplot(1,2,1);
            imshow(mask,[]);
            subplot(1,2,2);
            [~,~,imgMarkup]=segoutput(Im,mask);
            imagesc(imgMarkup);
            colormap('gray')
            axis equal
            axis tight
            axis off
            hold on

            for jj = 1:N
                plot(Puntos{jj,1}, Puntos{jj,2},colores{jj},'Markersize',12);
            end
            title('Outlined mask')

            message = sprintf('Is it Ok?');
            reply = questdlg(message,'Physis','Yes','No (Hacer esta slice de nuevo)','Me faltaron puntos','No');

            if strcmpi(reply, 'Yes')
                Change = 0;
                falto = 0;
                condicion = 0;
                handles.V_seg.puntos{k} = [Puntos(:,1),Puntos(:,2)];
                handles.V_seg.mascara(:,:,k) = mask;
                handles.check(handles.v) = 1;
       
                
                for kk=1:length(Indice)
  
                    if  Indice(kk)
                        handles.V_seg.femur.bones(:,:,k) = mask==1;
                        
                    elseif Indice(kk)
                        handles.V_seg.femur.fisis(:,:,k) = mask==2;
                    
                    elseif Indice(kk)
                        handles.V_seg.tibia.bones(:,:,k) = mask==3;
                    
                    elseif Indice(kk)
                        handles.V_seg.tibia.fisis(:,:,k) = mask==4;
                    
                    elseif Indice(kk)           
                        handles.V_seg.perone.bones(:,:,k) = mask==5;
        
                    elseif Indice(kk)
                        handles.V_seg.perone.fisis(:,:,k) = mask==6;
                      
                    elseif Indice(kk)
                        handles.V_seg.rotula(:,:,k) = mask==7;
                    end
                    
                end
                close(f3)

            elseif strcmpi(reply, 'Me faltaron puntos')
                falto = 1;
                close(f3)

            else
                falto = 0;
                close(f3)

            end
        end
    end
end