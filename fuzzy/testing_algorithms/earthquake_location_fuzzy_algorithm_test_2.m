clc
clear all
close all

addpath("../");

fobj = @(s, tobs, st, v) 1/length(tobs) * norm(tobs - hypo_direct(s, st(:, 1), st(:, 2), st(:, 3), size(st(:, 1), 1), [-Inf, v]));

vp = 6.15;
vs = 3.55;

t = @(s, c, v) norm(s - c) / v;

fixed_z = -5;

event = [80, 50, -8];

st = [40, 33, 0;
    45, 50, 0;
    43, 52, 0;
    44, 55, 0;
    42, 50, 0;
    50, 51, 0
    52, 58, 0];

tobs_p = zeros(1, 7);
tobs_s = zeros(1, 7);

for i=1:7
    tobs_p(i) = t(st(i, :), event, vp);
    tobs_s(i) = t(st(i, :), event, vs);
end

D = @(s, c) norm(s - c);

v_obs = @(s1, s2, c, tobs) (D(s1, c) - D(s2, c)) / (tobs(1) - tobs(2));

s_p_coefficient = @(vp, vs) (vp * vs) / (vp - vs);

grid_size = 200;

x = linspace(1, grid_size, grid_size);
y = linspace(1, grid_size, grid_size);
[X, Y] = meshgrid(x, y);

pertinence_p = zeros(grid_size);
pertinence_s = zeros(grid_size);
pertinence_c = zeros(grid_size);

pertinence_e_vp = zeros(grid_size);
pertinence_e_vs = zeros(grid_size);

w = 2;

for i = 1:grid_size
    for j = 1:grid_size
        cell_coordinate = [i, j, fixed_z]; % Use grid coordinates
        
        % Trapezoidal functions for pertinence
        pertinence_e_vp(i, j) = trapezoidal(1-fobj(cell_coordinate, tobs_p, st, vp), [0, 0.8, 1.2, 1.5]);
        pertinence_e_vs(i, j) = trapezoidal(1-fobj(cell_coordinate, tobs_s, st, vs), [0, 0.8, 1.2, 1.5]);
    end
end

for k=1:6
    pertinence_p_aux = zeros(grid_size);
    pertinence_s_aux = zeros(grid_size);
    pertinence_c_aux = zeros(grid_size);
    
    for i = 1:grid_size
        for j = 1:grid_size
            cell_coordinate = [i, j, fixed_z]; % Use grid coordinates
            
            % Trapezoidal functions for pertinence
            pertinence_p_aux(i, j) = trapezoidal(v_obs(st(k, :), st(w, :), cell_coordinate, [tobs_p(k), tobs_p(w)]), [5.9, 6.1, 6.2, 6.4]);
            pertinence_s_aux(i, j) = trapezoidal(v_obs(st(k, :), st(w, :), cell_coordinate, [tobs_s(k), tobs_s(w)]), [3.35, 3.52, 3.58, 3.75]);
            pertinence_c_aux(i, j) = trapezoidal(s_p_coefficient(v_obs(st(k, :), st(w, :), cell_coordinate, [tobs_p(k), tobs_p(w)]), v_obs(st(k, :), st(w, :), cell_coordinate, [tobs_s(k), tobs_s(w)])), [7.8, 8.3, 8.5, 9]);
        end
    end
    
    pertinence_p = max(pertinence_p, pertinence_p_aux);
    pertinence_s = max(pertinence_s, pertinence_s_aux);
    pertinence_c = max(pertinence_c, pertinence_c_aux);
    
    w = w + 1;
end

% Perform the operation O = ((P-Wave ∩ P-Wave-Error) ∩ (S-Wave ∩ S-Wave-Error)) ∩ S-P Coefficient
pertinence_o = min(min(min(pertinence_p, pertinence_e_vp), min(pertinence_s, pertinence_e_vs)), pertinence_c);

% Perform the operation O = ((P-Wave ∩ P-Wave-Error) U (S-Wave S-Wave-Error)) ∩ S-P Coefficient
% pertinence_o = min(max(min(pertinence_p, pertinence_e_vp), min(pertinence_s, pertinence_e_vs)), pertinence_c);

% Perform the operation O = (P-Wave U S-Wave) ∩ S-P Coefficient
%pertinence_o = min(max(pertinence_p, pertinence_s), pertinence_c);

% Perform the operation O = (P-Wave ∩ S-Wave) ∩ S-P Coefficient
% pertinence_o = min(min(pertinence_p, pertinence_s), pertinence_c);

% Find the coordinates with pertinence closest to 1

best_coordinates = filter_solutions(pertinence_o);

event_estimated = [best_coordinates(1, :), fixed_z];

for i=2:size(best_coordinates, 1)
    if fobj(event_estimated, tobs_p, st, vp) > fobj([best_coordinates(i, :), fixed_z], tobs_p, st, vp)
        event_estimated = [best_coordinates(i, :), fixed_z];
    end
    
    if fobj(event_estimated, tobs_p, st, vp) <= 0.1
        break;
    end
end

%[row, col] = find(pertinence_o == max(pertinence_o(:)));
%best_coordinates = [row(1), col(1)]; % Use grid coordinates

%fprintf('Best Coordinates (Grid Size %d): x = %.4f, y = %.4f\n', grid_size, best_coordinates(1), best_coordinates(2));


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

subplot(2, 2, 1);
contourf(X, Y, pertinence_p, 'LineColor', 'none');
colormap(subplot(2, 2, 1), colormap_custom);
colorbar;
title('P-Wave Pertinence');

subplot(2, 2, 2);
contourf(X, Y, pertinence_s, 'LineColor', 'none');
colormap(subplot(2, 2, 2), colormap_custom);
colorbar;
title('S-Wave Pertinence');

subplot(2, 2, 3);
contourf(X, Y, pertinence_c, 'LineColor', 'none');
colormap(subplot(2, 2, 3), colormap_custom);
colorbar;
title('S-P Coefficient Pertinence');

subplot(2, 2, 4);
contourf(X, Y, pertinence_o, 'LineColor', 'none');
colormap(subplot(2, 2, 4), colormap_custom);
colorbar;
title('Fuzzy Output');


figure(2);
scatter(event(1), event(2), 100, 'kpentagram', 'filled'); % Black filled star for event
hold on;

scatter(event_estimated(1), event_estimated(2), 100, 'rpentagram', 'filled'); % Red filled star for estimated event
hold on;

scatter(st(:, 1), st(:, 2), 100, 'b^', 'filled'); % Blue filled triangles for stations
hold on;

xlabel('Latitude');
ylabel('Longitude');
title('Events and Stations Locations');
grid on;
legend('Event', 'Estimated Event', 'Stations');

