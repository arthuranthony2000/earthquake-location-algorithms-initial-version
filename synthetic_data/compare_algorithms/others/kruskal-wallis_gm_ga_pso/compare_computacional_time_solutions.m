clc
clear all
close all;

% Tempo computacional para obter as soluções do Gauss-Newton com Multi-Start
time_gm = zeros(1, 4);

% Tempo computacional para obter as soluções do Algoritmo Genético
time_ga = zeros(1, 4); 

% Tempo computacional para obter as soluções da Nuvem de Partículas
time_pso = zeros(1, 4); 

for i = 1:4
    % Carregue os arquivos .mat
    addpath("../../gauss_newton_multi_start/");
    eval(['load(''multi_start_tobs_', num2str(i), '.mat'')']);    
    time_gm(i) = eval(['multi_start_tobs_', num2str(i)]);

    addpath("../../genetic_algorithm/");
    eval(['load(''ga_tobs_', num2str(i), '.mat'')']);
    time_ga(i) = eval(['ga_tobs_', num2str(i)]);
    
    addpath("../../PSO/");
    eval(['load(''pso_tobs_', num2str(i), '.mat'')']);
    time_pso(i) = eval(['pso_tobs_', num2str(i)]);
end

% Crie um vetor de grupos
grupos = [ones(length(time_gm), 1);  % Grupo 1: time_gm
          2 * ones(length(time_ga), 1);  % Grupo 2: time_ga
          3 * ones(length(time_pso), 1)];  % Grupo 3: time_pso

% Concatene os dados dos diferentes grupos
dados = [time_gm, time_ga, time_pso];

% Realize o teste de Kruskal-Wallis
p = kruskalwallis(dados, grupos, 'off');  % 'off' para desativar a exibição do gráfico

% Exiba os resultados
fprintf('Teste de Kruskal-Wallis para o tempo computacional\n');
fprintf('H0: Não há diferença entre o tempo computacional para obter as soluções com o Gauss-Newton com Multi-Start, Algoritmo Genético e Nuvem de Partículas.\n');
fprintf('H1: Há diferença entre o tempo computacional para obter as soluções com o Gauss-Newton com Multi-Start, Algoritmo Genético e Nuvem de Partículas.\n');
fprintf('Valor-p: %.4f\n', p);

% Avalie a hipótese nula
alpha = 0.05;  % Nível de significância

if p < alpha
    fprintf('Rejeitamos H0. Há diferença entre os tempos computacionais para obter as soluções com o Gauss-Newton com Multi-Start, Algoritmo Genético e Nuvem de Partículas.\n');
    
    if sum(time_ga) < sum(time_gm)       
        if sum(time_ga) < sum(time_pso)
            fprintf('O Algoritmo Genético teve o menor custo computacional.\n');
        else
            fprintf('A Nuvem de Partículas com Multi-Start teve o menor custo computacional.\n');
        end
    else
        if sum(time_gm) < sum(time_pso)
            fprintf('O Gauss-Newton com Multi-Start teve o menor custo computacional.\n');
        else
            fprintf('A Nuvem de Partículas com Multi-Start teve o menor custo computacional.\n');
        end
    end
else
    fprintf('Não rejeitamos H0. Não há diferença entre os tempos computacionais para obter as soluções com o Gauss-Newton com Multi-Start, Algoritmo Genético e Nuvem de Partículas.\n');
end


