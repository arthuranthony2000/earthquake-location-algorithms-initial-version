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

% Initialize error matrix
error_matrix = zeros(size(X));

% Loop through each cell and calculate the error
for i = 1:numel(X)
    cell_coordinate = [X(i), Y(i)];
    result_p = norm(vp - v_obs(s1, s2, cell_coordinate, tobs_p));
    result_s = norm(vs - v_obs(s1, s2, cell_coordinate, tobs_s));
    result_c = norm(s_p_coefficient(v_obs(s1, s2, cell_coordinate, tobs_p), v_obs(s1, s2, cell_coordinate, tobs_s)) - s_p_coefficient(vp, vs));
    error_matrix(i) = result_p + result_s + result_c;
end

% Plot the error matrix with colorbar
figure;
imagesc(x, y, error_matrix);
colorbar;
title('Error Matrix');
xlabel('X-coordinate');
ylabel('Y-coordinate');
