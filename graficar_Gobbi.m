function graficar_Gobbi(Dist_Aj,Displasia,corte)
% Función para hacer las gracias de las distintas proyecciones
% Dis_Aj es la estrucutras con las filas
% Displasia es el vector displasia y Corte es el corte para escojer los
% grupos

    figure(1); 
    set(gcf,'color','white')
    figure(2);
    set(gcf,'color','white')


    for k=1:4  

        Filas_AjSG = Dist_Aj(k).SG;
        Columna_usarSG = Dist_Aj(k).SG_col;

        figure(1)
        subplot(2,2,k)
        hold on;
        axis on
        axis equal
        daspect([1 1 1])

            MeanSG_D =  mean(Filas_AjSG(Displasia >= corte,:),'omitnan');
            MeanSG_ND =  mean(Filas_AjSG(Displasia == 0,:),'omitnan');

            p1 = plot(Columna_usarSG, MeanSG_D,'--r','LineWidth',3);
            %p3 = plot(Columna_usarSG,repmat(mean(MeanSG_D,'omitnan'),[1,length(Columna_usarSG)]),...
            %'*r','LineWidth',1);
            %p3 = plot(Columna_usarAP, median(Filas_AjAP(Masculino,:),'omitnan') + iqr(Filas_AjAP(Masculino,:)),'--y','LineWidth',2);
            %plot(Columna_usarAP, median(Filas_AjAP(Masculino,:),'omitnan') - iqr(Filas_AjAP(Masculino,:)),'--y','LineWidth',2);
            p2 = plot(Columna_usarSG,MeanSG_ND,'--b','LineWidth',3);
            %p4 = plot(Columna_usarSG,repmat(mean(MeanSG_ND,'omitnan'),[1,length(Columna_usarSG)]),...
            %'*b','LineWidth',1);
            %scatter(Columna_usarSG,3*H_sg{k},'MarkerFaceColor','yellow')
            %p4 = plot(Columna_usarAP, median(Filas_AjAP(Mujeres,:),'omitnan') + iqr(Filas_AjAP(Mujeres,:)),'--m','LineWidth',2);
            %plot(Columna_usarAP, median(Filas_AjAP(Mujeres,:),'omitnan') - iqr(Filas_AjAP(Mujeres,:)),'--m','LineWidth',2)
            legend([p1 p2 ],'Displasia','No Displasia','Mu Displasia','Mu No Displasia', 'FontSize',14)
            title(['Proyeccion Sagital ' num2str(k) ' ° cuarto'])
            %bar(Columna_usarSG,MeanSG_D - MeanSG_ND)

        figure(2)
        subplot(2,2,k)
        hold on;
        axis on
        axis equal
        daspect([1 1 1])

            Filas_AjAP = Dist_Aj(k).AP;
            Columna_usarAP = Dist_Aj(k).AP_col;

            MeanAP_D =  mean(Filas_AjAP(Displasia >= corte,:),'omitnan');
            MeanAP_ND = mean(Filas_AjAP(Displasia == 0,:),'omitnan');

            p1 = plot(Columna_usarAP, MeanAP_D,'--r','LineWidth',3);
            p3 = plot(Columna_usarAP,repmat(mean(MeanAP_D,'omitnan'),[1,length(Columna_usarAP)]),...
            '-r','LineWidth',1);
            %p3 = plot(Columna_usarAP, median(Filas_AjAP(Masculino,:),'omitnan') + iqr(Filas_AjAP(Masculino,:)),'--y','LineWidth',2);
            %plot(Columna_usarAP, median(Filas_AjAP(Masculino,:),'omitnan') - iqr(Filas_AjAP(Masculino,:)),'--y','LineWidth',2);
            p2 = plot(Columna_usarAP, MeanAP_ND,'--b','LineWidth',3);
            p4 = plot(Columna_usarAP,repmat(mean(MeanAP_ND,'omitnan'),[1,length(Columna_usarAP)]),...
            '-b','LineWidth',1);
            %scatter(Columna_usarAP,3*H_ap{k},'MarkerFaceColor','yellow')
            %p4 = plot(Columna_usarAP, median(Filas_AjAP(Mujeres,:),'omitnan') + iqr(Filas_AjAP(Mujeres,:)),'--m','LineWidth',2);
            %plot(Columna_usarAP, median(Filas_AjAP(Mujeres,:),'omitnan') - iqr(Filas_AjAP(Mujeres,:)),'--m','LineWidth',2)
            legend([p1 p2 p3 p4],'Displasia','No Displasia','Mu Displasia','Mu No Displasia', 'FontSize',14)
            title(['Proyeccion AP ' num2str(k) ' ° cuarto'])

    end
end
