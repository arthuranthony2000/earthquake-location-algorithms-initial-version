clc;
clear all;
close all;

rotulos = {' X', ' Y', ' Z'};

hipo_names = {' A', ' B', ' C', ' D'};

num_hipocentros = 4;

% Crie uma figura com subplots 2x2
figure;

for j = 1:num_hipocentros
    load(strcat('tobs_', string(j)));
    
    % Determine as coordenadas do subplot com base em j
    subplot(2, 2, j);
    
    hold on;
    
    qqplot(tobs);
    
    % Adicione rótulos para os eixos x e y
    title(['Hipocentro', hipo_names{j}], 'FontSize', 14, 'FontWeight', 'bold');
    xlabel('Quantis Teóricos', 'FontSize', 12, 'FontWeight', 'bold');
    ylabel('Quantis Observados', 'FontSize', 12, 'FontWeight', 'bold');
    
    hold off;
    grid on;
end

% Defina o título principal da figura
sgtitle('QQplot dados', 'FontSize', 16, 'FontWeight', 'bold');
