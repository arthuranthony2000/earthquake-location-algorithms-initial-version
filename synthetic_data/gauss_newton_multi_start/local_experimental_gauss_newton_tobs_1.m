clc
close all
clear all

load('s_1');
load('tobs_1');
load('cx_1');
load('cy_1');
load('cz_1');
load('v_1');

fobj = @(s, tobs, cx, cy, cz, ns, v) 1/length(tobs) * norm(tobs - hypo_direct(s, cx, cy, cz, ns, v));

ns = numel(cx);

[x, idx] = min(tobs);

stt = [cx(idx), cy(idx), cz(idx)]; % Estação que obteve o menor tempo de percurso

s0 = [stt(1), stt(2), -5];

itermax = 10;

[f, s_estimated] = gauss_newton(s0, fobj, itermax, tobs, cx, cy, cz, ns, v);










