
clc
clear all
close all

rotulos = {' X', ' Y', ' Z'};

hipo_names = {' A', ' B', ' C', ' D'};

num_hipocentros = 4;

% Crie uma única figura com 6 colunas e 2 linhas
figure;

for j = 1:num_hipocentros
    load(strcat('ssf_', string(j)));

    for i = 1:size(ssf, 2)
        % Defina a posição do subplot na matriz de subplots (2 linhas, 6 colunas)
        subplot(2, 6, (j - 1) * 3 + i); % O (j - 1) * 3 + i calcula a posição correta
        
        % Título do subplot
        %title(strcat('Hipocentro', hipo_names(j), ' - Parâmetro', rotulos{i}));
        
        title(strcat('Parâmetro', rotulos{i}));
        xlabel('Dados');
        ylabel('Frequência');
        hold on;

        hist(ssf(:, i));

        hold off;
        grid on;
    end
end

% Ajuste o tamanho da figura para acomodar todos os subplots
set(gcf, 'Position', [100, 100, 1200, 600]);

% Adicione um título geral à figura
sgtitle('Histograma parâmetros hipocentrais', 'FontSize', 14, 'FontWeight', 'bold');
