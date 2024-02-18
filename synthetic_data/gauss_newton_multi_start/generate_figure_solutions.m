clc
clear all
close all

load('cx_1');
load('cy_1');
load('cz_1');
load('v_1');

num_hipocentros = 4;

ns = 5;

hipo_x = zeros(1, num_hipocentros);
hipo_y = zeros(1, num_hipocentros);
hipo_z = zeros(1, num_hipocentros);

hipo_x_estimated = zeros(1, num_hipocentros);
hipo_y_estimated = zeros(1, num_hipocentros);
hipo_z_estimated = zeros(1, num_hipocentros);

for i = 1:num_hipocentros
    load(strcat('s_', string(i)));
    
    hipo_x(i) = s(1);
    hipo_y(i) = s(2);
    hipo_z(i) = s(3);
end

for i = 1:num_hipocentros
    load(strcat('mss_', string(i)));
    
    hipo_x_estimated(i) = mss(1);
    hipo_y_estimated(i) = mss(2);
    hipo_z_estimated(i) = mss(3);
end

% Plotagem em um gráfico 3D
scatter3(cx, cy, cz, "bv", 'MarkerFaceColor','blue', 'DisplayName','Estações Sismográficas');

title('Estimativa hipocentral');
xlabel('Latitude');
ylabel('Longitude');
zlabel('Profundidade');
hold on

for i=1:num_hipocentros
    dhx = [hipo_x(i), hipo_x_estimated(i)];
    dhy = [hipo_y(i), hipo_y_estimated(i)];
    dhz = [hipo_z(i), hipo_z_estimated(i)];

    plot3(dhx, dhy, dhz, 'k-', 'MarkerSize', 20, 'HandleVisibility', 'off');  
end

rotulos = {'A', 'B', 'C', 'D'};

distance_points = 0.55;

scatter3(hipo_x(:), hipo_y(:), hipo_z(:)+distance_points, 10, 'filled', 'MarkerFaceColor','black', 'HandleVisibility', 'off');

for i = 1:numel(rotulos)
    text(hipo_x(i), hipo_y(i), hipo_z(i)+distance_points, rotulos{i}, 'FontSize', 12);
end

plot3(hipo_x(:), hipo_y(:), hipo_z(:), 'kpentagram', 'MarkerFaceColor','black', 'MarkerSize', 10, 'DisplayName','Hipocentro Real'); % Localização do Hipocentro
plot3(hipo_x_estimated(:), hipo_y_estimated(:), hipo_z_estimated(:), 'rpentagram', 'MarkerFaceColor','red', 'MarkerSize', 10, 'DisplayName','Hipocentro Estimado');
hold off
grid on;

legend

