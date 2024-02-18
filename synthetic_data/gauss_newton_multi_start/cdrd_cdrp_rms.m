% Limpa a área de trabalho
clc
clear all
%close all

% Define o número de hipocentros e iterações limite
num_hipocentros = 4;
iterations_limit = 11;

% Nomes dos hipocentros
hipo_names = ["A", "B", "C", "D"];

% Cria a figura com 3 subplots
figure;

% Subplot 1 - Código 1
subplot(2, 2, 1);
load('cx_1');
load('cy_1');
load('cz_1');
load('v_1');

ns = size(cx, 1);

hold on

for i = 1:num_hipocentros
    load(strcat('tobs_', string(i)));
    load(strcat('mss_', string(i)));

    tcalc = hypo_direct(mss, cx, cy, cz, ns, v);

    error = abs(tobs - tcalc);
    error = error ./ tobs;
    error = error .* 100;

    cdfplot(error);
end

xlabel('Erro Normalizado (%)');
ylabel('Frequência Acumulada (%)');
title('Erro cumulativo relativo distribuído dos dados');
legend(strcat('Hipocentro', " ", hipo_names));

%yticklabels({'0', '10', '20', '30', '40', '50', '60', '70', '80', '90', '100'});
yticklabels({'0', '20', '40','60', '80', '100'});


hold off

% Subplot 2 - Código 2
subplot(2, 2, 2);
load('cx_1');
load('cy_1');
load('cz_1');
load('v_1');

ns = size(cx, 1);

hold on

for i = 1:num_hipocentros
    load(strcat('s_', string(i)));
    load(strcat('mss_', string(i)));

    error = abs(mss - s);
    error = error ./ s;
    error = error .* 100;

    cdfplot(error);
end

xlabel('Erro Normalizado (%)');
ylabel('Frequência Acumulada (%)');
title('Erro cumulativo relativo distribuído dos parâmetros');
legend(strcat('Hipocentro', " ", hipo_names));

%yticklabels({'0', '10', '20', '30', '40', '50', '60', '70', '80', '90', '100'});
yticklabels({'0', '20', '40','60', '80', '100'});

hold off

% Subplot 3 - Código 3
subplot(2, 2, [3, 4]);

title('Curva de convergência');
hold on

for i = 1:num_hipocentros
    load(strcat('fss_', string(i)));
    %plotScore(iterations_limit, median(fss, 1), hipo_names, i);
    plotScore(iterations_limit, min(fss, [], 1), hipo_names, i);
end

hold off
grid on;
legend;

% Ajusta o tamanho da figura
set(gcf, 'Position', [100, 100, 800, 600]);

% Salva a figura em um arquivo (opcional)
% saveas(gcf, 'figura_com_subplots.png');

