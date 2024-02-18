clc
clear all
close all

rotulos = {' X', ' Y', ' Z'};

hipo_names = {' A', ' B', ' C', ' D'};

num_hipocentros = 4;

for j=1:num_hipocentros
figure(j)
    
load(strcat('ssf_', string(j)));

sgtitle(strcat('Hipocentro', hipo_names(j)), 'FontSize', 14, 'FontWeight', 'bold');

for i = 1:size(ssf, 2)
    subplot(1, 3, i); % Subplot na posição (1, i)
    title(strcat('Parâmetro', rotulos{i}));
    xlabel('Dados');
    ylabel('Valores');
    hold on;
    
    boxplot(ssf(:, i))

    hold off;
    grid on;
    
end

end