clc
clear all
close all;

% Resultados do Gauss-Newton com Multi-Start, GA, PSO e GWO
v_fm_gm = zeros(1, 4);
v_fm_ga = zeros(1, 4);
v_fm_pso = zeros(1, 4);
v_fm_gwo = zeros(1, 4);

for j = 1:4
    % Carregue os arquivos .mat
    addpath("../gauss_newton_multi_start/");
    load(strcat('fss_', num2str(j)));
    fss = sum(fss) / 10;

    fm_gm = max(fss);
    epoch_gm = 0;

    epsilon = 10^-2;

    epoch = 4;

    for i = 2:11
        limiar = norm((fss(i) - fss(i - 1)) / fss(i));

        if limiar <= epsilon && epoch_gm == 0
            epoch_gm = epoch_gm + 1;
            fm_gm = fss(i);
        elseif limiar <= epsilon && epoch_gm ~= 0
            fm_gm = fm_gm + fss(i);
            epoch_gm = epoch_gm + 1;
        elseif limiar <= epsilon && epoch_gm <= epoch
            fm_gm = fm_gm / 4;
            break;
        elseif limiar > epsilon
            epoch_gm = 0;
            fm_gm = max(fss);
        end
    end

    v_fm_gm(j) = fm_gm;

    addpath("../genetic_algorithm/");
    load(strcat('fss_', num2str(j)));
    fss = sum(fss) / 10;

    fm_ga = max(fss);
    epoch_ga = 0;

    for i = 2:10
        limiar = norm((fss(i) - fss(i - 1)) / fss(i));

        if limiar <= epsilon && epoch_ga == 0
            epoch_ga = epoch_ga + 1;
            fm_ga = fss(i);
        elseif limiar <= epsilon && epoch_ga ~= 0
            fm_ga = fm_ga + fss(i);
            epoch_ga = epoch_ga + 1;
        elseif limiar <= epsilon && epoch_ga <= epoch
            fm_ga = fm_ga / 3;
            break;
        elseif limiar > epsilon
            fm_ga = max(fss);
            epoch_ga = 0;
        end
    end

    v_fm_ga(j) = fm_ga;

    addpath("../PSO/");
    load(strcat('fss_', num2str(j)));
    fss = sum(fss) / 10;

    fm_pso = max(fss);
    epoch_pso = 0;

    for i = 2:10
        limiar = norm((fss(i) - fss(i - 1)) / fss(i));

        if limiar <= epsilon && epoch_pso == 0
            epoch_pso = epoch_pso + 1;
            fm_pso = fss(i);
        elseif limiar <= epsilon && epoch_pso ~= 0
            fm_pso = fm_pso + fss(i);
            epoch_pso = epoch_pso + 1;
        elseif limiar <= epsilon && epoch_pso <= epoch
            fm_pso = fm_pso / 3;
            break;
        elseif limiar > epsilon
            fm_pso = max(fss);
            epoch_pso = 0;
        end
    end

    v_fm_pso(j) = fm_pso;
    
    addpath("../HybridGWO/");
    load(strcat('fss_', num2str(j)));
    fss = sum(fss) / 10;

    fm_gwo = max(fss);
    epoch_gwo = 0;

    for i = 2:10
        limiar = norm((fss(i) - fss(i - 1)) / fss(i));

        if limiar <= epsilon && epoch_gwo == 0
            epoch_gwo = epoch_gwo + 1;
            fm_gwo = fss(i);
        elseif limiar <= epsilon && epoch_gwo ~= 0
            fm_gwo = fm_gwo + fss(i);
            epoch_gwo = epoch_gwo + 1;
        elseif limiar <= epsilon && epoch_gwo <= epoch
            fm_gwo = fm_gwo / 3;
            break;
        elseif limiar > epsilon
            fm_gwo = max(fss);
            epoch_gwo = 0;
        end
    end

    v_fm_gwo(j) = fm_gwo;

end

