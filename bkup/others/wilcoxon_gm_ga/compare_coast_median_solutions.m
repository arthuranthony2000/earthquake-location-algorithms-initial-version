clc
clear all
close all

% Resultados do Gauss-Newton com Multi-Start e GA

% Vetor dos custos das médias das soluções do Gauss-Newton com Multi-Start
fmss_gm = zeros(1, 4);

% Vetor dos custos das médias das soluções do Algoritmo Genético
fmss_ga = zeros(1, 4);

for i = 1:4
    % Carregue os arquivos .mat
    addpath("../../gauss_newton_multi_start/");
    load(strcat('fmss_', num2str(i)));
    fmss_gm(:, i) = fmss;
    
    addpath("../../genetic_algorithm/");
    load(strcat('fmss_', num2str(i)));
    fmss_ga(:, i) = fmss;
end

% Suponha que você tenha os vetores fmss_gm e fmss_ga definidos

% Crie um vetor de iterações (ou índice) para o eixo X, assumindo que tenha o mesmo comprimento que os dados
iteracoes = 1:length(fmss_gm);

% Plote os dados
figure;
hold on;
plot(iteracoes, fmss_gm, 'ro', 'LineWidth', 2, 'MarkerFaceColor', 'red');
plot(iteracoes, fmss_ga, 'go', 'LineWidth', 2, 'MarkerFaceColor', 'green');

% Adicione rótulos aos eixos
xlabel('Evento');
ylabel('Custo da Função Objetivo');

% Adicione uma legenda
legend('Custo Médio Gauss-Newton com Multi-Start', 'Custo Médio Algoritmo Genético');

% Defina o título do gráfico
title('Comparação do Custo Médio da Função Objetivo');

% Mantenha a grade de fundo para facilitar a leitura
grid on;

% Mostrar o gráfico
hold off;


% Teste de hipótese Wilcoxon para comparar os custos das soluções médias
p = ranksum(fmss_gm, fmss_ga);

% Exiba os resultados
fprintf('Teste de Wilcoxon para o custo das soluções médias:\n');
fprintf('H0: Não há diferença entre os custos das soluções médias obtidas pelo Gauss-Newton com Multi-Start e o Algoritmo Genético.\n');
fprintf('H1: Há diferença entre os custos das soluções médias obtidas pelo Gauss-Newton com Multi-Start e o Algoritmo Genético.\n');
fprintf('Valor-p: %.4f\n', p);

% Avalie a hipótese nula
alpha = 0.05;  % Nível de significância

if p < alpha
    fprintf('Rejeitamos H0. Há diferença entre os custos das soluções médias obtidas pelo Gauss-Newton com Multi-Start e o Algoritmo Genético.\n');
    if sum(fmss_ga) < sum(fmss_gm)
        fprintf('O Algoritmo Genético obteve os menores custos da função objetivo em suas soluções médias.\n');
    else
        fprintf('O Gauss-Newton com Multi-Start obteve os menores custos da função objetivo em suas soluções médias.\n.');
    end
else
    fprintf('Não rejeitamos H0. Não há diferença entre os custos das soluções médias obtidas pelo Gauss-Newton com Multi-Start e o Algoritmo Genético.\n');        
end

