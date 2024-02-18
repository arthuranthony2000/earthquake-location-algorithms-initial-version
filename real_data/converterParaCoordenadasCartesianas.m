% Entrada em Graus
function [x, y] = converterParaCoordenadasCartesianas(latitude, longitude)
    x0 = -35.9;
    y0 = -5.7;
    
    x = (latitude - x0) * 111;
    y = (longitude - y0) * 111;
end