% Crie um vetor de grupos
grupos = [ones(length(v_fm_gm), 1);  % Grupo 1: v_fm_gm
          2 * ones(length(v_fm_ga), 1);  % Grupo 2: v_fm_ga
          3 * ones(length(v_fm_pso), 1); % Grupo 3: v_fm_pso
          4 * ones(length(v_fm_gwo), 1)]; % Grupo 4: v_fm_gwo 

% Concatene os dados dos diferentes grupos
dados = [v_fm_gm, v_fm_ga, v_fm_pso, v_fm_gwo];

% Realize o teste de Kruskal-Wallis
p = kruskalwallis(dados, grupos, 'off');  % 'off' para desativar a exibição do gráfico

% Exiba os resultados
fprintf('Teste de Kruskal-Wallis para o custo estável da função objetivo:\n');
fprintf('H0: Não há diferença entre os custos médios nos eventos em que estabilizaram o Gauss-Newton com Multi-Start, Algoritmo Genético, Nuvem de Partículas e Otimização por Lobos Cinzentos Hibridizado.\n');
fprintf('H1: Há diferença entre os custos médios nos eventos em que estabilizaram o Gauss-Newton com Multi-Start, Algoritmo Genético, Nuvem de Partículas e Otimização por Lobos Cinzentos Hibridizado.\n');
fprintf('Valor-p: %.4f\n', p);

% Avalie a hipótese nula
alpha = 0.05;  % Nível de significância

if p < alpha
    fprintf('Rejeitamos H0. Há diferença entre os custos médios nos eventos em que estabilizaram o Gauss-Newton com Multi-Start, Algoritmo Genético, Nuvem de Partículas e Otimização por Lobos Cinzentos Hibridizado.\n');

    sum_v_fm_ga = sum(v_fm_ga);
    sum_v_fm_gm = sum(v_fm_gm);
    sum_v_fm_pso = sum(v_fm_pso);
    sum_v_fm_gwo = sum(v_fm_gwo);

    if sum_v_fm_ga < sum_v_fm_gm && sum_v_fm_ga < sum_v_fm_pso && sum_v_fm_ga < sum_v_fm_gwo
        fprintf('O Algoritmo Genético estabilizou com menor custo para o mínimo da função.\n');
    elseif sum_v_fm_gm < sum_v_fm_pso && sum_v_fm_gm < sum_v_fm_gwo
        fprintf('O Gauss-Newton com Multi-Start estabilizou com menor custo para o mínimo da função.\n');
    elseif sum_v_fm_pso < sum_v_fm_gwo
        fprintf('A Nuvem de Partículas estabilizou com menor custo para o mínimo da função.\n');
    else
        fprintf('Otimização por Lobos Cinzentos Hibridizado estabilizou com menor custo para o mínimo da função.\n');
    end
else
    fprintf('Não rejeitamos H0. Não há diferença entre os custos médios nos eventos em que estabilizaram o Gauss-Newton com Multi-Start, Algoritmo Genético, Nuvem de Partículas e Otimização por Lobos Cinzentos Hibridizado.\n');
end


% Plote os dados
iteracoes = 1:length(v_fm_gm);
figure;
hold on;
plot(iteracoes, v_fm_gm, 'ro', 'LineWidth', 2, 'MarkerFaceColor', 'red');
plot(iteracoes, v_fm_ga, 'go', 'LineWidth', 2, 'MarkerFaceColor', 'green');
plot(iteracoes, v_fm_pso, 'ko', 'LineWidth', 2, 'MarkerFaceColor', 'yellow');
plot(iteracoes, v_fm_gwo, 'bo', 'LineWidth', 2, 'MarkerFaceColor', 'blue');

% Add labels to the axes
xlabel('Event');
ylabel('Objective Function Cost');

% Add a legend
legend('Gauss-Newton with Multi-Start', 'Genetic Algorithm', 'Particle Swarm Optimization', 'Hybrid Grey Wolf Optimizer', 'Location', 'Best');

% Set the graph title
title('Comparison of Stable Objective Function Cost');

% Mantenha a grade de fundo para facilitar a leitura
grid on;

% Mostrar o gráfico
hold off;



