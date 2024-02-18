clc
clear all
close all;

% Resultados do Gauss-Newton com Multi-Start e GA
v_it_gm = zeros(1, 4);
v_it_ga = zeros(1, 4);
v_it_pso = zeros(1, 4);
v_it_gwo = zeros(1, 4);

for j = 1:4
    % Carregue os arquivos .mat
    addpath("../gauss_newton_multi_start/");
    load(strcat('fss_', num2str(j)));
    fss = sum(fss)/10;

    it_gm = size(fss, 2);
    epoch_gm = 0;

    epsilon = 10^-2;

    epoch = 4;

    for i = 2:11
        limiar = norm((fss(i) - fss(i-1))/fss(i));

        if limiar <= epsilon && epoch_gm == 0
            it_gm = i;
            epoch_gm = epoch_gm + 1;
        elseif limiar <= epsilon && epoch_gm ~= 0
            epoch_gm = epoch_gm + 1;
        elseif limiar <= epsilon && epoch_gm <= epoch
            break;
        elseif limiar > epsilon
            it_gm = size(fss, 2);
            epoch_gm = 0;
        end
    end

    v_it_gm(j) = it_gm;

    addpath("../genetic_algorithm/");
    load(strcat('fss_', num2str(j)));
    fss = sum(fss)/10;

    it_ga = size(fss, 2);
    epoch_ga = 0;

    for i = 2:10
        limiar = norm((fss(i) - fss(i-1))/fss(i));

        if limiar <= epsilon && epoch_ga == 0
            it_ga = i;
            epoch_ga = epoch_ga + 1;
        elseif limiar <= epsilon && epoch_ga ~= 0
            epoch_ga = epoch_ga + 1;
        elseif limiar <= epsilon && epoch_ga <= epoch
            break;
        elseif limiar > epsilon
            it_ga = size(fss, 2);
            epoch_ga = 0;
        end
    end

    v_it_ga(j) = it_ga;

    addpath("../PSO/");
    load(strcat('fss_', num2str(j)));
    fss = sum(fss)/10;

    it_pso = size(fss, 2);
    epoch_pso = 0;

    for i = 2:10
        limiar = norm((fss(i) - fss(i-1))/fss(i));

        if limiar <= epsilon && epoch_pso == 0
            it_pso = i;
            epoch_pso = epoch_pso + 1;
        elseif limiar <= epsilon && epoch_pso ~= 0
            epoch_pso = epoch_pso + 1;
        elseif limiar <= epsilon && epoch_pso <= epoch
            break;
        elseif limiar > epsilon
            it_pso = size(fss, 2);
            epoch_pso = 0;
        end
    end

    v_it_pso(j) = it_pso;

    addpath("../HybridGWO/");
    load(strcat('fss_', num2str(j)));
    fss = sum(fss)/10;

    it_gwo = size(fss, 2);
    epoch_gwo = 0;

    for i = 2:10
        limiar = norm((fss(i) - fss(i-1))/fss(i));

        if limiar <= epsilon && epoch_gwo == 0
            it_gwo = i;
            epoch_gwo = epoch_gwo + 1;
        elseif limiar <= epsilon && epoch_gwo ~= 0
            epoch_gwo = epoch_gwo + 1;
        elseif limiar <= epsilon && epoch_gwo <= epoch
            break;
        elseif limiar > epsilon
            it_gwo = size(fss, 2);
            epoch_gwo = 0;
        end
    end

    v_it_gwo(j) = it_gwo;
end

% Crie um vetor de grupos
grupos = [ones(length(v_it_gm), 1);  % Grupo 1: v_it_gm
          2 * ones(length(v_it_ga), 1);  % Grupo 2: v_it_ga
          3 * ones(length(v_it_pso), 1); % Grupo 3: v_it_pso
          4 * ones(length(v_it_gwo), 1)]; % Grupo 4: v_it_gwo 

% Concatene os dados dos diferentes grupos
dados = [v_it_gm, v_it_ga, v_it_pso, v_it_gwo];

% Realize o teste de Kruskal-Wallis
p = kruskalwallis(dados, grupos, 'off');  % 'off' para desativar a exibição do gráfico

% Exiba os resultados
fprintf('Teste de Kruskal-Wallis para a estabilidade das soluções:\n');
fprintf('H0: Não há diferença entre as iterações em que estabilizaram o Gauss-Newton com Multi-Start, Algoritmo Genético, Nuvem de Partículas e Otimização por Lobos Cinzentos Hibridizado.\n');
fprintf('H1: Há diferença entre as iterações em que estabilizaram o Gauss-Newton com Multi-Start, Algoritmo Genético, Nuvem de Partículas e Otimização por Lobos Cinzentos Hibridizado.\n');
fprintf('Valor-p: %.4f\n', p);

% Avalie a hipótese nula
alpha = 0.05;  % Nível de significância

if p < alpha
    fprintf('Rejeitamos H0. Há diferença entre as iterações em que estabilizaram o Gauss-Newton com Multi-Start, Algoritmo Genético, Nuvem de Partículas e Otimização por Lobos Cinzentos Hibridizado.\n');
    
    sum_it_ga = sum(v_it_ga);
    sum_it_gm = sum(v_it_gm);
    sum_it_pso = sum(v_it_pso);
    sum_it_gwo = sum(v_it_gwo);

    if sum_it_ga < sum_it_gm && sum_it_ga < sum_it_pso && sum_it_ga < sum_it_gwo
        fprintf('O Algoritmo Genético estabilizou mais rapidamente para o mínimo da função.\n');
    elseif sum_it_gm < sum_it_pso && sum_it_gm < sum_it_gwo
        fprintf('O Gauss-Newton com Multi-Start estabilizou mais rapidamente para o mínimo da função.\n');
    elseif sum_it_pso < sum_it_gwo
        fprintf('A Nuvem de Partículas estabilizou mais rapidamente para o mínimo da função.\n');
    else
        fprintf('Otimização por Lobos Cinzentos Hibridizado estabilizou mais rapidamente para o mínimo da função.\n');
    end
else
    fprintf('Não rejeitamos H0. Não há diferença entre as iterações em que estabilizaram o Gauss-Newton com Multi-Start, Algoritmo Genético, Nuvem de Partículas e Otimização por Lobos Cinzentos Hibridizado.\n');
end


% Plote os dados
iteracoes = 1:length(v_it_gm);
figure;
hold on;
plot(iteracoes, v_it_gm, 'ro', 'LineWidth', 2, 'MarkerFaceColor', 'red');
plot(iteracoes, v_it_ga, 'go', 'LineWidth', 2, 'MarkerFaceColor', 'green');
plot(iteracoes, v_it_pso, 'ko', 'LineWidth', 2, 'MarkerFaceColor', 'yellow');
plot(iteracoes, v_it_gwo, 'bo', 'LineWidth', 2, 'MarkerFaceColor', 'blue');

% Add labels to the axes
xlabel('Event');
ylabel('Iteration');

% Add a legend
legend('Gauss-Newton with Multi-Start', 'Genetic Algorithm', 'Particle Swarm Optimizer', 'Hybrid Grey Wolf Optimizer', 'Location', 'Best');

% Set the graph title
title('Comparison of the Iteration at Which Each Algorithm Stabilized');

% Mantenha a grade de fundo para facilitar a leitura
grid on;

% Mostrar o gráfico
hold off;


