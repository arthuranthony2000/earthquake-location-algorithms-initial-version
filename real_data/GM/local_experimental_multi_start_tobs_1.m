function local_experimental_multi_start_tobs_1()
clc
clear all
close all

load('tobs_1');
load('cx_1');
load('cy_1');
load('cz_1');
load('v_1');

fobj = @(s, tobs, cx, cy, cz, ns, v) 1/length(tobs) * norm(tobs - hypo_direct(s, cx, cy, cz, ns, v));

num_sol = 10;

itermax = 10;

type = "uniform";

[fss, ssf, fmss, mss, ssh] = multi_start(fobj, tobs, num_sol, itermax, type, cx, cy, cz, v);

save('fss_1', 'fss');
save("-v7", "fss_1.mat", "fss");

save('ssf_1', 'ssf');
save("-v7", "ssf_1.mat", "ssf");

save('fmss_1', 'fmss');
save("-v7", "fmss_1.mat", "fmss");

save('mss_1', 'mss');
save("-v7", "mss_1.mat", "mss");

save('ssh_1', 'ssh');
save("-v7", "ssh_1.mat", "ssh");

end
