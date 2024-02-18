clc
clear all
close all

% Resultados do Gauss-Newton com Multi-Start e GA

v_fm_gm = zeros(1, 4);
v_fm_ga = zeros(1, 4);

for j = 1:4
    % Carregue os arquivos .mat
    addpath("../../gauss_newton_multi_start/");
    load(strcat('fss_', num2str(j)));
    fss = sum(fss)/10;
    
    fm_gm = max(fss);
    epoch_gm = 0;
    
    epsilon = 10^-2;
    
    epoch = 4;
    
    for i=2:11
        limiar = norm((fss(i) - fss(i-1))/fss(i));
        
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
    fss = sum(fss)/10;
    
    fm_ga = max(fss);
    epoch_ga = 0;
    
    for i=2:10
        limiar = norm((fss(i) - fss(i-1))/fss(i));
        
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
    
end

% Suponha que você tenha os vetores fmss_gm e fmss_ga definidos

% Crie um vetor de iterações (ou índice) para o eixo X, assumindo que tenha o mesmo comprimento que os dados
iteracoes = 1:length(v_fm_gm);

% Plote os dados
figure;
hold on;
plot(iteracoes, v_fm_gm, 'ro', 'LineWidth', 2, 'MarkerFaceColor', 'red');
plot(iteracoes, v_fm_ga, 'go', 'LineWidth', 2, 'MarkerFaceColor', 'green');

% Adicione rótulos aos eixos
xlabel('Evento');
ylabel('Custo da Função Objetivo');

% Adicione uma legenda
legend('Custo Estável Gauss-Newton com Multi-Start', 'Custo Estável Algoritmo Genético');

% Defina o título do gráfico
title('Comparação do Custo Estável da Função Objetivo');

% Mantenha a grade de fundo para facilitar a leitura
grid on;

% Mostrar o gráfico
hold off;

% Teste de hipótese Wilcoxon para comparar a convergência do desajuste
% das soluções
p = ranksum(v_fm_gm, v_fm_ga);

% Exiba os resultados
fprintf('Teste de Wilcoxon para menor custo na estabilidade das soluções:\n');
fprintf('H0: Não há diferença entre os custos médios nas iterações em que estabilizaram o Gauss-Newton com Multi-Start e o Algoritmo Genético.\n');
fprintf('H1: Há diferença entre os custos médios nas iterações em que estabilizaram o Gauss-Newton com Multi-Start e o Algoritmo Genético.\n');
fprintf('Valor-p: %.4f\n', p);

% Avalie a hipótese nula
alpha = 0.05;  % Nível de significância

if p < alpha
    fprintf('Rejeitamos H0. Há diferença entre nos custos médios nas iterações em que estabilizaram o Gauss-Newton com Multi-Start e o Algoritmo Genético.\n');
    if sum(v_fm_ga) < sum(v_fm_gm)
        fprintf('O Algoritmo Genético estabilizou com menor custo para o mínimo da função.\n');
    else
        fprintf('O Gauss-Newton com Multi-Start estabilizou com menor custo para o mínimo da função.\n');
    end
else
    fprintf('Não rejeitamos H0. Não há diferença entre os custos médios nas iterações em que estabilizaram o Gauss-Newton com Multi-Start e o Algoritmo Genético.\n');
end


