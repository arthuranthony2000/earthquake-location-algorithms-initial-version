clc;
clear all;
close all;

path = ["../GM/", "../GA/", "../PSO/", "../HGWO/"];
num_hipocentros = 4;
algorithms = ["Gauss-Newton with Multi-Start", "Genetic Algorithm", "Particle Swarm Optimization", "Hybrid Grey Wolf Optimizer"];
hipo_names = ["A", "B", "C", "D"];

iterations_limit = 10;

for i = 1:num_hipocentros
    
    % Carregue os arquivos necessários
    load('../cx_1');
    load('../cy_1');
    load('../cz_1');
    load('../v_1');
    
    ns = size(cx, 1);

    figure('Name', ['Hypocenter ', hipo_names{i}]);

    for j = 1:length(path)
        addpath(path(j));
        
        load(strcat(path(j), 'ssf_', string(i)));
        load(strcat(path(j), 'ssh_', string(i)));
        load(strcat(path(j), 'mss_', string(i)));
        load(strcat(path(j), 'tobs_', string(i)));

        subplot(2, 2, j);

        [x, y] = meshgrid(-15:35, -15:35);
        z = zeros(size(x));

        fobj = @(s, tobs, cx, cy, cz, ns, v) 1/length(tobs) * norm(tobs - hypo_direct(s, cx, cy, cz, ns, v));

        for k = 1:numel(x)
            s_test = [x(k), y(k), -5];
            z(k) = fobj(s_test, tobs, cx, cy, cz, ns, v);
        end

        % Crie o gráfico de contorno
        contour(x, y, z, 'DisplayName', 'Search Space');

        hold on;

        col_idx = 1;
        num_sol = 10;
        colors = jet(num_sol); % Gere uma paleta de cores para os hipocentros

        for k = 1:num_sol
            % Se você quiser usar diferentes marcadores, ajuste 'o' para o marcador desejado
            plot3(ssh(:, col_idx), ssh(:, col_idx + 1), ssh(:, col_idx + 2), 'kpentagram', ...
                'MarkerFaceColor', colors(k, :), 'MarkerSize', 10, 'DisplayName', ['Estimated Hypocenter ' num2str(k)]);

            col_idx = col_idx + 3;
        end    

        title(algorithms(j), 'FontSize', 12, 'FontWeight', 'bold');
        xlabel('X Coordinate');
        ylabel('Y Coordinate');
        zlabel('Z Coordinate');

        hold off;
        grid on;

        % Adicione a legenda
        %legend('Location', 'northeast', 'FontSize', 12, 'FontWeight', 'bold', 'AutoUpdate', 'off');
    end
end

