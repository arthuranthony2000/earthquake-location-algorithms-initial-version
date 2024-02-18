clc
clear all
close all

load('cx_1');
load('cy_1');
load('cz_1');
load('v_1');

algorithms = ["../gauss_newton_multi_start", "../genetic_algorithm", "../PSO", "../HybridGWO"];
hypo_names = ["A", "B", "C", "D"];

ns = size(cx, 2);

figure;
for i=1:4
    subplot(2, 2, i);   
    
    hold on;
    
    for j=1:4
        addpath(algorithms(j));
        load(strcat('tobs_', string(i)));
        load(strcat('mss_', string(i)));
        
        tcalc = hypo_direct(mss, cx, cy, cz, ns, v);    
        error = abs(tobs - tcalc);
        error = error ./ tobs;
        error = error .* 100;    
        cdfplot(error);
    end
    
    hold off;
    
    xlabel('Normalized Error (%)');
    ylabel('Cumulative Frequency (%)');
    title(strcat("Hypocenter " ,hypo_names(i)));
    legend(["Gauss-Newton with Multi-Start", "Genetic Algorithm", "Particle Swarm Optimization", "Hybrid Grey Wolf Optimizer"]);
end
