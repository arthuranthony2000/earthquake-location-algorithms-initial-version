clc
clear all
close all

% Resultados do Gauss-Newton com Multi-Start e GA

% Vetor das somas dos custos das soluções do Gauss-Newton com Multi-Start
fss_gm = zeros(1, 4);

% Vetor das somas dos custos das soluções do Algoritmo Genético
fss_ga = zeros(1, 4);

for i = 1:4
    % Carregue os arquivos .mat
    addpath("../../gauss_newton_multi_start/");
    load(strcat('fss_', num2str(i)));
    fss_gm(i) = sum(sum(fss)/10);
    
    addpath("../../genetic_algorithm/");
    load(strcat('fss_', num2str(i)));
    fss_ga(i) = sum(sum(fss)/10);
end

iteracoes = 1:length(fss_gm);

% Plote os dados
figure;
hold on;
plot(iteracoes, fss_gm, 'ro', 'LineWidth', 2, 'MarkerFaceColor', 'red');
plot(iteracoes, fss_ga, 'go', 'LineWidth', 2, 'MarkerFaceColor', 'green');

% Adicione rótulos aos eixos
xlabel('Evento');
ylabel('Decrescimento da Função Objetivo');

% Adicione uma legenda
legend('Decrescimento do Gauss-Newton com Multi-Start', 'Decrescimento do Algoritmo Genético');

% Defina o título do gráfico
title('Comparação do Decrescimento da Função Objetivo');

% Mantenha a grade de fundo para facilitar a leitura
grid on;

% Mostrar o gráfico
hold off;

% Teste de hipótese Wilcoxon para comparar o descrescimento do desajuste
% das soluções
p = ranksum(fss_gm, fss_ga);

% Exiba os resultados
fprintf('Teste de Wilcoxon para o descrescimento das soluções:\n');
fprintf('H0: Não há diferença entre a soma dos custos das soluções obtidas pelo Gauss-Newton com Multi-Start e o Algoritmo Genético.\n');
fprintf('H1: Há diferença entre a soma dos custos das soluções obtidas pelo Gauss-Newton com Multi-Start e o Algoritmo Genético.\n');
fprintf('Valor-p: %.4f\n', p);

% Avalie a hipótese nula
alpha = 0.05;  % Nível de significância

if p < alpha
    fprintf('Rejeitamos H0. Há diferença entre as somas dos custos das soluções obtidas pelo Gauss-Newton com Multi-Start e o Algoritmo Genético.\n');
    if sum(fss_ga) < sum(fss_gm)
        fprintf('O Algoritmo Genético descresceu o desajuste mais rapidamente para o mínimo da função.\n');
    else
        fprintf('O Gauss-Newton com Multi-Start decresceu o desajuste mais rapidamente para o mínimo da função\n.');
    end
else
    fprintf('Não rejeitamos H0. Não há diferença entre as somas dos custos das soluções obtidas pelo Gauss-Newton com Multi-Start e o Algoritmo Genético.\n');
    
end

