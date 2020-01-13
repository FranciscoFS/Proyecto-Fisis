function [TAC,RM] = Pendientes(TAC,RM)

    % RM Valores Intercondileos
    
    infoRM = RM.info{10,1};
    x = infoRM{1,1};
    y = infoRM{2,1};
    
    if x(2) == x(1)
        x(2) = x(2) +1;
    end
    if y(2) == y(1)
        y(2) = y(2) +1;
    end
    
    m_F_RM = (y(2)-y(1))/(x(2)-x(1));
    Angulo_F_RM = atand(abs(m_F_RM));
    
    % Valores Tibia
    
    x_3 = infoRM{5,1};
    y_3 = infoRM{6,1};
    
    if x_3(2) == x_3(1)
        x_3(2) = x_3(1) +1;
    end
    if y_3(2) == y_3(1)
        y_3(2) = y_3(2) +1;
    end
    
    m_T_RM = (y_3(2)-y_3(1))/(x_3(2)-x_3(1));
    Angulo_T_RM = atand(abs(m_T_RM));
    
    %TAC Femur
       
    infoTAC = TAC.info{10,1};
    x = infoTAC{1,1};
    y = infoTAC{2,1};
    
    if x(2) == x(1)
        x(2) = x(2) +1;
    end
    if y(2) == y(1)
        y(2) = y(2) +1;
    end
    
    m_F_TAC = (y(2)-y(1))/(x(2)-x(1));
    Angulo_F_TAC = atand(abs(m_F_RM));
    
    % TAC Tibia
    
    infoTAC = TAC.info{12,1};
        x = infoTAC{1,1};
    y = infoTAC{2,1};
    
    if x(2) == x(1)
        x(2) = x(2) +1;
    end
    if y(2) == y(1)
        y(2) = y(2) +1;
    end
    
    m_T_TAC = (y(2)-y(1))/(x(2)-x(1));
    Angulo_T_TAC = atand(abs(m_T_RM));
    
   
    RM.info{13} = [m_F_RM Angulo_F_RM ; m_T_RM Angulo_T_RM];
    TAC.info{13} = [m_F_TAC Angulo_F_TAC ; m_T_TAC Angulo_T_TAC];
    
    end
    
    