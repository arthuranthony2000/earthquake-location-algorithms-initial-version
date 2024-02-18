function tt = travel_time(xl, yl, s, st, v)
% Tempo de percurso da onda sísmica do hipocentro para a estação st
tt = 0;

d = @(x, x0, y, y0, z, z0) ((x - x0)^2 + (y - y0)^2 + (z - z0)^2)^0.5; % Calcular distância euclidiana

% Coordenada da estação
xe = st(1) - s(1);
ye = st(2) - s(2);
ze = st(3) - s(3);

% Coordenada do hipocentro
xh = s(1);
yh = s(2);
zh = s(3);

rxy = sqrt((st(1)-s(1))^2 + (st(2)-s(2))^2);

% Ângulo formado pela reta que liga o hipocentro e a estação
theta = acos(abs(st(1)-s(1))/rxy);

% Matriz de rotação
M = [cos(theta), sin(theta), 0; -sin(theta), cos(theta), 0; 0, 0, 1];

% Coordenadas das estações após a rotaçãocosd(theta)
ctk = M*[xe, ye, ze]';

% Atualização das coordenadas após rotação
xe = ctk(1) + s(1);
ye = ctk(2) + s(2);
ze = ctk(3) + s(3);

% Atribuição das coordenadas de referência para os cálculos de
% tempo de percurso

x_base = xe;
y_base = ye;
z_base = ze;

%y_layer = yh;

for j = 1:size(v, 1)
    if j < size(v, 1)        
        z_layer = v(j, 1);
    else
        z_layer = zh;
    end
    
    x_layer = xl(1, j);    
    y_layer = yl(1, j);
    
    if j+1 > size(v, 1)
        tt = tt + d(xh, x_base, yh, y_base, zh, z_base) / v(j, 2);
    else
        if zh > v(j+1, 1) && v(j+1, 1) ~= -Inf
            tt = tt + d(xh, x_base, yh, y_base, zh, z_base) / v(j, 2);
            break;
        else
            tt = tt + d(x_layer, x_base, y_layer, y_base, z_layer, z_base) / v(j, 2);
        end
    end
    
    x_base = x_layer;
    y_base = y_layer;
    z_base = z_layer;
end
end

