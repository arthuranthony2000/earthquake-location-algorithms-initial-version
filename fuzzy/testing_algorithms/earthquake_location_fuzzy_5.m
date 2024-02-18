clc
clear all
close all

vp = 6.15;
vs = 3.55;

tp = @(x_s, x_c, y_s, y_c) sqrt((x_s - x_c)^2 + (y_s - y_c)^2) / vp;
ts = @(x_s, x_c, y_s, y_c) sqrt((x_s - x_c)^2 + (y_s - y_c)^2) / vs;

event = [6, 3];

s1 = [4, 6];
s2 = [6, 8];

tobs_p = [tp(s1(1), event(1), s1(2), event(2)), tp(s2(1), event(1), s2(2), event(2))];
tobs_s = [ts(s1(1), event(1), s1(2), event(2)), ts(s2(1), event(1), s2(2), event(2))];

v_obs = @(s1, s2, c, tobs) (sqrt((s1(1) - c(1))^2 + (s1(2) - c(2))^2) - sqrt((s2(1) - c(1))^2 + (s2(2) - c(2))^2)) / (tobs(1) - tobs(2));
s_p_coefficient = @(vp, vs) (vp * vs) / (vp - vs);

grid_size = 25;

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

for i = 1:grid_size
    for j = 1:grid_size
        cell_coordinate = [j, i]; % Use grid coordinates
        result_p = norm(vp - v_obs(s1, s2, cell_coordinate, tobs_p));
        result_s = norm(vs - v_obs(s1, s2, cell_coordinate, tobs_s));
        result_c = norm((vp*vs/(vp-vs)) - s_p_coefficient(v_obs(s1, s2, cell_coordinate, tobs_p), v_obs(s1, s2, cell_coordinate, tobs_s)));
        
        % Trapezoidal functions for pertinence
        pertinence_p(i, j) = trapezoidal(v_obs(s1, s2, cell_coordinate, tobs_p), [5.9, 6.1, 6.2, 6.4]);
        pertinence_s(i, j) = trapezoidal(v_obs(s1, s2, cell_coordinate, tobs_s), [3.35, 3.52, 3.58, 3.75]);
        pertinence_c(i, j) = trapezoidal(s_p_coefficient(v_obs(s1, s2, cell_coordinate, tobs_p), v_obs(s1, s2, cell_coordinate, tobs_s)), [7.8, 8.3, 8.5, 9]);
        
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
best_coordinates = [x(col), y(row)]; % Use grid coordinates

fprintf('Best Coordinates (Grid Size %d): x = %.4f, y = %.4f\n', grid_size, best_coordinates(1), best_coordinates(2));

function pertinence = trapezoidal(value, params)
    a = params(1);
    b = params(2);
    c = params(3);
    d = params(4);

    pertinence = max(0, min([max(0, (value - a) / (b - a)), 1, max(0, (d - value) / (d - c))]));
end

