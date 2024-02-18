clc
clear all 
close all

load('cx_1');
load('cy_1');
load('cz_1');
load('v_1');

ns = size(cx, 1);

num_hipocentros = 4;

hipo_names = ["A", "B", "C", "D"];

hold on

for i=1:num_hipocentros
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
title('Erro cumulativo relativo distribuido dos dados');
legend(strcat('Hipocentro', " ", hipo_names));

yticklabels({'0', '10', '20', '30', '40', '50', '60', '70', '80', '90', '100'});

hold off

