clc
clear all 
close all

% Malha 20km por 17km e 10km de profundidade

xh = 7; % Longitude
yh = 10; % Latitude
zh = -8; % Profundidade do Terremoto

s = [xh, yh, zh]; % Vetor de Parâmetros

v = [-4, 5.9; % Modelo Crustal de Velocidades
    -inf, 6.1];

% Tamanho da malha
rows = 20;
cols = 17;

% Número total de pontos
total_points = 42;

% Inicialize vetores para coordenadas x, y e z das estações
cx = zeros(total_points, 1);
cy = zeros(total_points, 1);
cz = zeros(total_points, 1);

ns = numel(cx);

% Calcula o espaçamento entre as estações
dx = cols / sqrt(total_points);
dy = rows / sqrt(total_points);

% Gerar malha de estações
point_count = 1;
for x = 1:dx:cols
    for y = 1:dy:rows
        if point_count <= total_points
            cx(point_count) = x;
            cy(point_count) = y;
            cz(point_count) = 0;
            point_count = point_count + 1;
        else
            break;
        end
    end
end

tobs_1 = ray_tracing(s, cx, cy, cz, ns, v);

load('tobs_1')




