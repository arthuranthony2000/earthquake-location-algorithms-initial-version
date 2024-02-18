clc;
clear all;
close all;

% Carregue os dados necessários (certifique-se de ter esses arquivos de dados)
load('cx_1');
load('cy_1');
load('cz_1');
load('v_1');

ns = size(cx, 1);

fobj = @(s, tobs, cx, cy, cz, ns, v) 1/length(tobs) * norm(tobs - hypo_direct(s, cx, cy, cz, ns, v));

rotulos = {' X', ' Y', ' Z'};

hipo_names = {' A', ' B', ' C', ' D'};

num_hipocentros = 4;

% Crie uma figura com subplots 2x2
figure;

for j = 1:num_hipocentros
    load(strcat('s_', string(j)));
    load(strcat('ssf_', string(j)));
    load(strcat('ssh_', string(j)));
    load(strcat('mss_', string(j)));
    load(strcat('tobs_', string(j)));
    
    % Determine as coordenadas do subplot com base em j
    subplot(2, 2, j);
    
    [x, y] = meshgrid(1:20, 1:20);
    z = zeros(size(x));
    
    for i = 1:numel(x)
        s_test = [x(i), y(i), s(3)];
        z(i) = fobj(s_test, tobs, cx, cy, cz, ns, v);
    end
    
    % Crie o gráfico de contorno
    contour(x, y, z, 'DisplayName','Espaço de Busca');
    
    hold on;
    
    col_idx = 1;
    
    num_sol = 10;
    
    colors = jet(num_sol); % Gere uma paleta de cores para os hipocentros
    
    for i = 1:num_sol
        % Se você quiser usar diferentes marcadores, ajuste 'o' para o marcador desejado
        plot3(ssh(:, col_idx), ssh(:, col_idx + 1), ssh(:, col_idx + 2), 'kpentagram', ...
            'MarkerFaceColor', colors(i, :), 'MarkerSize', 10, 'DisplayName', ['Hipocentro Estimado ' num2str(i)]);
        
        col_idx = col_idx + 3;
    end    
    
    plot3(s(:, 1), s(:, 2), s(:, 3), 'kpentagram', 'MarkerFaceColor', 'black', 'MarkerSize', 10, 'DisplayName','Hipocentro Real');
    
    title(['Hipocentro', hipo_names{j}], 'FontSize', 14, 'FontWeight', 'bold');
    xlabel('Coordenada X');
    ylabel('Coordenada Y');
    zlabel('Coordenada Z');
    
    hold off;
    grid on;
    
    % Adicione a legenda
    %legend('Location', 'northeast', 'FontSize', 12, 'FontWeight', 'bold', 'AutoUpdate', 'off');
end

% Defina o título principal da figura
sgtitle('Curva de nível com as soluções geradas pelo Multi-Start', 'FontSize', 16, 'FontWeight', 'bold');

