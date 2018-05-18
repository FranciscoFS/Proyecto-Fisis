function Output = Cargar()

    [filename, pathname,~] = uigetfile();
    Output = load([pathname filename],'V_seg');
    Output = Output.V_seg;
    
end
     