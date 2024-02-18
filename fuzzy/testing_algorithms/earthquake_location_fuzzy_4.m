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

grid_size = 100;

x = linspace(1, grid_size, grid_size);
y = linspace(1, grid_size, grid_size);
[X, Y] = meshgrid(x, y);

% Inicializar matriz de erro e matrizes de pertinência
error_matrix_p = zeros(grid_size, grid_size);
error_matrix_s = zeros(grid_size, grid_size);
error_matrix_c = zeros(grid_size, grid_size);

pertinence_p = zeros(grid_size);
pertinence_s = zeros(grid_size);
pertinence_c = zeros(grid_size);

% Redução iterativa do tamanho da grade
while true
    for i = 1:grid_size
        for j = 1:grid_size
            cell_coordinate = [j, i]; % Use coordenadas da grade
            result_p = norm(vp - v_obs(s1, s2, cell_coordinate, tobs_p));
            result_s = norm(vs - v_obs(s1, s2, cell_coordinate, tobs_s));
            result_c = norm((vp*vs/(vp-vs)) - s_p_coefficient(v_obs(s1, s2, cell_coordinate, tobs_p), v_obs(s1, s2, cell_coordinate, tobs_s)));

            % Funções trapezoidais para pertinência
            pertinence_p(i, j) = trapezoidal(v_obs(s1, s2, cell_coordinate, tobs_p), [5.9, 6.1, 6.2, 60.4]);
            pertinence_s(i, j) = trapezoidal(v_obs(s1, s2, cell_coordinate, tobs_s), [3.35, 3.52, 3.58, 30.75]);
            pertinence_c(i, j) = trapezoidal(s_p_coefficient(v_obs(s1, s2, cell_coordinate, tobs_p), v_obs(s1, s2, cell_coordinate, tobs_s)), [7.8, 8.3, 8.5, 90]);

            % Armazenar o erro para visualização
            error_matrix_p(i, j) = result_p;
            error_matrix_s(i, j) = result_s;
            error_matrix_c(i, j) = result_c;
        end
    end

    % Realizar a operação O = (P-Wave U S-Wave) ∩ S-P Coefficient
    pertinence_o = min(max(pertinence_p, pertinence_s), pertinence_c);

    % Verificar se a pertinência máxima é igual a 1
    if grid_size > 10
        break; % Saia do loop se a condição for atendida
    else
        % Reduzir o tamanho da grade
        grid_size = grid_size - 10; % Redução do tamanho da grade em 10 unidades
        x = linspace(1, grid_size, grid_size);
        y = linspace(1, grid_size, grid_size);
        [X, Y] = meshgrid(x, y);

        pertinence_p = zeros(grid_size);
        pertinence_s = zeros(grid_size);
        pertinence_c = zeros(grid_size);
    end
end

% Encontrar as coordenadas com pertinência mais próxima de 1
[row, col] = find(pertinence_o == max(pertinence_o(:)));
best_coordinates = [x(col), y(row)]; % Use coordenadas da grade

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
num_colors = 100; % Número de valores intermediários
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
