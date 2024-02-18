clc
clear all
close all;

% Vetor dos custos das médias das soluções do Gauss-Newton com Multi-Start
fmss_gm = zeros(1, 4);

% Vetor dos custos das médias das soluções do Algoritmo Genético
fmss_ga = zeros(1, 4);

% Vetor dos custos das médias das soluções da Nuvem de Partículas
fmss_pso = zeros(1, 4);

% Vetor dos custos das médias das soluções do Algoritmo de Otimização por
% Lobos Cinzentos
fmss_gwo = zeros(1, 4);

for i = 1:4
    % Carregue os arquivos .mat
    addpath("../gauss_newton_multi_start/");
    load(strcat('fmss_', num2str(i)));
    fmss_gm(:, i) = fmss;
    
    addpath("../genetic_algorithm/");
    load(strcat('fmss_', num2str(i)));
    fmss_ga(:, i) = fmss;
    
    addpath("../PSO/");
    load(strcat('fmss_', num2str(i)));
    fmss_pso(:, i) = fmss;
    
    addpath("../HybridGWO/");
    load(strcat('fmss_', num2str(i)));
    fmss_gwo(:, i) = fmss;
end

% Suponha que você tenha os vetores fmss_gm, fmss_ga e fmss_pso definidos
iteracoes = 1:length(fmss_gm);

% Plote os dados
figure;
hold on;
plot(iteracoes, fmss_gm, 'ro', 'LineWidth', 2, 'MarkerFaceColor', 'red');
plot(iteracoes, fmss_ga, 'go', 'LineWidth', 2, 'MarkerFaceColor', 'green');
plot(iteracoes, fmss_pso, 'ko', 'LineWidth', 2, 'MarkerFaceColor', 'yellow');
plot(iteracoes, fmss_gwo, 'ko', 'LineWidth', 2, 'MarkerFaceColor', 'blue');

% Add labels to the axes
xlabel('Event');
ylabel('Objective Function Cost');

% Add a legend
legend('Gauss-Newton with Multi-Start', 'Genetic Algorithm', 'Particle Swarm Optimization', 'Hybrid Grey Wolf Optimizer', 'Location', 'Best');

% Set the title of the plot
title('Comparison of Average Objective Function Cost');

% Mantenha a grade de fundo para facilitar a leitura
grid on;

% Mostrar o gráfico
hold off;

% Crie um vetor de grupos
grupos = [ones(length(fmss_gm), 1);  % Grupo 1: fmss_gm
          2 * ones(length(fmss_ga), 1);  % Grupo 2: fmss_ga
          3 * ones(length(fmss_pso), 1); % Grupo 3: fmss_pso
          4 * ones(length(fmss_gwo), 1)]; % Grupo 4: fmss_gwo

% Concatene os dados dos diferentes grupos
dados = [fmss_gm, fmss_ga, fmss_pso, fmss_gwo];

% Realize o teste de Kruskal-Wallis
p = kruskalwallis(dados, grupos, 'off');  % 'off' para desativar a exibição do gráfico

% Exiba os resultados
fprintf('Teste de Kruskal-Wallis para o custo das soluções médias:\n');
fprintf('H0: Não há diferença entre os custos das soluções médias obtidas pelo Gauss-Newton com Multi-Start, Algoritmo Genético, Nuvem de Partículas e Otimização por Lobos Cinzentos Hibridizado.\n');
fprintf('H1: Há diferença entre os custos das soluções médias obtidas pelo Gauss-Newton com Multi-Start, Algoritmo Genético e Nuvem de Partículas e Otimização por Lobos Cinzentos Hibridizado.\n');
fprintf('Valor-p: %.4f\n', p);

% Avalie a hipótese nula
alpha = 0.05;  % Nível de significância

if p < alpha
    fprintf('Rejeitamos H0. Há diferença entre os custos das soluções médias obtidas pelo Gauss-Newton com Multi-Start, Algoritmo Genético, Nuvem de Partículas e Otimização por Lobos Cinzentos Hibridizado.\n');

    norm_diff_ga = norm(mss_ga - ss);
    norm_diff_gm = norm(mss_gm - ss);
    norm_diff_pso = norm(mss_pso - ss);
    norm_diff_gwo = norm(mss_gwo - ss);

    if norm_diff_ga < norm_diff_gm && norm_diff_ga < norm_diff_pso && norm_diff_ga < norm_diff_gwo
        fprintf('O Algoritmo Genético teve sua solução média mais próxima da solução verdadeira.\n');
    elseif norm_diff_gm < norm_diff_pso && norm_diff_gm < norm_diff_gwo
        fprintf('O Gauss-Newton com Multi-Start teve sua solução média mais próxima da solução verdadeira.\n');
    elseif norm_diff_pso < norm_diff_gwo
        fprintf('A Nuvem de Partículas teve sua solução média mais próxima da solução verdadeira.\n');
    else
        fprintf('Otimização por Lobos Cinzentos Hibridizado teve sua solução média mais próxima da solução verdadeira.\n');
    end
else
    fprintf('Não rejeitamos H0. Não há diferença entre os custos das soluções médias obtidas pelo Gauss-Newton com Multi-Start, Algoritmo Genético, Nuvem de Partículas e Otimização por Lobos Cinzentos Hibridizado.\n');
end



