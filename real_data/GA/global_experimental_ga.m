clc
clear all
close all

tic
global_experimental_ga_tobs_1();
ga_tobs_1 = toc; 

save('ga_tobs_1', 'ga_tobs_1');
save("-v7", "ga_tobs_1.mat", "ga_tobs_1");

tic
global_experimental_ga_tobs_2();
ga_tobs_2 = toc; 

save('ga_tobs_2', 'ga_tobs_2');
save("-v7", "ga_tobs_2.mat", "ga_tobs_2");

tic
global_experimental_ga_tobs_3();
ga_tobs_3 = toc; 

save('ga_tobs_3', 'ga_tobs_3');
save("-v7", "ga_tobs_3.mat", "ga_tobs_3");

tic
global_experimental_ga_tobs_4();
ga_tobs_4 = toc;

save('ga_tobs_4', 'ga_tobs_4');
save("-v7", "ga_tobs_4.mat", "ga_tobs_4");




