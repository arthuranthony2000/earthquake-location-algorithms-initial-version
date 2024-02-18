clc
clear all
close all

rotulos = {' X', ' Y', ' Z'};

hipo_names = {' A', ' B', ' C', ' D'};

num_hipocentros = 4;
nivel_de_confianca = 0.95; % Nível de confiança desejado (95%)

for j = 1:num_hipocentros
    figure(j)
    load(strcat('ssf_', string(j)));
    
    sgtitle(strcat('Hipocentro', hipo_names(j)), 'FontSize', 14, 'FontWeight', 'bold');
    
    for i = 1:size(ssf, 2)
        subplot(1, 3, i); % Subplot na posição (1, i)
        title(strcat('Parâmetro', rotulos{i}));
        xlabel('Índice');
        ylabel('Valor');
        hold on;

        % Calcula a média e o desvio padrão amostral
        avg = mean(ssf(:, i));
        dv = std(ssf(:, i));
        
        % Calcula o erro padrão da média
        erro_padrao_media = dv / sqrt(length(ssf));
        
        % Encontra o valor crítico da distribuição normal padrão
        valor_critico = norminv((1 + nivel_de_confianca) / 2, 0, 1);
        
        % Calcula a margem de erro
        margem_de_erro = valor_critico * erro_padrao_media;

        % Calcula os limites do intervalo de confiança
        limite_inferior_CI = avg - margem_de_erro;
        limite_superior_CI = avg + margem_de_erro;

        % Plota a média com um ponto preto
        plot(avg, "k.", 'DisplayName', 'Média', 'MarkerSize', 20);

        % Plota os limites superior e inferior com marcadores diferentes
        plot(limite_superior_CI, "b^", 'DisplayName', 'Limite Superior', 'MarkerFaceColor', 'blue');
        plot(limite_inferior_CI, "rv", 'DisplayName', 'Limite Inferior', 'MarkerFaceColor', 'red');

        hold off;
        grid on;
    end
    
    legend('Location', 'northoutside');
end
