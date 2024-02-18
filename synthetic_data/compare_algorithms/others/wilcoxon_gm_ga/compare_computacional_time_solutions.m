clc
clear all
close all

% Resultados do Gauss-Newton com Multi-Start e GA

% Tempo computacional para obter as soluções do Gauss-Newton com Multi-Start
time_gm = zeros(1, 4);

% Tempo computacional para obter as soluções do Algoritmo Genético
time_ga = zeros(1, 4); 

for i = 1:4
    % Carregue os arquivos .mat
    addpath("../../gauss_newton_multi_start/");
    eval(['load(''multi_start_tobs_', num2str(i), '.mat'')']);    
    time_gm(i) = eval(['multi_start_tobs_', num2str(i)]);

    addpath("../../genetic_algorithm/");
    eval(['load(''ga_tobs_', num2str(i), '.mat'')']);
    time_ga(i) = eval(['ga_tobs_', num2str(i)]);
end

% Teste de hipótese Wilcoxon para comparar os tempos computacionais
p = ranksum(time_gm, time_ga);

% Exiba os resultados
fprintf('Teste de Wilcoxon para o tempo computacional\n');
fprintf('H0: Não há diferença entre o tempo computacional para obter as soluções com o Gauss-Newton com Multi-Start e o Algoritmo Genético.\n');
fprintf('H1: Há diferença entre o tempo computacional para obter as soluções com o Gauss-Newton com Multi-Start e o Algoritmo Genético.\n');
fprintf('Valor-p: %.4f\n', p);

% Avalie a hipótese nula
alpha = 0.05;  % Nível de significância

if p < alpha
    fprintf('Rejeitamos H0. Há diferença entre os tempos computacionais para obter as soluções com o Gauss-Newton com Multi-Start e o Algoritmo Genético.\n');
    if sum(time_ga) < sum(time_gm)
        fprintf('O Algoritmo Genético teve o menor custo computacional.\n');
    else
        fprintf('O Gauss-Newton com Multi-Start teve o menor custo computacional.\n');
    end
else
    fprintf('Não rejeitamos H0. Não há diferença entre os tempos computacionais para obter as soluções com o Gauss-Newton com Multi-Start e o Algoritmo Genético.\n');
end

