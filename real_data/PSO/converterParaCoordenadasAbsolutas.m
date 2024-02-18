% Entrada em Graus
function [latitude, longitude] = converterParaCoordenadasAbsolutas(x, y)
    x0 = -35.9;
    y0 = -5.7;
    
    latitude = (x + 111*x0)/111;
    longitude = (y + 111*y0)/111;
end