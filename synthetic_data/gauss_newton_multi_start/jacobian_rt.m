function J = jacobian_rt(xl, s, st, v)
% Inicializar matriz jacobiana

%J = zeros(1, size(v, 1)-1);

% Tempo de percurso da onda sísmica do hipocentro para a estação st
tt = 0;

d = @(x, x0, y, y0, z, z0) ((x - x0)^2 + (y - y0)^2 + (z - z0)^2)^0.5; % Calcular distância euclidiana

% Coordenada da estação
xe = st(1);
ye = st(2);
ze = st(3);

% Coordenada do hipocentro
xh = s(1);
yh = s(2);
zh = s(3);

rxy = sqrt((xe-xh)^2 + (ye-yh)^2);

% Ângulo formado pela reta que liga o hipocentro e a estação
theta = acos(abs(xe-xh)/rxy);

% Matriz de rotação
M = [cos(theta), sin(theta), 0; -sin(theta), cos(theta), 0; 0, 0, 1];

% Coordenadas das estações após a rotação
ctk = M*[xe, ye, ze]';

% Coordenadas do hipocentro após a rotação
cth = M*[xh, yh, zh]';

% Atualização das coordenadas após rotação
xe = ctk(1);
ye = ctk(2);
ze = ctk(3);

xh = cth(1);
yh = cth(2);
zh = cth(3);

% Atribuição das coordenadas de referência para os cálculos de
% tempo de percurso

x_base = xe;
y_base = ye;
z_base = ze;

y_layer = yh;

for j = 1:size(v, 1)
    if j < size(v, 1)
        x_layer = xl(1, j);   
        z_layer = v(j, 1);
    else
        x_layer = xh;
        z_layer = s(3);
    end
    
    if j+1 > size(v, 1)
        tt = tt + d(xh, x_base, yh, y_base, zh, z_base) / v(j, 2);
    else
        if zh > v(j+1, 1) && v(j+1, 1) ~= -Inf
            tt = tt + d(xh, x_base, yh, y_base, zh, z_base) / v(j, 2);
            break;
        else
            ttx = tt + d(x_layer*1.1, x_base, y_layer, y_base, z_layer, z_base) / v(j, 2);
            
            tt = tt + d(x_layer, x_base, y_layer, y_base, z_layer, z_base) / v(j, 2);
            
            J(j) = (ttx - tt) / 0.1 * x_layer;
        end
    end
    
    x_base = x_layer;
    y_base = y_layer;
    z_base = z_layer;
end
end