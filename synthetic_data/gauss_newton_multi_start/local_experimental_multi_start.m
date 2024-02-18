clc
clear all
close all

tic
local_experimental_multi_start_tobs_1();
multi_start_tobs_1 = toc; 

save('multi_start_tobs_1', 'multi_start_tobs_1');
save("-v7", "multi_start_tobs_1.mat", "multi_start_tobs_1");

tic
local_experimental_multi_start_tobs_2();
multi_start_tobs_2 = toc; 

save('multi_start_tobs_2', 'multi_start_tobs_2');
save("-v7", "multi_start_tobs_2.mat", "multi_start_tobs_2");

tic
local_experimental_multi_start_tobs_3();
multi_start_tobs_3 = toc; 

save('multi_start_tobs_3', 'multi_start_tobs_3');
save("-v7", "multi_start_tobs_3.mat", "multi_start_tobs_3");

tic
local_experimental_multi_start_tobs_4();
multi_start_tobs_4 = toc;

save('multi_start_tobs_4', 'multi_start_tobs_4');
save("-v7", "multi_start_tobs_4.mat", "multi_start_tobs_4");




