clc
clear all
close all

addpath("../../gauss_newton_multi_start/");
load(strcat('fss_', num2str(1)));
fss_gm = sum(fss)/10;

it_gm = -1;
epoch_gm = 0;

it_ga = -1;
epoch_ga = 0;

it_pso = -1;
epoch_pso = 0;

epsilon = 10^-2;

for i=2:10
    if abs(fss_gm(i) - fss_gm(i-1)) <= epsilon && epoch_gm == 0
        it_gm = i;
        epoch_gm = epoch_gm + 1;
    elseif abs(fss_gm(i) - fss_gm(i-1)) <= epsilon && epoch_gm ~= 0
        epoch_gm = epoch_gm + 1;
    elseif abs(fss_gm(i) - fss_gm(i-1)) <= epsilon && epoch_gm <= 2
        break;
    elseif abs(fss_gm(i) - fss_gm(i-1)) > epsilon
        it_gm = -1;
        epoch_gm = 0;
    end
end

addpath("../../genetic_algorithm/");
load(strcat('fss_', num2str(1)));
fss_ga = sum(fss)/10;

for i=2:10
    if abs(fss_ga(i) - fss_ga(i-1)) <= epsilon && epoch_ga == 0
        it_ga = i;
        epoch_pso = epoch_pso + 1;
    elseif abs(fss_ga(i) - fss_ga(i-1)) <= epsilon && epoch_ga ~= 0
        epoch_ga = epoch_ga + 1;
    elseif abs(fss_ga(i) - fss_ga(i-1)) <= epsilon && epoch_ga <= 2
        break;
    elseif abs(fss_ga(i) - fss_ga(i-1)) > epsilon
        it_ga = -1;
        epoch_ga = 0;
    end
end


addpath("../../PSO/");
load(strcat('fss_', num2str(1)));
fss_pso = sum(fss)/10;

for i=2:10
    if abs(fss_pso(i) - fss_pso(i-1)) <= epsilon && epoch_pso == 0
        it_pso = i;
        epoch_pso = epoch_pso + 1;
    elseif abs(fss_pso(i) - fss_pso(i-1)) <= epsilon && epoch_pso ~= 0
        epoch_pso = epoch_pso + 1;
    elseif abs(fss_pso(i) - fss_pso(i-1)) <= epsilon && epoch_pso <= 2
        break;
    elseif abs(fss_pso(i) - fss_pso(i-1)) > epsilon
        it_pso = -1;
        epoch_pso = 0;
    end
end

