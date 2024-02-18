clc
clear all
close all

% Malha 20km por 17km e 10km de profundidade

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

% Define médias e desvios padrão para as coordenadas x, y e z dos hipocentros
media_x = cols / 2; % Média de x no centro da malha
desvio_x = cols / 4; % Desvio padrão de x

media_y = rows / 2; % Média de y no centro da malha
desvio_y = rows / 4; % Desvio padrão de y

media_z = -8; % Média de z (profundidade negativa)
desvio_z = 2; % Desvio padrão de z

% Número de hipocentros a serem gerados
num_hipocentros = 4;

% Inicialize vetores para coordenadas x, y e z dos hipocentros
hipo_x = zeros(num_hipocentros, 1);
hipo_y = zeros(num_hipocentros, 1);
hipo_z = zeros(num_hipocentros, 1);

% Gere os hipocentros com distribuição gaussiana
for i = 1:num_hipocentros
    hipo_x(i) = normrnd(media_x, desvio_x);
    hipo_y(i) = normrnd(media_y, desvio_y);
    hipo_z(i) = normrnd(media_z, desvio_z);
    
    s = [hipo_x(i), hipo_y(i), hipo_z(i)];
    
    save(strcat('s_',string(i)), 's');
    save('-v7', strcat('s_',string(i),'.mat'), 's');    
    
    tobs = hypo_direct(s, cx, cy, cz, ns, v);
    
    tobs=tobs+0.025*randn(size(tobs)).*tobs;
    
    save(strcat('tobs_', string(i)), 'tobs');
    save('-v7', strcat('tobs_', string(i), '.mat'), 'tobs');
end

% Plotagem em um gráfico 3D
scatter3(cx, cy, cz, "bv", 'MarkerFaceColor','blue');

title('Sismos');
xlabel('Latitude');
ylabel('Longitude');
zlabel('Profundidade');
hold on
plot3(hipo_x(:), hipo_y(:), hipo_z(:), 'rpentagram', 'MarkerFaceColor','red', 'MarkerSize', 10); % Localização do Hipocentro
hold off
grid on;

save('v_1', 'v');
save("-v7", "v_1.mat", "v");

save('cx_1', 'cx');
save("-v7", "cx_1.mat", "cx");

save('cy_1', 'cy');
save("-v7", "cy_1.mat", "cy");

save('cz_1', 'cz');
save("-v7", "cz_1.mat", "cz");


