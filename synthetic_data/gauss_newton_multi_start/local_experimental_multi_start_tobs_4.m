function local_experimental_multi_start_tobs_4()
clc
close all
clear all

load('tobs_4');
load('cx_1');
load('cy_1');
load('cz_1');
load('v_1');

fobj = @(s, tobs, cx, cy, cz, ns, v) 1/length(tobs) * norm(tobs - hypo_direct(s, cx, cy, cz, ns, v));

num_sol = 10;

itermax = 10;

type = "uniform";

[fss, ssf, fmss, mss, ssh] = multi_start(fobj, tobs, num_sol, itermax, type, cx, cy, cz, v);

save('fss_4', 'fss');
save("-v7", "fss_4.mat", "fss");

save('ssf_4', 'ssf');
save("-v7", "ssf_4.mat", "ssf");

save('fmss_4', 'fmss');
save("-v7", "fmss_4.mat", "fmss");

save('mss_4', 'mss');
save("-v7", "mss_4.mat", "mss");

save('ssh_4', 'ssh');
save("-v7", "ssh_4.mat", "ssh");

end
