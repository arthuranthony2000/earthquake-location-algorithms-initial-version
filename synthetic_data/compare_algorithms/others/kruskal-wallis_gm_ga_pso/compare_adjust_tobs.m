clc
clear all
close all

addpath("../../gauss_newton_multi_start/");
load('cx_1');
load('cy_1');
load('cz_1');
load('v_1');

% Resultados do Gauss-Newton com Multi-Start, Algoritmo Genético e PSO

ns = length(cx);

% Vetor com os dados observados
tobs_ss = zeros(4, 5);

% Vetor da média das soluções do Gauss-Newton com Multi-Start
mss_gm = zeros(1, 12);

% Vetor com os dados calculados do Gauss-Newton com Multi-Start
tobs_gm = zeros(4, 5);

% Vetor da média das soluções do Algoritmo Genético
mss_ga = zeros(1, 12);

% Vetor com os dados calculados do Algoritmo Genético
tobs_ga = zeros(4, 5);

% Vetor da média das soluções da Nuvem de Partículas
mss_pso = zeros(1, 12);

% Vetor com os dados calculados da Nuvem de Partículas
tobs_pso = zeros(4, 5);

col_idx = 1; % Índice da próxima coluna em mss_ga e mss_gm

for i = 1:4
    % Carregue os arquivos .mat
    addpath("../../gauss_newton_multi_start/");
    load(strcat('mss_', num2str(i)));   
    mss_gm(:, col_idx:col_idx+2) = mss;
    tobs_gm(i, :) = hypo_direct(mss, cx, cy, cz, ns, v);
    
    load(strcat('tobs_', num2str(i)));  
    tobs_ss(i, :) = tobs;

    addpath("../../genetic_algorithm/");
    load(strcat('mss_', num2str(i)));
    mss_ga(:, col_idx:col_idx+2) = mss;
    tobs_ga(i, :) = hypo_direct(mss, cx, cy, cz, ns, v);
    
    addpath("../../PSO/");
    load(strcat('mss_', num2str(i)));
    mss_pso(:, col_idx:col_idx+2) = mss;
    tobs_pso(i, :) = hypo_direct(mss, cx, cy, cz, ns, v);
    
    col_idx = col_idx + 3;
end

tobs_ss = reshape(tobs_ss, [], 1);
tobs_gm = reshape(tobs_gm, [], 1);
tobs_ga = reshape(tobs_ga, [], 1);
tobs_pso = reshape(tobs_pso, [], 1);

% Transforme os vetores em colunas
tobs_ss = reshape(tobs_ss, [], 1);
tobs_gm = reshape(tobs_gm, [], 1);
tobs_ga = reshape(tobs_ga, [], 1);
tobs_pso = reshape(tobs_pso, [], 1);

% Crie um vetor de tempo (ou índice) para o eixo X, assumindo que tenha o mesmo comprimento que os dados
tempo = 1:length(tobs_ss);

% Plote os dados
figure;
hold on;
plot(tempo, tobs_ss, 'k', 'LineWidth', 2);
plot(tempo, tobs_gm, 'r', 'LineWidth', 2);
plot(tempo, tobs_ga, 'g', 'LineWidth', 2);
plot(tempo, tobs_pso, 'y', 'LineWidth', 2);

% Adicione rótulos aos eixos
xlabel('Tempo');
ylabel('Dado');

% Adicione uma legenda
legend('Dado Real', 'Gauss-Newton com Multi-Start', 'Algoritmo Genético', 'Nuvem de Partículas');

% Defina o título do gráfico
title('Comparação dos Dados Calculados');

% Mantenha a grade de fundo para facilitar a leitura
grid on;

% Mostrar o gráfico
hold off;

% Crie um vetor de grupos
grupos = [ones(length(tobs_gm), 1);  % Grupo 1: tobs_gm
          2 * ones(length(tobs_ga), 1);  % Grupo 2: tobs_ga
          3 * ones(length(tobs_pso), 1)];  % Grupo 3: tobs_pso

% Concatene os dados dos diferentes grupos
dados = [tobs_gm; tobs_ga; tobs_pso];

% Realize o teste de Kruskal-Wallis
p = kruskalwallis(dados, grupos, 'off');  % 'off' para desativar a exibição do gráfico

% Exiba os resultados
fprintf('Teste de Kruskal-Wallis para os dados calculados das soluções médias:\n');
fprintf('H0: Não há diferença entre os dados calculados das soluções médias obtidas pelo Gauss-Newton com Multi-Start, Algoritmo Genético e Nuvem de Partículas.\n');
fprintf('H1: Há diferença entre os dados calculados das soluções médias obtidas pelo Gauss-Newton com Multi-Start, Algoritmo Genético e Nuvem de Partículas.\n');
fprintf('Valor-p: %.4f\n', p);

% Avalie a hipótese nula
alpha = 0.05;  % Nível de significância

if p < alpha
    fprintf('Rejeitamos H0. Há diferença entre os dados calculados das soluções médias obtidas pelo Gauss-Newton com Multi-Start, Algoritmo Genético e Nuvem de Partículas.\n');
    if 1/length(tobs_ss) * norm(tobs_ga - tobs_ss) < 1/length(tobs) * norm(tobs_gm - tobs_ss)      
        if 1/length(tobs_ss) * norm(tobs_ga - tobs_ss) < 1/length(tobs) * norm(tobs_pso - tobs_ss)
            fprintf('O Algoritmo Genético obteve o melhor ajuste dos dados.\n');
        else
            fprintf('A Nuvem de Partículas com Multi-Start obteve o melhor ajuste dos dados\n.');
        end
    else
        if 1/length(tobs_ss) * norm(tobs_gm - tobs_ss) < 1/length(tobs) * norm(tobs_pso - tobs_ss)
            fprintf('O Gauss-Newton com Multi-Start obteve o melhor ajuste dos dados\n.');
        else
            fprintf('A Nuvem de Partículas com Multi-Start obteve o melhor ajuste dos dados\n.');
        end
    end
else
    fprintf('Não rejeitamos H0. Não há diferença entre os dados calculados das soluções médias obtidas pelo Gauss-Newton com Multi-Start, Algoritmo Genético e Nuvem de Partículas.\n');
end



