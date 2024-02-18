clc
clear all
close all

vp = 6.15;
vs = 3.55;

t = @(s, c, v) norm(s - c) / v;

%fixed_z = -5;
fixed_z = -8;

event = [6, 3, -8];

s1 = [4, 6, 0];
s2 = [6, 8, 0];

tobs_p = [t(s1, event, vp), t(s2, event, vp)];
tobs_s = [t(s1, event, vs), t(s2, event, vs)];

%tobs_p = tobs_p+0.025*randn(size(tobs_p)).*tobs_p;
%tobs_s = tobs_s+0.025*randn(size(tobs_s)).*tobs_s;

D = @(s, c) norm(s - c);

v_obs = @(s1, s2, c, tobs) (D(s1, c) - D(s2, c)) / (tobs(1) - tobs(2));

s_p_coefficient = @(vp, vs) (vp * vs) / (vp - vs);

grid_size = 200;

x = linspace(1, grid_size, grid_size);
y = linspace(1, grid_size, grid_size);
[X, Y] = meshgrid(x, y);

% Initialize error matrix and pertinence matrices
error_matrix_p = zeros(grid_size, grid_size);
error_matrix_s = zeros(grid_size, grid_size);
error_matrix_c = zeros(grid_size, grid_size);

pertinence_p = zeros(grid_size);
pertinence_s = zeros(grid_size);
pertinence_c = zeros(grid_size);

velocity_matrix_p = zeros(grid_size, grid_size);
velocity_matrix_s = zeros(grid_size, grid_size);
c_matrix = zeros(grid_size, grid_size);

for i = 1:grid_size
    for j = 1:grid_size
        cell_coordinate = [j, i, fixed_z]; % Use grid coordinates
       
        % Trapezoidal functions for pertinence
        pertinence_p(i, j) = trapezoidal(v_obs(s1, s2, cell_coordinate, tobs_p), [5.9, 6.1, 6.2, 14.4]);
        pertinence_s(i, j) = trapezoidal(v_obs(s1, s2, cell_coordinate, tobs_s), [3.35, 3.52, 3.58, 8.75]);
        pertinence_c(i, j) = trapezoidal(s_p_coefficient(v_obs(s1, s2, cell_coordinate, tobs_p), v_obs(s1, s2, cell_coordinate, tobs_s)), [7.8, 8.3, 8.5, 16]);
        
        velocity_matrix_p(i, j) = v_obs(s1, s2, cell_coordinate, tobs_p);
        velocity_matrix_s(i, j) = v_obs(s1, s2, cell_coordinate, tobs_s);
        c_matrix(i, j) = s_p_coefficient(v_obs(s1, s2, cell_coordinate, tobs_p), v_obs(s1, s2, cell_coordinate, tobs_s));
        
        result_p = norm(vp - v_obs(s1, s2, cell_coordinate, tobs_p));
        result_s = norm(vs - v_obs(s1, s2, cell_coordinate, tobs_s));
        result_c = norm((vp*vs/(vp-vs)) - s_p_coefficient(v_obs(s1, s2, cell_coordinate, tobs_p), v_obs(s1, s2, cell_coordinate, tobs_s)));
        
        % Store the error for visualization
        error_matrix_p(i, j) = result_p;
        error_matrix_s(i, j) = result_s;
        error_matrix_c(i, j) = result_c;
    end
end

% Perform the operation O = (P-Wave U S-Wave) ∩ S-P Coefficient
pertinence_o = min(max(pertinence_p, pertinence_s), pertinence_c);

% Find the coordinates with pertinence closest to 1
[row, col] = find(pertinence_o == max(pertinence_o(:)));
best_coordinates = [col(size(col, 1)), row(size(row, 1))]; % Use grid coordinates

fprintf('Best Coordinates (Grid Size %d): x = %.4f, y = %.4f\n', grid_size, best_coordinates(1), best_coordinates(2));


% Plotar as funções de pertinência
figure(1);

