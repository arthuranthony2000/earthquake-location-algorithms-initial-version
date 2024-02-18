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

rng('shuffle');  % Isso define a semente aleatória com base no relógio do sistema

ns = numel(cx);

% ga params

nvars = 3;

popsize = 100;

itermax = 10;

lb = [1, 1, -10];

ub = [20, 17, -5];

cross_constant = 0.75;

mutation_constant = 0.01;

sigma = 0.1;

tournament_size = 3;

[f, s_estimated, h_estimated] = GA(fobj, nvars, lb, ub, cross_constant, mutation_constant, sigma, tournament_size, popsize, itermax, tobs, cx, cy, cz, ns, v);










