% Script de Comparacion de Angulos Z


%N = 10; % Numero de rodillas a analizar
[FileName,PathName,FilterIndex] = uigetfile('MultiSelect','on');
N = length(FileName);
PCA_Z = zeros(1,N);
Manual_Z = zeros(1,N);
RProps_Z = zeros(1,N);

for i=1:length(FileName)
    
    V_i = load([PathName FileName{i}],'V_seg');
    PCA_Z(i) = Angulo_Z(V_i.V_seg);
    Angulos = regionprops3(V_i.V_seg.femur.bones,'Orientation');
    RProps_Z(i) = Angulos.Orientation(1);
    
    f = figure;
    imshow(crear_rx(V_i.V_seg));
    hold on
    
    uiwait(msgbox('Ingrese dos puntos para el primer circulo, con el ultimo haga doble click'));
    [Y1,X1] = getpts();
    uiwait(msgbox('Ingrese dos puntos para el segundo circulo, con el ultimo haga doble click'));
    [Y2,X2] = getpts();
    %Punto medio
    centro1 = [(X1(1)+X1(2))/2,(Y1(1)+Y1(2))/2];
    centro2 = [(X2(1)+X2(2))/2,(Y2(1)+Y2(2))/2];
    x = [centro1(1),centro2(1)];
    y = [centro1(2),centro2(2)];
    m1 = (y(2)-y(1))/(x(2)-x(1));   
    Manual_Z(i) = atand(m1);
    
    close(f)
    
end