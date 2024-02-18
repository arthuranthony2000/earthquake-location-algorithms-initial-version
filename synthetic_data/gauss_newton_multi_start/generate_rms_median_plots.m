clc
clear all
close all

num_hipocentros = 4;
iterations_limit = 11;

hipo_names = ["A", "B", "C", "D"];

title('Curva de convergência');
hold on

for i = 1:num_hipocentros
    load(strcat('fss_', string(i)));    
    plotScore(iterations_limit, median(fss, 1), hipo_names, i);
end


hold off
grid on;

legend