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

% Parâmetros do PSO
nvars = 3;

lb = [1, 1, -10];

ub = [20, 17, -5];

w_max = 0.9;  % Valor máximo para o fator de inércia

w_min = 0.4;  % Valor mínimo para o fator de inércia

c1 = 2;

c2 = 2;

epoch = 4;

limiar = 1e-2;

popsize = 100;

itermax = 10;

% Executar PSO
[f, s_estimated, h_estimated] = PSO(fobj, nvars, lb, ub, itermax, popsize, c1, c2, limiar, epoch, w_max, w_min, tobs, cx, cy, cz, ns, v);









