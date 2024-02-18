clc
clear all
close all

tic
global_experimental_gwo_tobs_1();
gwo_tobs_1 = toc; 

save('gwo_tobs_1', 'gwo_tobs_1');
save("-v7", "gwo_tobs_1.mat", "gwo_tobs_1");

tic
global_experimental_gwo_tobs_2();
gwo_tobs_2 = toc; 

save('gwo_tobs_2', 'gwo_tobs_2');
save("-v7", "gwo_tobs_2.mat", "gwo_tobs_2");

tic
global_experimental_gwo_tobs_3();
gwo_tobs_3 = toc; 

save('gwo_tobs_3', 'gwo_tobs_3');
save("-v7", "gwo_tobs_3.mat", "gwo_tobs_3");

tic
global_experimental_gwo_tobs_4();
gwo_tobs_4 = toc;

save('gwo_tobs_4', 'gwo_tobs_4');
save("-v7", "gwo_tobs_4.mat", "gwo_tobs_4");




