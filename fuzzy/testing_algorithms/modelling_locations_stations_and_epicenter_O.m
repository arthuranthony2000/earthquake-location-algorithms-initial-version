clc
clear all
close all

% Definir o tamanho da nova grade e o número de estações
gridSize = 20;
numStations = 7;

% Criar matriz de coordenadas para a nova grade
[X, Y] = meshgrid(1:gridSize, 1:gridSize);

% Localização do epicentro
epicenterLocation = [10 10];

% Inicializar a figura
figure;
hold on;

% Plotar a nova grade
plot(X, Y, 'k.');

% Adicionar letra "O" (epicentro)
text(epicenterLocation(1), epicenterLocation(2), 'O', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', 'FontSize', 12, 'FontWeight', 'bold');

% Distribuir as estações aleatoriamente abaixo do epicentro
stationYValues = randi([1, epicenterLocation(2)-1], numStations, 1);

for i = 1:numStations
    stationX = randi([1, gridSize]);
    stationY = stationYValues(i);
    
    % Adicionar estação
    text(stationX, stationY, ['S' num2str(i)], 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', 'FontSize', 8, 'FontWeight', 'bold');
    
    % Adicionar linha entre estação e epicentro
    line([stationX, epicenterLocation(1)], [stationY, epicenterLocation(2)], 'Color', 'k');
end

% Configurar eixos
axis equal;
xlim([1 gridSize]);
ylim([1 gridSize]);
title('Malha 20x20');
xlabel('Latitude');
ylabel('Longitude');

% Adicionar grade de células
grid on;

% Mostrar a nova malha
hold off;


