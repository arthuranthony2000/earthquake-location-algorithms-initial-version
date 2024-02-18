clc
clear all
close all;

% Resultados do Gauss-Newton com Multi-Start, GA e PSO
v_fm_gm = zeros(1, 4);
v_fm_ga = zeros(1, 4);
v_fm_pso = zeros(1, 4);

for j = 1:4
    % Carregue os arquivos .mat
    addpath("../../gauss_newton_multi_start/");
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

    addpath("../../genetic_algorithm/");
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

    addpath("../../PSO/");
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

end

% Crie um vetor de grupos
grupos = [ones(length(v_fm_gm), 1);  % Grupo 1: v_fm_gm
          2 * ones(length(v_fm_ga), 1);  % Grupo 2: v_fm_ga
          3 * ones(length(v_fm_pso), 1)];  % Grupo 3: v_fm_pso

% Concatene os dados dos diferentes grupos
dados = [v_fm_gm, v_fm_ga, v_fm_pso];

% Realize o teste de Kruskal-Wallis
p = kruskalwallis(dados, grupos, 'off');  % 'off' para desativar a exibição do gráfico

% Exiba os resultados
fprintf('Teste de Kruskal-Wallis para o custo estável da função objetivo:\n');
fprintf('H0: Não há diferença entre os custos médios nos eventos em que estabilizaram o Gauss-Newton com Multi-Start, Algoritmo Genético e Nuvem de Partículas.\n');
fprintf('H1: Há diferença entre os custos médios nos eventos em que estabilizaram o Gauss-Newton com Multi-Start, Algoritmo Genético e Nuvem de Partículas.\n');
fprintf('Valor-p: %.4f\n', p);

% Avalie a hipótese nula
alpha = 0.05;  % Nível de significância

if p < alpha
    fprintf('Rejeitamos H0. Há diferença entre os custos médios nos eventos em que estabilizaram o Gauss-Newton com Multi-Start, Algoritmo Genético e Nuvem de Partículas.\n');
    if sum(v_fm_ga) < sum(v_fm_gm)
        if sum(v_fm_ga) < sum(v_fm_pso)
            fprintf('O Algoritmo Genético estabilizou com menor custo para o mínimo da função.\n');
        else
            fprintf('A Nuvem de Partículas estabilizou com menor custo para o mínimo da função.\n');
        end
    else
        if sum(v_fm_gm) < sum(v_fm_pso)
            fprintf('O Gauss-Newton com Multi-Start estabilizou com menor custo para o mínimo da função.\n');
        else
            fprintf('A Nuvem de Partículas estabilizou com menor custo para o mínimo da função.\n');
        end
    end
else
    fprintf('Não rejeitamos H0. Não há diferença entre os custos médios nos eventos em que estabilizaram o Gauss-Newton com Multi-Start, Algoritmo Genético e Nuvem de Partículas.\n');
end

% Plote os dados
iteracoes = 1:length(v_fm_gm);
figure;
hold on;
plot(iteracoes, v_fm_gm, 'ro', 'LineWidth', 2, 'MarkerFaceColor', 'red');
plot(iteracoes, v_fm_ga, 'go', 'LineWidth', 2, 'MarkerFaceColor', 'green');
plot(iteracoes, v_fm_pso, 'ko', 'LineWidth', 2, 'MarkerFaceColor', 'yellow');

% Adicione rótulos aos eixos
xlabel('Evento');
ylabel('Custo da Função Objetivo');

% Adicione uma legenda
legend('Custo Estável Gauss-Newton com Multi-Start', 'Custo Estável Algoritmo Genético', 'Custo Estável Nuvem de Partículas');

% Defina o título do gráfico
title('Comparação do Custo Estável da Função Objetivo');

% Mantenha a grade de fundo para facilitar a leitura
grid on;

% Mostrar o gráfico
hold off;



