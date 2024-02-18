clc
clear all
close all;

load('cx_1');
load('cy_1');
load('cz_1');
load('v_1');

% Vetor com as soluções verdadeiras
ss = zeros(1, 12);

% Vetor da média das soluções do Gauss-Newton com Multi-Start
mss_gm = zeros(1, 12);

% Vetor da média das soluções do Algoritmo Genético
mss_ga = zeros(1, 12);

% Vetor da média das soluções da Nuvem de Partículas
mss_pso = zeros(1, 12);

% Vetor da média das soluções do Algoritmo de Otimização por Lobos
% Cinzentos
mss_gwo = zeros(1, 12);

col_idx = 1; % Índice da próxima coluna em mss_gm e mss_ga

for i = 1:4
    % Carregue os arquivos .mat
    addpath("../gauss_newton_multi_start/");
    load(strcat('mss_', num2str(i)));
    load(strcat('s_', num2str(i)));
    ss(:, col_idx:col_idx+2) = s;
    mss_gm(:, col_idx:col_idx+2) = mss;
    
    addpath("../genetic_algorithm/");
    load(strcat('mss_', num2str(i)));
    mss_ga(:, col_idx:col_idx+2) = mss;
    
    addpath("../PSO/");
    load(strcat('mss_', num2str(i)));
    mss_pso(:, col_idx:col_idx+2) = mss;
    
    addpath("../HybridGWO/");
    load(strcat('mss_', num2str(i)));
    mss_gwo(:, col_idx:col_idx+2) = mss;
    
    col_idx = col_idx + 3;
end

% Suponha que você tenha os vetores mss_gm, mss_ga e mss_pso definidos

% Crie um vetor de grupos
grupos = [ones(length(mss_gm), 1);  % Grupo 1: mss_gm
          2 * ones(length(mss_ga), 1);  % Grupo 2: mss_ga
          3 * ones(length(mss_pso), 1);
          4 * ones(length(mss_gwo), 1)];  % Grupo 3: mss_pso

% Concatene os dados dos diferentes grupos
dados = [mss_gm, mss_ga, mss_pso, mss_gwo];

% Realize o teste de Kruskal-Wallis
p = kruskalwallis(dados, grupos, 'off');  % 'off' para desativar a exibição do gráfico

% Exiba os resultados
fprintf('Teste de Kruskal-Wallis para as soluções médias:\n');
fprintf('H0: Não há diferença entre as soluções médias obtidas pelo Gauss-Newton com Multi-Start, Algoritmo Genético, Nuvem de Partículas e Otimização por Lobos Cinzentos Hibridizado.\n');
fprintf('H1: Há diferença entre as solução médias obtidas pelo Gauss-Newton com Multi-Start, Algoritmo Genético, Nuvem de Partículas e Otimização por Lobos Cinzentos Hibridizado.\n');
fprintf('Valor-p: %.4f\n', p);

% Avalie a hipótese nula
alpha = 0.05;  % Nível de significância

if p < alpha
    fprintf('Rejeitamos H0. Há diferença entre as soluções médias obtidas pelo Gauss-Newton com Multi-Start, Algoritmo Genético, Nuvem de Partículas e Otimização por Lobos Cinzentos Hibridizado.\n');

    norm_diff_ga = norm(mss_ga - ss);
    norm_diff_gm = norm(mss_gm - ss);
    norm_diff_pso = norm(mss_pso - ss);
    norm_diff_gwo = norm(mss_gwo - ss);

    if norm_diff_ga < norm_diff_pso && norm_diff_ga < norm_diff_gwo
        fprintf('O Algoritmo Genético obteve soluções médias mais próximas das verdadeiras.\n');
    elseif norm_diff_gm < norm_diff_pso && norm_diff_gm < norm_diff_gwo
        fprintf('O Gauss-Newton com Multi-Start obteve soluções médias mais próximas das verdadeiras.\n');
    elseif norm_diff_pso < norm_diff_gwo
        fprintf('A Nuvem de Partículas obteve soluções médias mais próximas das verdadeiras.\n');
    else
        fprintf('Otimização por Lobos Cinzentos Hibridizado obteve soluções médias mais próximas das verdadeiras.\n');
    end
else
    fprintf('Não rejeitamos H0. Não há diferença entre as soluções médias obtidas pelo Gauss-Newton com Multi-Start, Algoritmo Genético, Nuvem de Partículas e Otimização por Lobos Cinzentos Hibridizado.\n');
end

% Plote os sismos
figure;
hold on;
plot3(ss(1:3:end), ss(2:3:end), ss(3:3:end), 'kpentagram', 'MarkerFaceColor', 'black', 'MarkerSize', 8, 'DisplayName', 'Real Hypocenter');
plot3(mss_gm(1:3:end), mss_gm(2:3:end), mss_gm(3:3:end), 'rpentagram', 'MarkerFaceColor', 'red', 'MarkerSize', 8, 'DisplayName', 'Gauss-Newton with Multi-Start');
plot3(mss_ga(1:3:end), mss_ga(2:3:end), mss_ga(3:3:end), 'gpentagram', 'MarkerFaceColor', 'green', 'MarkerSize', 8, 'DisplayName', 'Genetic Algorithm');
plot3(mss_pso(1:3:end), mss_pso(2:3:end), mss_pso(3:3:end), 'kpentagram', 'MarkerFaceColor', 'yellow', 'MarkerSize', 8, 'DisplayName', 'Particle Swarm Optimization');
plot3(mss_gwo(1:3:end), mss_gwo(2:3:end), mss_gwo(3:3:end), 'bpentagram', 'MarkerFaceColor', 'blue', 'MarkerSize', 8, 'DisplayName', 'Hybrid Grey Wolf Optimizer');
scatter3(cx, cy, cz, "bv", 'MarkerFaceColor','blue', 'DisplayName','Seismographic Stations');

% Adicione rótulos aos eixos
xlabel('Latitude');
ylabel('Longitude');
zlabel('Depth');

% Adicione uma legenda
legend;

% Defina o título do gráfico
title('Hypocenter Locations');

% Defina a visualização para uma melhor perspectiva 3D
view(3);

% Mantenha a grade de fundo para facilitar a leitura
grid on;

% Mostrar o gráfico
hold off;




