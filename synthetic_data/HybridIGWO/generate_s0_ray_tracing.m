function [xl, yl, zl] = generate_s0_ray_tracing(s, cx, cy, cz, v)
ns = size(cx, 1);

xl = zeros(numel(cx), size(v, 1));
yl = zeros(numel(cx), size(v, 1));
zl = zeros(numel(cx), size(v, 1));

f_vd = @(xe, xh, ye, yh, ze, zh) [xe-xh, ye-yh, ze-zh]; % Descobrir vetor diretor
f_lambda = @(z, zh, zv) (z - zh) / zv; % Descobrir Lambda
g = @(xh, xv, lambda) xh + xv * lambda; % Descobrir coordenada x da interface
f = @(yh, yv, lambda) yh + yv * lambda; % Descobrir coordenada y da interface

for k = 1:ns
    
    xh = s(1);
    yh = s(2);
    zh = s(3);
    
    rxy = sqrt((cx(k)-s(1))^2 + (cy(k)-s(2))^2);
    
    % Ângulo formado pela reta que liga o hipocentro e a estação
    theta = acos((abs(cx(k)-s(1))/rxy));
    
    % Matriz de rotação
    M = [cos(theta), sin(theta), 0; -sin(theta), cos(theta), 0; 0, 0, 1];
    
    % Atribuição das coordenadas de referência para os cálculos de
    % tempo de percurso
    
    v_d = f_vd(cx(k), s(1), cy(k), s(2), cz(k), s(3));
    
    for j = 1:size(v, 1)
        if j < size(v, 1)
            z_layer = v(j, 1);
        else
            z_layer = zh;
        end
        
        lambda = f_lambda(z_layer, zh, v_d(1, 3));
        x_layer = g(xh, v_d(1, 1), lambda);
        y_layer = f(yh, v_d(1, 2), lambda);
        
        if x_layer ~= xh || y_layer ~= yh || z_layer ~= zh
            x_layer = x_layer - s(1);
            y_layer = y_layer - s(2);
            z_layer = z_layer - s(3);
            
            aux = [x_layer, y_layer, z_layer];
            
            aux = M*aux';
            
            x_layer = aux(1) + s(1);
            y_layer = aux(2) + s(2);
        end
        
        xl(k, j) = x_layer;
        yl(k, j) = y_layer;
        zl(k, j) = z_layer;
        
        if j+1 <= size(v, 1) && zh > v(j+1, 1) && v(j+1, 1) ~= -Inf
            break;
        end
    end
end

%xl = xl(:, 1:size(xl, 2)-1);

end