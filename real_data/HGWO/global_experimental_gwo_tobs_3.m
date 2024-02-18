function global_experimental_gwo_tobs_3()
clc
clear
close all

load('tobs_3');
load('cx_1');
load('cy_1');
load('cz_1');
load('v_1');

fobj = @(s, tobs, cx, cy, cz, ns, v) 1/length(tobs) * norm(tobs - hypo_direct(s, cx, cy, cz, ns, v));

num_sol = 10;

itermax = 10;

[fss, ssf, fmss, mss, ssh] = gwo_optimization(fobj, tobs, num_sol, itermax, cx, cy, cz, v);

save('fss_3', 'fss');
save("-v7", "fss_3.mat", "fss");

save('ssf_3', 'ssf');
save("-v7", "ssf_3.mat", "ssf");

save('fmss_3', 'fmss');
save("-v7", "fmss_3.mat", "fmss");

save('mss_3', 'mss');
save("-v7", "mss_3.mat", "mss");

save('ssh_3', 'ssh');
save("-v7", "ssh_3.mat", "ssh");

end