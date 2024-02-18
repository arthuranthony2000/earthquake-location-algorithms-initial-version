clc
clear all
close all;

% Resultados do Gauss-Newton com Multi-Start e GA
v_it_gm = zeros(1, 4);
v_it_ga = zeros(1, 4);
v_it_pso = zeros(1, 4);

for j = 1:4
    % Carregue os arquivos .mat
    addpath("../../gauss_newton_multi_start/");
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

    addpath("../../genetic_algorithm/");
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

    addpath("../../PSO/");
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

end

% Crie um vetor de grupos
grupos = [ones(length(v_it_gm), 1);  % Grupo 1: v_it_gm
          2 * ones(length(v_it_ga), 1);  % Grupo 2: v_it_ga
          3 * ones(length(v_it_pso), 1)];  % Grupo 3: v_it_pso

% Concatene os dados dos diferentes grupos
dados = [v_it_gm, v_it_ga, v_it_pso];

% Realize o teste de Kruskal-Wallis
p = kruskalwallis(dados, grupos, 'off');  % 'off' para desativar a exibição do gráfico

% Exiba os resultados
fprintf('Teste de Kruskal-Wallis para a estabilidade das soluções:\n');
fprintf('H0: Não há diferença entre as iterações em que estabilizaram o Gauss-Newton com Multi-Start, Algoritmo Genético e Nuvem de Partículas.\n');
fprintf('H1: Há diferença entre as iterações em que estabilizaram o Gauss-Newton com Multi-Start, Algoritmo Genético e Nuvem de Partículas.\n');
fprintf('Valor-p: %.4f\n', p);

% Avalie a hipótese nula
alpha = 0.05;  % Nível de significância

if p < alpha
    fprintf('Rejeitamos H0. Há diferença entre as iterações em que estabilizaram o Gauss-Newton com Multi-Start, Algoritmo Genético e Nuvem de Partículas.\n');
    if sum(v_it_ga) < sum(v_it_gm)        
        if sum(v_it_ga) < sum(v_it_pso)
            fprintf('O Algoritmo Genético estabilizou mais rapidamente para o mínimo da função.\n');
        else
            fprintf('A Nuvem de Partículas estabilizou mais rapidamente para o mínimo da função.\n');
        end
    else
        if sum(v_it_gm) < sum(v_it_pso)
            fprintf('O Gauss-Newton com Multi-Start estabilizou mais rapidamente para o mínimo da função.\n');
        else
            fprintf('A Nuvem de Partículas estabilizou mais rapidamente para o mínimo da função.\n');
        end
    end
else
    fprintf('Não rejeitamos H0. Não há diferença entre as iterações em que estabilizaram o Gauss-Newton com Multi-Start, Algoritmo Genético e Nuvem de Partículas.\n');
end

% Plote os dados
iteracoes = 1:length(v_it_gm);
figure;
hold on;
plot(iteracoes, v_it_gm, 'ro', 'LineWidth', 2, 'MarkerFaceColor', 'red');
plot(iteracoes, v_it_ga, 'go', 'LineWidth', 2, 'MarkerFaceColor', 'green');
plot(iteracoes, v_it_pso, 'ko', 'LineWidth', 2, 'MarkerFaceColor', 'yellow');

% Adicione rótulos aos eixos
xlabel('Evento');
ylabel('Iteração Estável da Função Objetivo');

% Adicione uma legenda
legend('Iteração Estável Gauss-Newton com Multi-Start', 'Iteração Estável Algoritmo Genético', 'Iteração Estável Nuvem de Partículas');

% Defina o título do gráfico
title('Comparação da iteração em que cada algoritmo estabilizou');

% Mantenha a grade de fundo para facilitar a leitura
grid on;

% Mostrar o gráfico
hold off;


