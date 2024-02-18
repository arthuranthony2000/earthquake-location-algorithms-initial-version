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
    
    sgtitle(strcat('Hipocentro', hipo_names(j)), 'FontSize', 14, 'FontWeight', 'bold');
    
    for k = 1:3
        subplot(1, 3, k);
        
        z = zeros(1, size(ssf, 1));
        err = zeros(1, size(ssf, 1)); % Inicialize a matriz de barras de erro
        
        for i = 1:size(ssf, 1)
            s_test = [ssf(i, 1), ssf(i, 2), ssf(i, 3)];
            z(i) = fobj(s_test, tobs, cx, cy, cz, ns, v);
            err(i) = std(tobs - hypo_direct(s_test, cx, cy, cz, ns, v));
        end

        % Crie o gráfico de barras com barras de erro
        errorbar(ssf(:, k), z(:), err(:));
        xlabel(['Coordenada', rotulos{k}]);
        ylabel('Erro');

        grid on;
    end
end

