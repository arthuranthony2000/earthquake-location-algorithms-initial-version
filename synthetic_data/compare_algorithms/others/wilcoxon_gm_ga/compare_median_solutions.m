clc
clear all
close all

% Resultados do Gauss-Newton com Multi-Start e GA

% Vetor com as soluções verdadeiras
ss = zeros(1, 12);

% Vetor da média das soluções do Gauss-Newton com Multi-Start
mss_gm = zeros(1, 12);

% Vetor da média das soluções do Algoritmo Genético
mss_ga = zeros(1, 12);

col_idx = 1; % Índice da próxima coluna em mss_gm e mss_ga

for i = 1:4
    % Carregue os arquivos .mat
    addpath("../../gauss_newton_multi_start/");
    load(strcat('mss_', num2str(i)));
    load(strcat('s_', num2str(i)));
    ss(:, col_idx:col_idx+2) = s;
    mss_gm(:, col_idx:col_idx+2) = mss;
    
    addpath("../../genetic_algorithm/");
    load(strcat('mss_', num2str(i)));
    mss_ga(:, col_idx:col_idx+2) = mss;
    
    col_idx = col_idx + 3;
end

% Suponha que você tenha os vetores ss, mss_gm e mss_ga definidos
% Cada vetor tem 12 hipocentros, com coordenadas x, y e z embutidas.

% Divida os vetores em coordenadas x, y e z
x_ss = ss(1:3:end); % Coordenadas x de ss
y_ss = ss(2:3:end); % Coordenadas y de ss
z_ss = ss(3:3:end); % Coordenadas z de ss

x_mss_gm = mss_gm(1:3:end); % Coordenadas x de mss_gm
y_mss_gm = mss_gm(2:3:end); % Coordenadas y de mss_gm
z_mss_gm = mss_gm(3:3:end); % Coordenadas z de mss_gm

x_mss_ga = mss_ga(1:3:end); % Coordenadas x de mss_ga
y_mss_ga = mss_ga(2:3:end); % Coordenadas y de mss_ga
z_mss_ga = mss_ga(3:3:end); % Coordenadas z de mss_ga

% Plote os sismos
figure;
hold on;
plot3(x_ss, y_ss, z_ss, 'kpentagram', 'MarkerFaceColor', 'black', 'MarkerSize', 8, 'DisplayName', 'Hipocentro Real');
plot3(x_mss_gm, y_mss_gm, z_mss_gm, 'rpentagram', 'MarkerFaceColor', 'red', 'MarkerSize', 8, 'DisplayName', 'Hipocentro Estimado para o Gauss-Newton com Multi-Start');
plot3(x_mss_ga, y_mss_ga, z_mss_ga, 'gpentagram', 'MarkerFaceColor', 'green', 'MarkerSize', 8, 'DisplayName', 'Hipocentro Estimado para o Algoritmo Genético');

% Adicione rótulos aos eixos
xlabel('Latitude');
ylabel('Longitude');
zlabel('Profunidade');

% Adicione uma legenda
legend;

% Defina o título do gráfico
title('Localização dos Hipocentros');

% Defina a visualização para uma melhor perspectiva 3D
view(3);

% Mantenha a grade de fundo para facilitar a leitura
grid on;

% Mostrar o gráfico
hold off;


% Teste de hipótese Wilcoxon para comparar a média das soluções
p = ranksum(mss_gm, mss_ga);

% Exiba os resultados
fprintf('Teste de Wilcoxon para as soluções médias:\n');
fprintf('H0: Não há diferença entre as soluções médias obtidas pelo Gauss-Newton com Multi-Start e o Algoritmo Genético.\n');
fprintf('H1: Há diferença entre as solução médias obtidas pelo Gauss-Newton com Multi-Start e o Algoritmo Genético.\n');
fprintf('Valor-p: %.4f\n', p);

% Avalie a hipótese nula
alpha = 0.05;  % Nível de significância

if p < alpha
    fprintf('Rejeitamos H0. Há diferença entre as soluções médias obtidas pelo Gauss-Newton com Multi-Start e o Algoritmo Genético.\n');
    if norm(mss_ga - ss) < norm(mss_gm - ss)
        fprintf('O Algoritmo Genético teve sua solução média mais próxima da solução verdadeira.\n');
    else
        fprintf('O Gauss-Newton com Multi-Start teve sua solução média mais próxima da solução verdadeira\n.');
    end
else
    fprintf('Não rejeitamos H0. Não há diferença entre as soluções médias obtidas pelo Gauss-Newton com Multi-Start e o Algoritmo Genético.\n');
end



