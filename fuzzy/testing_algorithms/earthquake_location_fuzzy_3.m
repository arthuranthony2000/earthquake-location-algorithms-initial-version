clc
clear all
close all

vp = 6.15;
vs = 3.55;

tp = @(x_s, x_c, y_s, y_c) sqrt((x_s-x_c)^2 + (y_s-y_c)^2)/vp;
ts = @(x_s, x_c, y_s, y_c) sqrt((x_s-x_c)^2 + (y_s-y_c)^2)/vs;

event = [6, 3];

s1 = [4, 6];
s2 = [6, 8];

tobs_p = [tp(s1(1), event(1), s1(2), event(2)), tp(s2(1), event(1), s2(2), event(2))];
tobs_s = [ts(s1(1), event(1), s1(2), event(2)), ts(s2(1), event(1), s2(2), event(2))];

v_obs = @(s1, s2, c, tobs) (sqrt((s1(1) - c(1))^2 + (s1(2) - c(2))^2) - sqrt((s2(1) - c(1))^2 + (s2(2) - c(2))^2))/(tobs(1)-tobs(2));
s_p_coefficient = @(vp, vs) vp*vs/(vp-vs);

% Define the grid
x = linspace(1, 50, 50);
y = linspace(1, 50, 50);
[X, Y] = meshgrid(x, y);

% Initialize error matrix and pertinence matrices
error_matrix_p = zeros(size(X));
error_matrix_s = zeros(size(X));
error_matrix_c = zeros(size(X));

pertinence_p = zeros(size(X));
pertinence_s = zeros(size(X));
pertinence_c = zeros(size(X));

% Loop through each cell and calculate the error and pertinence
for i = 1:numel(X)
    cell_coordinate = [X(i), Y(i)];
    result_p = norm(vp - v_obs(s1, s2, cell_coordinate, tobs_p));
    result_s = norm(vs - v_obs(s1, s2, cell_coordinate, tobs_s));
    result_c = norm(s_p_coefficient(v_obs(s1, s2, cell_coordinate, tobs_p), v_obs(s1, s2, cell_coordinate, tobs_s)));
    
    % Trapezoidal functions for pertinence
    pertinence_p(i) = trapezoidal(result_p, [5, 9, 6.1, 6.4]);
    pertinence_s(i) = trapezoidal(result_s, [3.35, 3.52, 3.58, 6.4]);
    pertinence_c(i) = trapezoidal(result_c, [7.8, 8.3, 8.5, 9]);

    % Store the error for visualization
    error_matrix_p(i) = result_p;
    error_matrix_s(i) = result_s;
    error_matrix_c(i) = result_c;
end

% Plot the pertinence functions
figure;

subplot(3, 2, 1);
contourf(X, Y, pertinence_p, 'LineColor', 'none');
colorbar;
title('P-Wave Pertinence');
colormap(flipud([1 1 1; 1 0.5 0.5])); % Adjust color map

subplot(3, 2, 2);
contourf(X, Y, pertinence_s, 'LineColor', 'none');
colorbar;
title('S-Wave Pertinence');
colormap(flipud([1 1 1; 1 0.5 0.5])); % Adjust color map

subplot(3, 2, 3);
contourf(X, Y, pertinence_c, 'LineColor', 'none');
colorbar;
title('S-P Coefficient Pertinence');
colormap(flipud([1 1 1; 1 0.5 0.5])); % Adjust color map

% Plot the error matrices
subplot(3, 2, 4);
imagesc(x, y, error_matrix_p);
colorbar;
title('Error Matrix P');
xlabel('X-coordinate');
ylabel('Y-coordinate');

subplot(3, 2, 5);
imagesc(x, y, error_matrix_s);
colorbar;
title('Error Matrix S');
xlabel('X-coordinate');
ylabel('Y-coordinate');

subplot(3, 2, 6);
imagesc(x, y, error_matrix_c);
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


