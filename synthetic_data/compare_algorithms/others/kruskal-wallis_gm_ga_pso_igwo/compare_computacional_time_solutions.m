clc
clear all
close all;

% Tempo computacional para obter as soluções do Gauss-Newton com Multi-Start
time_gm = zeros(1, 4);

% Tempo computacional para obter as soluções do Algoritmo Genético
time_ga = zeros(1, 4); 

% Tempo computacional para obter as soluções da Nuvem de Partículas
time_pso = zeros(1, 4); 

% Tempo computacional para obter as soluções da Otimização por Lobos
% Cinzentos
time_gwo = zeros(1, 4); 

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
    
    addpath("../../IGWO/");
    eval(['load(''gwo_tobs_', num2str(i), '.mat'')']);
    time_gwo(i) = eval(['gwo_tobs_', num2str(i)]);
end

% Crie um vetor de grupos
grupos = [ones(length(time_gm), 1);  % Grupo 1: time_gm
          2 * ones(length(time_ga), 1);  % Grupo 2: time_ga
          3 * ones(length(time_pso), 1); % Grupo 3: time_pso
          4 * ones(length(time_gwo), 1)]; % Grupo 4: time_gwo

% Concatene os dados dos diferentes grupos
dados = [time_gm, time_ga, time_pso, time_gwo];

% Realize o teste de Kruskal-Wallis
p = kruskalwallis(dados, grupos, 'off');  % 'off' para desativar a exibição do gráfico

% Exiba os resultados
fprintf('Teste de Kruskal-Wallis para o tempo computacional\n');
fprintf('H0: Não há diferença entre o tempo computacional para obter as soluções com o Gauss-Newton com Multi-Start, Algoritmo Genético, Nuvem de Partículas e Otimização por Lobos Cinzentos Aprimorado Aprimorado.\n');
fprintf('H1: Há diferença entre o tempo computacional para obter as soluções com o Gauss-Newton com Multi-Start, Algoritmo Genético, Nuvem de Partículas e Otimização por Lobos Cinzentos Aprimorado Aprimorado.\n');
fprintf('Valor-p: %.4f\n', p);

% Avalie a hipótese nula
alpha = 0.05;  % Nível de significância

if p < alpha
    fprintf('Rejeitamos H0. Há diferença entre os tempos computacionais para obter as soluções com o Gauss-Newton com Multi-Start, Algoritmo Genético, Nuvem de Partículas e Otimização por Lobos Cinzentos Aprimorado Aprimorado.\n');

    sum_time_ga = sum(time_ga);
    sum_time_gm = sum(time_gm);
    sum_time_pso = sum(time_pso);
    sum_time_gwo = sum(time_gwo);

    if sum_time_ga < sum_time_gm && sum_time_ga < sum_time_pso && sum_time_ga < sum_time_gwo
        fprintf('O Algoritmo Genético teve o menor custo computacional.\n');
    elseif sum_time_gm < sum_time_pso && sum_time_gm < sum_time_gwo
        fprintf('O Gauss-Newton com Multi-Start teve o menor custo computacional.\n');
    elseif sum_time_pso < sum_time_gwo
        fprintf('A Nuvem de Partículas teve o menor custo computacional.\n');
    else
        fprintf('Otimização por Lobos Cinzentos Aprimorado Aprimorado teve o menor custo computacional.\n');
    end
else
    fprintf('Não rejeitamos H0. Não há diferença entre os tempos computacionais para obter as soluções com o Gauss-Newton com Multi-Start, Algoritmo Genético, Nuvem de Partículas e Otimização por Lobos Cinzentos Aprimorado Aprimorado.\n');
end



