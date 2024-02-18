clc
clear all
close all

tic
global_experimental_pso_tobs_1();
pso_tobs_1 = toc; 

save('pso_tobs_1', 'pso_tobs_1');
save("-v7", "pso_tobs_1.mat", "pso_tobs_1");

tic
global_experimental_pso_tobs_2();
pso_tobs_2 = toc; 

save('pso_tobs_2', 'pso_tobs_2');
save("-v7", "pso_tobs_2.mat", "pso_tobs_2");

tic
global_experimental_pso_tobs_3();
pso_tobs_3 = toc; 

save('pso_tobs_3', 'pso_tobs_3');
save("-v7", "pso_tobs_3.mat", "pso_tobs_3");

tic
global_experimental_pso_tobs_4();
pso_tobs_4 = toc;

save('pso_tobs_4', 'pso_tobs_4');
save("-v7", "pso_tobs_4.mat", "pso_tobs_4");




