function [Datos] = Fit_fisis_tibia(AP,SG)

    % Fit de proyecciones AP

    [Fit_AP_Fourier1,GOF_AP_F1] = fit(AP.Columnas,AP.Filas,'fourier1');
    [Fit_AP_Fourier2,GOF_AP_F2] = fit(AP.Columnas,AP.Filas,'fourier2');
    
    [Fit_SG_Pol_2, GOF_SG_P2] = fit(SG.Columnas,SG.Filas,'poly2');
    [Fit_SG_Pol_4, GOF_SG_E2] = fit(SG.Columnas,SG.Filas,'exp2');
    
    
    Datos{1} = GOF_AP_F1;
    Datos{2} = GOF_AP_F2;
    Datos{3} = GOF_SG_P2;
    Datos{4} = GOF_SG_E2;
    
end