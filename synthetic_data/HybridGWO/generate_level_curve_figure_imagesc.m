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

for j = 1:num_hipocentros
    figure(j)
    
    load(strcat('s_', string(j)));
    load(strcat('ssf_', string(j)));
    load(strcat('tobs_', string(j)));
    
    [x, y] = meshgrid(1:20, 1:20);
    z = zeros(size(x));
    
    for i = 1:numel(x)
        s_test = [x(i), y(i), s(3)];
        z(i) = fobj(s_test, tobs, cx, cy, cz, ns, v);
    end
    
    % Crie o gráfico usando imagesc
    imagesc(x(1, :), y(:, 1), z);
    axis xy; % Inverte a direção do eixo y para corresponder ao sistema cartesiano
    
    colormap('jet'); % Escolha um mapa de cores (opcional)
    colorbar; % Adicione uma barra de cores (opcional)
    
    title(strcat('Hipocentro', hipo_names(j)), 'FontSize', 14, 'FontWeight', 'bold');
    xlabel('Coordenada X');
    ylabel('Coordenada Y');
    
    grid on;
end
