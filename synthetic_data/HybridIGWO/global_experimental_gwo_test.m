clc
clear
close all

load('s_1');
load('tobs_1');
load('cx_1');
load('cy_1');
load('cz_1');
load('v_1');

fobj = @(s, tobs, cx, cy, cz, ns, v) 1/length(tobs) * norm(tobs - hypo_direct(s, cx, cy, cz, ns, v));

rng('shuffle');  % Isso define a semente aleatória com base no relógio do sistema

ns = numel(cx);

% Parâmetros do GWO
nVar = 3;

lb = [1, 1, -10];

ub = [20, 17, -5];

wolvesNo = 100;

maxIter = 10;

% Executar GWO
tic
[f_gwo, s_estimated_gwo, h_estimated_gwo] = GWO(fobj, tobs, nVar, lb, ub, maxIter, wolvesNo, cx, cy, cz, ns, v);
time_gwo = toc;

% Executar IGWO
tic
[f_igwo, s_estimated_igwo, h_estimated_igwo] = IGWO(fobj, tobs, nVar, lb, ub, maxIter, wolvesNo, cx, cy, cz, ns, v);
time_igwo = toc;

cross_constant = 0.75;

mutation_constant = 0.01;

sigma = 0.1;

tournament_size = 3;

% Executar HybridGWO
tic
[f_hgwo, s_estimated_hgwo, h_estimated_hgwo] = HybridIGWO(fobj, tobs, nVar, lb, ub, maxIter, wolvesNo, cx, cy, cz, ns, v, cross_constant, mutation_constant, sigma, tournament_size);
time_hgwo = toc;

coast_gwo = fobj(s_estimated_gwo, tobs, cx, cy, cz, ns, v);
coast_igwo = fobj(s_estimated_igwo, tobs, cx, cy, cz, ns, v);
coast_hgwo = fobj(s_estimated_hgwo, tobs, cx, cy, cz, ns, v);


