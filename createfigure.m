function createfigure(X1, Y1, D1)
%CREATEFIGURE(X1, Y1, D1)
%  X1:  errorbar x vector data
%  Y1:  errorbar y vector data
%  D1:  errorbar delta vector data

%  Auto-generated by MATLAB on 21-Oct-2018 23:35:17

% Create figure
figure1 = figure('Color',[1 1 1]);

% Create axes
axes1 = axes('Parent',figure1);
hold(axes1,'on');

% Create errorbar
errorbar(X1,Y1,D1,'MarkerSize',12,...
    'MarkerFaceColor',[0 0.447058826684952 0.74117648601532],...
    'MarkerEdgeColor','none',...
    'Marker','o',...
    'LineStyle',':',...
    'LineWidth',1.5,...
    'CapSize',5,...
    'Color',[0 0 0]);

% Create ylabel
ylabel('% Broca afuera [%]','FontWeight','bold','FontSize',18);

% Create xlabel
xlabel('Profundidad [mm]','FontWeight','bold','FontSize',18);

% Create title
title('Todos','FontWeight','bold');

% Set the remaining axes properties
set(axes1,'FontSize',14,'FontWeight','bold','YGrid','on');
