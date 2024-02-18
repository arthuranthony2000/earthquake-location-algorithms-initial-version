clc
clear all
close all

load('../cx_1');
load('../cy_1');
load('../cz_1');
load('../v_1');

algorithms = ["../GM", "../GA", "../PSO", "../HGWO"];
hypo_names = [56, 124, 775, 541];

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
    title(strcat("Hypocenter " ,num2str(hypo_names(i))));
    legend(["Gauss-Newton with Multi-Start", "Genetic Algorithm", "Particle Swarm Optimization", "Hybrid Grey Wolf Optimizer"]);
end
