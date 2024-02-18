clc
clear all
close all;

% Vetor das somas dos custos das soluções do Gauss-Newton com Multi-Start
fss_gm = zeros(1, 4);

% Vetor das somas dos custos das soluções do Algoritmo Genético
fss_ga = zeros(1, 4);

% Vetor das somas dos custos das soluções da Nuvem de Partículas
fss_pso = zeros(1, 4);

for i = 1:4
    % Carregue os arquivos .mat
    addpath("../../gauss_newton_multi_start/");
    load(strcat('fss_', num2str(i)));
    fss_gm(i) = sum(sum(fss)/10);
    
    addpath("../../genetic_algorithm/");
    load(strcat('fss_', num2str(i)));
    fss_ga(i) = sum(sum(fss)/10);
    
    addpath("../../PSO/");
    load(strcat('fss_', num2str(i)));
    fss_pso(i) = sum(sum(fss)/10);
end

% Crie um vetor de grupos
grupos = [ones(length(fss_gm), 1);  % Grupo 1: fss_gm
          2 * ones(length(fss_ga), 1);  % Grupo 2: fss_ga
          3 * ones(length(fss_pso), 1)];  % Grupo 3: fss_pso

% Concatene os dados dos diferentes grupos
dados = [fss_gm, fss_ga, fss_pso];

% Realize o teste de Kruskal-Wallis
p = kruskalwallis(dados, grupos, 'off');  % 'off' para desativar a exibição do gráfico

% Exiba os resultados
fprintf('Teste de Kruskal-Wallis para o decrescimento das soluções:\n');
fprintf('H0: Não há diferença entre a soma dos custos das soluções obtidas pelo Gauss-Newton com Multi-Start, Algoritmo Genético e Nuvem de Partículas.\n');
fprintf('H1: Há diferença entre a soma dos custos das soluções obtidas pelo Gauss-Newton com Multi-Start, Algoritmo Genético e Nuvem de Partículas.\n');
fprintf('Valor-p: %.4f\n', p);

% Avalie a hipótese nula
alpha = 0.05;  % Nível de significância

if p < alpha
    fprintf('Rejeitamos H0. Há diferença entre as somas dos custos das soluções obtidas pelo Gauss-Newton com Multi-Start, Algoritmo Genético e Nuvem de Partículas.\n');
    if sum(fss_ga) < sum(fss_gm)       
        if sum(fss_ga) < sum(fss_pso)
            fprintf('O Algoritmo Genético descresceu o desajuste mais rapidamente para o mínimo da função.\n');
        else
            fprintf('A Nuvem de Partículas decresceu o desajuste mais rapidamente para o mínimo da função\n.');
        end
    else
        if sum(fss_gm) < sum(fss_pso)
            fprintf('O Gauss-Newton com Multi-Start decresceu o desajuste mais rapidamente para o mínimo da função\n.');
        else
            fprintf('A Nuvem de Partículas decresceu o desajuste mais rapidamente para o mínimo da função\n.');
        end
    end
else
    fprintf('Não rejeitamos H0. Não há diferença entre as somas dos custos das soluções obtidas pelo Gauss-Newton com Multi-Start, Algoritmo Genético e Nuvem de Partículas.\n');
end

% Plote os dados
iteracoes = 1:length(fss_gm);

figure;
hold on;
plot(iteracoes, fss_gm, 'ro', 'LineWidth', 2, 'MarkerFaceColor', 'red');
plot(iteracoes, fss_ga, 'go', 'LineWidth', 2, 'MarkerFaceColor', 'green');
plot(iteracoes, fss_pso, 'ko', 'LineWidth', 2, 'MarkerFaceColor', 'yellow');

xlabel('Evento');
ylabel('Decrescimento da Função Objetivo');

legend('Decrescimento do Gauss-Newton com Multi-Start', 'Decrescimento do Algoritmo Genético', 'Decrescimento da Nuvem de Partículas');

title('Comparação do Decrescimento da Função Objetivo');

grid on;
hold off;


