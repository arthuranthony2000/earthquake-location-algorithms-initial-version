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

for i = 1:num_hipocentros
    load(strcat('s_', string(i)));
    
    hipo_x(i) = s(1);
    hipo_y(i) = s(2);
    hipo_z(i) = s(3);
end

% Plotagem em um gráfico 3D
scatter3(cx, cy, cz, "bv", 'MarkerFaceColor','blue');

title('Localização das estações e dos sismos');
xlabel('Latitude');
ylabel('Longitude');
zlabel('Profundidade');
hold on
plot3(hipo_x(:), hipo_y(:), hipo_z(:), 'rpentagram', 'MarkerFaceColor','red', 'MarkerSize', 10); % Localização do Hipocentro
hold off
grid on;

