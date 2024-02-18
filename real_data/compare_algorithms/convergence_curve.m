% Limpa a área de trabalho
clc
clear all
close all

path = ["../GM/", "../GA/", "../PSO/", "../HGWO/"];
num_hipocentros = 4;
iterations_limit = 10;
algorithms = ["Gauss-Newton with Multi-Start", "Genetic Algorithm", "Particle Swarm Optimization", "Hybrid Grey Wolf Optimizer"];
hipo_names = ["A", "B", "C", "D"];

figure;

for i = 1:num_hipocentros  
    subplot(2, 2, i);
    hold on
    title(['Hypocenter ', hipo_names(i)]);
    
    for j=1:length(path)
        addpath(path(j));
        load(strcat('fss_', string(i)));
        y = min(fss, [], 1);
        plotScore(10, y(1:10), algorithms, j);
    end

    grid on;
    legend(algorithms);
    hold off
end





