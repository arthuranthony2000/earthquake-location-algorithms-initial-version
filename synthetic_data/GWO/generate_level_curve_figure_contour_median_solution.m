clc
clear all
close all

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

% Configurar a legenda apenas uma vez fora do loop
legend('Location', 'northeast', 'FontSize', 12, 'FontWeight', 'bold', 'AutoUpdate', 'off');

for j = 1:num_hipocentros
    figure(j)
    
    load(strcat('s_', string(j)));
    load(strcat('ssf_', string(j)));
    load(strcat('mss_', string(j)));
    load(strcat('tobs_', string(j)));
    
    [x, y] = meshgrid(1:20, 1:20);
    z = zeros(size(x));
    
    for i = 1:numel(x)
        s_test = [x(i), y(i), s(3)];
        z(i) = fobj(s_test, tobs, cx, cy, cz, ns, v);
    end
    
    % Crie o gráfico de contorno
    contour(x, y, z, 'DisplayName','Espaço de Busca');
    
    hold on;
    
    % Plote todos os pontos de ssf na curva de nível
    plot3(mss(:, 1), mss(:, 2), mss(:, 3), 'rpentagram', 'MarkerFaceColor', 'red', 'MarkerSize', 10, 'DisplayName','Hipocentro Estimado');
    
    plot3(s(:, 1), s(:, 2), s(:, 3), 'kpentagram', 'MarkerFaceColor', 'black', 'MarkerSize', 10, 'DisplayName','Hipocentro Real');
    
    title(strcat('Hipocentro', hipo_names(j)), 'FontSize', 14, 'FontWeight', 'bold');
    xlabel('Coordenada X');
    ylabel('Coordenada Y');
    zlabel('Coordenada Z'); % Adicione um rótulo para o eixo Z
    
    hold off;
    grid on;
end



