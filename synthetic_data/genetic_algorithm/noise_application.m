clc
clear all
close all

load('cx_1');
load('cy_1');
load('cz_1');
load('v_1');

ns = size(cx, 1);

num_hipocentros = 4;

for i = 1:num_hipocentros
    load(strcat('s_',string(i)))   
    
    tobs = hypo_direct(s, cx, cy, cz, ns, v);
    
    tobs=tobs+0.025*randn(size(tobs)).*tobs;
    
    save(strcat('tobs_', string(i)), 'tobs');
    save('-v7', strcat('tobs_', string(i), '.mat'), 'tobs');
end

