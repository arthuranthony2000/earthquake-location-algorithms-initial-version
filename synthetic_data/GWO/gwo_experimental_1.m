clc
clear all
close all

xh = 7; % Longitude
yh = 10; % Latitude
zh = -8; % Profundidade do Terremoto

% Vetor com os parâmetros hipocentrais
s = [xh, yh, zh];

load('tobs_1');
load('cx_1');
load('cy_1');
load('cz_1');
load('v_1');

fobj = @(s, tobs, cx, cy, cz, ns, v) 1/length(tobs) * norm(tobs - hypo_direct(s, cx, cy, cz, ns, v));

ns = numel(cx);

[x, idx] = min(tobs);

stt = [cx(idx), cy(idx), cz(idx)]; % Estação que obteve o menor tempo de percurso

nVar = 3;

lb = stt*0.7;

lb(3) = -15;

ub = stt*1.3;

ub(3) = -5;

wolvesNo = 100; % Número de Lobos
maxIter = 100; %% Número de Iterações


[out, s_estimated] = GWO(fobj, tobs, nVar, lb, ub, maxIter, wolvesNo, cx, cy, cz, ns, v);

