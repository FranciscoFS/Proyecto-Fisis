function Dist_Aj = Proyecciones_Gobbi(BD_T,p,ver)

    Puntos = cell(numel(BD_T),1);

    Distribucion1 = struct('AP',[],'SG',[],'AP_norm',[],'SG_norm',[]);
    Distribucion2 = struct('AP',[],'SG',[],'AP_norm',[],'SG_norm',[]);
    Distribucion3 = struct('AP',[],'SG',[],'AP_norm',[],'SG_norm',[]);
    Distribucion4 = struct('AP',[],'SG',[],'AP_norm',[],'SG_norm',[]);
    aux = 0;

    for k=1:numel(BD_T)

        Rodilla = BD_T(k).Rodilla;

        if size(Rodilla.mascara,2) > 900
            aux = aux +1;
            dx = Rodilla.info{1}*2; 
            dz = Rodilla.info{2}*2;
            pace = dx/dz;

            Puntos{k,1} = round(Rodilla.info{20,1}/(2*pace));

            Fisis = single(Rodilla.mascara == 2);
            [n,m,z] = size(Fisis);
            [Xeq,Yeq,Zeq] = meshgrid(1:2:n,1:2:m,1:2*pace:z);
            Fisis = interp3(Fisis,Xeq,Yeq,Zeq,'nearest');
            Fisis = Fisis > 0.2;
            Fisis_4 = zonas(Fisis,Puntos{k,1},p);

            Distribucion1(k) = ProyeccionesFisis(Fisis_4{1},dx);
            Distribucion2(k) = ProyeccionesFisis(Fisis_4{2},dx);
            Distribucion3(k) = ProyeccionesFisis(Fisis_4{3},dx);
            Distribucion4(k) = ProyeccionesFisis(Fisis_4{4},dx);

        else

            dx = Rodilla.info{1}; 
            dz = Rodilla.info{2};
            pace = dx/dz;

            Puntos{k,1} = round(Rodilla.info{20,1}/pace);

            Fisis = single(Rodilla.mascara == 2);
            [n,m,z] = size(Fisis);
            [Xeq,Yeq,Zeq] = meshgrid(1:n,1:m,1:pace:z);
            Fisis = interp3(Fisis,Xeq,Yeq,Zeq,'nearest');
            Fisis = Fisis > 0.2;

            Fisis_4 = zonas(Fisis,Puntos{k,1},p);

            Distribucion1(k) = ProyeccionesFisis(Fisis_4{1},dx);
            Distribucion2(k) = ProyeccionesFisis(Fisis_4{2},dx);
            Distribucion3(k) = ProyeccionesFisis(Fisis_4{3},dx);
            Distribucion4(k) = ProyeccionesFisis(Fisis_4{4},dx);

        end

        fprintf('Rodilla numero %d  \n',k)

    end

    % Ajustar por tamaño Nombrar Distribucion a la zona a usar 
    %


    if ver
        figure(1); 
        set(gcf,'color','white')
        figure(2);
        set(gcf,'color','white')
    end

    aux2 = 0;
    Distribuciones = {Distribucion1,Distribucion2,Distribucion3,Distribucion4};
    Dist_Aj = struct('AP',[],'SG',[]);

    for j=1:4

        Distribucion = Distribuciones{j};

        LargosSG_norm = zeros(1,numel(Distribucion));
        LargosAP_norm = zeros(1,numel(Distribucion));

        for k=1:numel(Distribucion)
            LargosSG_norm(k) = length(Distribucion(k).SG_norm.Filas);
            LargosAP_norm(k) = length(Distribucion(k).AP_norm.Filas);
        end

        [MaxSG, MaxSG_pos] = max(LargosSG_norm);
        [MaxAP, MaxAP_pos] = max(LargosAP_norm);

        Filas_AjSG = nan(numel(Distribucion),MaxSG);
        Columna_usarSG = Distribucion(MaxSG_pos).SG_norm.Columnas;

        Filas_AjAP = nan(numel(Distribucion),MaxAP);
        Columna_usarAP = Distribucion(MaxAP_pos).AP_norm.Columnas;

        for k=1:numel(Distribucion)

           try

            LargoSG = length(Distribucion(k).SG_norm.Filas);
            pace = LargoSG/MaxSG;
            InterpolFilasSG = interp1(Distribucion(k).SG_norm.Filas,1:pace:LargoSG,'PCHIP');

            LargoAP = length(Distribucion(k).AP_norm.Filas);
            paceAP = LargoAP/MaxAP;
            InterpolFilasAP = interp1(Distribucion(k).AP_norm.Filas,1:paceAP:LargoAP,'PCHIP');

            if length(InterpolFilasSG) == MaxSG
                Filas_AjSG(k,:) = InterpolFilasSG;

            else
                Diff = MaxSG - length(InterpolFilasSG);
                InterpolFilasSG(end+1:end +Diff) = NaN(1,Diff);
                Filas_AjSG(k,:) = InterpolFilasSG;
                %DiffsSG(end +1) = Diff;

            end

            if length(InterpolFilasAP) == MaxAP
                Filas_AjAP(k,:) = InterpolFilasAP;        
            else
                Diff = MaxAP - length(InterpolFilasAP);
                InterpolFilasAP(end+1:end +Diff) = NaN(1,Diff);
                Filas_AjAP(k,:) = InterpolFilasAP;
                %DiffsAP(end +1) = Diff;

            end

            catch
                aux2 = aux2 +1;
                malo2(aux2) = k;
                continue
            end

        end

        Dist_Aj(j).SG = Filas_AjSG;
        Dist_Aj(j).AP = Filas_AjAP;
        Dist_Aj(j).SG_col = Columna_usarSG;
        Dist_Aj(j).AP_col = Columna_usarAP;    

    %     dif = abs(Columna_usarSG - (min(Columna_usarSG) + 4));
    %     pos = find(dif == min(dif));

        if ver

            figure(1)
            subplot(2,2,j)
            hold on;
            axis on
            axis equal
            daspect([1 1 1])

            MeanSG_D =  mean(Filas_AjSG(Displasia == 1,:),'omitnan');
            MeanSG_ND =  mean(Filas_AjSG(Displasia == 0,:),'omitnan');
            MeanAP_D =  mean(Filas_AjAP(Displasia == 1,:),'omitnan');
            MeanAP_ND = mean(Filas_AjAP(Displasia == 0,:),'omitnan');


            p1 = plot(Columna_usarSG, MeanSG_D,'--r','LineWidth',3);
            p3 = plot(Columna_usarSG,repmat(mean(MeanSG_D,'omitnan'),[1,length(Columna_usarSG)]),...
                '*r','LineWidth',1);
            %p3 = plot(Columna_usarAP, median(Filas_AjAP(Masculino,:),'omitnan') + iqr(Filas_AjAP(Masculino,:)),'--y','LineWidth',2);
            %plot(Columna_usarAP, median(Filas_AjAP(Masculino,:),'omitnan') - iqr(Filas_AjAP(Masculino,:)),'--y','LineWidth',2);
            p2 = plot(Columna_usarSG,MeanSG_ND,'--b','LineWidth',3);
            p4 = plot(Columna_usarSG,repmat(mean(MeanSG_ND,'omitnan'),[1,length(Columna_usarSG)]),...
                '*b','LineWidth',1);
            %p4 = plot(Columna_usarAP, median(Filas_AjAP(Mujeres,:),'omitnan') + iqr(Filas_AjAP(Mujeres,:)),'--m','LineWidth',2);
            %plot(Columna_usarAP, median(Filas_AjAP(Mujeres,:),'omitnan') - iqr(Filas_AjAP(Mujeres,:)),'--m','LineWidth',2)
            legend([p1 p2 p3 p4],'Displasia','No Displasia','Mu Displasia','Mu No Displasia', 'FontSize',14)
            title(['Proyeccion Sagital ' num2str(j) ' ° cuarto'])

            figure(2)
            subplot(2,2,j)
            hold on;
            axis on
            axis equal
            daspect([1 1 1])


            p1 = plot(Columna_usarAP, MeanAP_D,'--r','LineWidth',3);
            p3 = plot(Columna_usarAP,repmat(mean(MeanAP_D,'omitnan'),[1,length(Columna_usarAP)]),...
                '-r','LineWidth',1);
            %p3 = plot(Columna_usarAP, median(Filas_AjAP(Masculino,:),'omitnan') + iqr(Filas_AjAP(Masculino,:)),'--y','LineWidth',2);
            %plot(Columna_usarAP, median(Filas_AjAP(Masculino,:),'omitnan') - iqr(Filas_AjAP(Masculino,:)),'--y','LineWidth',2);
            p2 = plot(Columna_usarAP, MeanAP_ND,'--b','LineWidth',3);
            p4 = plot(Columna_usarAP,repmat(mean(MeanAP_ND,'omitnan'),[1,length(Columna_usarAP)]),...
                '-b','LineWidth',1);
            %p4 = plot(Columna_usarAP, median(Filas_AjAP(Mujeres,:),'omitnan') + iqr(Filas_AjAP(Mujeres,:)),'--m','LineWidth',2);
            %plot(Columna_usarAP, median(Filas_AjAP(Mujeres,:),'omitnan') - iqr(Filas_AjAP(Mujeres,:)),'--m','LineWidth',2)
            legend([p1 p2 p3 p4],'Displasia','No Displasia','Mu Displasia','Mu No Displasia', 'FontSize',14)
            title(['Proyeccion AP ' num2str(j) ' ° cuarto'])
        end

    end
end