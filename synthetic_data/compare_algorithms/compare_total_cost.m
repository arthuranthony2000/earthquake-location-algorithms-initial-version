clc
clear all
close all;

% Vetor das somas dos custos das soluções do Gauss-Newton com Multi-Start
fss_gm = zeros(1, 4);

% Vetor das somas dos custos das soluções do Algoritmo Genético
fss_ga = zeros(1, 4);

% Vetor das somas dos custos das soluções da Nuvem de Partículas
fss_pso = zeros(1, 4);

% Vetor das somas dos custos das soluções de Otimização por Lobos Cinzentos Hibridizado
fss_gwo = zeros(1, 4);

for i = 1:4
    % Carregue os arquivos .mat
    addpath("../gauss_newton_multi_start/");
    load(strcat('fss_', num2str(i)));
    fss_gm(i) = sum(sum(fss)/10);
    
    addpath("../genetic_algorithm/");
    load(strcat('fss_', num2str(i)));
    fss_ga(i) = sum(sum(fss)/10);
    
    addpath("../PSO/");
    load(strcat('fss_', num2str(i)));
    fss_pso(i) = sum(sum(fss)/10);
    
    addpath("../HybridGWO/");
    load(strcat('fss_', num2str(i)));
    fss_gwo(i) = sum(sum(fss)/10);
end

% Crie um vetor de grupos
grupos = [ones(length(fss_gm), 1);  % Grupo 1: fss_gm
          2 * ones(length(fss_ga), 1);  % Grupo 2: fss_ga
          3 * ones(length(fss_pso), 1); % Grupo 3: fss_pso
          4 * ones(length(fss_gwo), 1)];  % Grupo 4: fss_gwo

% Concatene os dados dos diferentes grupos
dados = [fss_gm, fss_ga, fss_pso, fss_gwo];

% Realize o teste de Kruskal-Wallis
p = kruskalwallis(dados, grupos, 'off');  % 'off' para desativar a exibição do gráfico

% Exiba os resultados
fprintf('Teste de Kruskal-Wallis para o decrescimento das soluções:\n');
fprintf('H0: Não há diferença entre a soma dos custos das soluções obtidas pelo Gauss-Newton com Multi-Start, Algoritmo Genético, Nuvem de Partículas e Otimização por Lobos Cinzentos Hibridizado.\n');
fprintf('H1: Há diferença entre a soma dos custos das soluções obtidas pelo Gauss-Newton com Multi-Start, Algoritmo Genético, Nuvem de Partículas e Otimização por Lobos Cinzentos Hibridizado.\n');
fprintf('Valor-p: %.4f\n', p);

% Avalie a hipótese nula
alpha = 0.05;  % Nível de significância

if p < alpha
    fprintf('Rejeitamos H0. Há diferença entre as somas dos custos das soluções obtidas pelo Gauss-Newton com Multi-Start, Algoritmo Genético, Nuvem de Partículas e Otimização por Lobos Cinzentos Hibridizado.\n');

    sum_fss_ga = sum(fss_ga);
    sum_fss_gm = sum(fss_gm);
    sum_fss_pso = sum(fss_pso);
    sum_fss_gwo = sum(fss_gwo);

    if sum_fss_ga < sum_fss_gm && sum_fss_ga < sum_fss_pso && sum_fss_ga < sum_fss_gwo
        fprintf('O Algoritmo Genético obteve o menor custo total.\n');
    elseif sum_fss_gm < sum_fss_pso && sum_fss_gm < sum_fss_gwo
        fprintf('O Gauss-Newton com Multi-Start obteve o menor custo total.\n');
    elseif sum_fss_pso < sum_fss_gwo
        fprintf('A Nuvem de Partículas obteve o menor custo total.\n');
    else
        fprintf('Otimização por Lobos Cinzentos Hibridizado obteve o menor custo total.\n');
    end
else
    fprintf('Não rejeitamos H0. Não há diferença entre as somas dos custos das soluções obtidas pelo Gauss-Newton com Multi-Start, Algoritmo Genético, Nuvem de Partículas e Otimização por Lobos Cinzentos Hibridizado.\n');
end


% Plote os dados
iteracoes = 1:length(fss_gm);

figure;
hold on;
plot(iteracoes, fss_gm, 'ro', 'LineWidth', 2, 'MarkerFaceColor', 'red');
plot(iteracoes, fss_ga, 'go', 'LineWidth', 2, 'MarkerFaceColor', 'green');
plot(iteracoes, fss_pso, 'ko', 'LineWidth', 2, 'MarkerFaceColor', 'yellow');
plot(iteracoes, fss_gwo, 'bo', 'LineWidth', 2, 'MarkerFaceColor', 'blue');

xlabel('Event');
ylabel('Sum of Costs');

legend('Gauss-Newton with Multi-Start', 'Genetic Algorithm', 'Particle Swarm Optimization', 'Hybrid Grey Wolf Optimizer', 'Location', 'Best');

title('Comparison of Total Objective Function Cost');

grid on;
hold off;


