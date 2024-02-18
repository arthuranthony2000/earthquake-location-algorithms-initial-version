function global_experimental_ga_tobs_2()
clc
close all
clear all

load('tobs_2');
load('cx_1');
load('cy_1');
load('cz_1');
load('v_1');

fobj = @(s, tobs, cx, cy, cz, ns, v) 1/length(tobs) * norm(tobs - hypo_direct(s, cx, cy, cz, ns, v));

num_sol = 10;

itermax = 10;

[fss, ssf, fmss, mss, ssh] = ga_optimization(fobj, tobs, num_sol, itermax, cx, cy, cz, v);

save('fss_2', 'fss');
save("-v7", "fss_2.mat", "fss");

save('ssf_2', 'ssf');
save("-v7", "ssf_2.mat", "ssf");

save('fmss_2', 'fmss');
save("-v7", "fmss_2.mat", "fmss");

save('mss_2', 'mss');
save("-v7", "mss_2.mat", "mss");

save('ssh_2', 'ssh');
save("-v7", "ssh_2.mat", "ssh");

end