% Criar um vetor de cores para a transição suave
num_colors = 100; % Número de valores intermediários
colormap_custom = [
    linspace(0.5, 0, num_colors)', ... % Componente vermelha (cinza para azul claro)
    linspace(0.5, 0.5, num_colors)', ... % Componente verde (cinza)
    linspace(0.5, 1, num_colors)'; ... % Componente azul (cinza para azul claro)
    
    linspace(0, 0.5, num_colors)', ... % Componente vermelha (azul claro para azul escuro)
    linspace(0.5, 0.5, num_colors)', ... % Componente verde (azul claro)
    linspace(1, 0.5, num_colors)'; ... % Componente azul (azul claro para azul escuro)
    
    linspace(0.5, 1, num_colors)', ... % Componente vermelha (azul escuro para rosa)
    linspace(0.5, 0, num_colors)', ... % Componente verde (azul escuro para rosa)
    linspace(0.5, 0.5, num_colors)'; ... % Componente azul (azul escuro para rosa)
    
    linspace(1, 1, num_colors)', ... % Componente vermelha (rosa)
    linspace(0, 0, num_colors)', ... % Componente verde (rosa)
    linspace(0.5, 0.5, num_colors)'; ... % Componente azul (rosa)
    
    linspace(1, 0.5, num_colors)', ... % Componente vermelha (rosa para violeta)
    linspace(0, 0.5, num_colors)', ... % Componente verde (rosa para violeta)
    linspace(0.5, 1, num_colors)' % Componente azul (rosa para violeta)
];

% Plotar as funções de pertinência
figure(1);

subplot(1, 3, 1);
contourf(X, Y, pertinence_p, 'LineColor', 'none');
colormap(subplot(1, 3, 1), colormap_custom);
colorbar;
title('P-Wave Pertinence');

subplot(1, 3, 2);
contourf(X, Y, pertinence_s, 'LineColor', 'none');
colormap(subplot(1, 3, 2), colormap_custom);
colorbar;
title('S-Wave Pertinence');

subplot(1, 3, 3);
contourf(X, Y, pertinence_c, 'LineColor', 'none');
colormap(subplot(1, 3, 3), colormap_custom);
colorbar;
title('S-P Coefficient Pertinence');


% Criar um vetor de cores para a transição suave invertida
colormap_custom = [
    linspace(1, 0.5, num_colors)', ... % Componente vermelha (violeta para rosa)
    linspace(0, 0.5, num_colors)', ... % Componente verde (violeta para rosa)
    linspace(0.5, 1, num_colors)'; ... % Componente azul (violeta para rosa)
    
    linspace(0.5, 1, num_colors)', ... % Componente vermelha (rosa para azul claro)
    linspace(0, 0, num_colors)', ... % Componente verde (rosa para azul claro)
    linspace(1, 1, num_colors)'; ... % Componente azul (rosa para azul claro)
    
    linspace(1, 0.5, num_colors)', ... % Componente vermelha (azul claro para azul escuro)
    linspace(1, 0.5, num_colors)', ... % Componente verde (azul claro para azul escuro)
    linspace(1, 0.5, num_colors)'; ... % Componente azul (azul claro para azul escuro)
    
    linspace(0.5, 1, num_colors)', ... % Componente vermelha (azul escuro para cinza)
    linspace(0.5, 1, num_colors)', ... % Componente verde (azul escuro para cinza)
    linspace(0.5, 1, num_colors)' % Componente azul (azul escuro para cinza)
];

% Plotar as matrizes de erro
figure(2);

subplot(1, 3, 1);
imagesc(x, y, error_matrix_p);
colormap(subplot(1, 3, 1), colormap_custom);
colorbar;
title('Error Matrix P');
xlabel('X-coordinate');
ylabel('Y-coordinate');

subplot(1, 3, 2);
imagesc(x, y, error_matrix_s);
colormap(subplot(1, 3, 2), colormap_custom);
colorbar;
title('Error Matrix S');
xlabel('X-coordinate');
ylabel('Y-coordinate');

subplot(1, 3, 3);
imagesc(x, y, error_matrix_c);
colormap(subplot(1, 3, 3), colormap_custom);
colorbar;
title('Error Matrix C');
xlabel('X-coordinate');
ylabel('Y-coordinate');


function pertinence = trapezoidal(value, params)
    a = params(1);
    b = params(2);
    c = params(3);
    d = params(4);

    pertinence = max(0, min([max(0, (value - a) / (b - a)), 1, max(0, (d - value) / (d - c))]));
end