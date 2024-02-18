clc
clear all
close all

rotulos = {' X', ' Y', ' Z'};

hipo_names = {' A', ' B', ' C', ' D'};

num_hipocentros = 4;

for j=1:num_hipocentros
    figure(j)
    
    load(strcat('tobs_', string(j)));
    
    hold on;
    
    qqplot(tobs);
    
    % Adicione rótulos para os eixos x e y
    title(strcat('Hipocentro', hipo_names(j)), 'FontSize', 14, 'FontWeight', 'bold');
    xlabel('Quantis Teóricos', 'FontSize', 12, 'FontWeight', 'bold');
    ylabel('Quantis Observados', 'FontSize', 12, 'FontWeight', 'bold');
    
    hold off;
    grid on;
end



