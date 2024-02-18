function J = jacobian(s, cx, cy, cz, ns, v)
% Inicializar Matrizes Jacobianas
Jx = zeros(ns, size(v, 1));
Jy = zeros(ns, size(v, 1));
Jz = zeros(ns, size(v, 1));

f_vd = @(xe, xh, ye, yh, ze, zh) [xe-xh, ye-yh, ze-zh]; % Descobrir Vetor Diretor
f_lambda = @(z, zh, zv) (z - zh) / zv; % Descobrir Lambda
g = @(xh, xv, lambda) xh + xv * lambda; % Descobrir componente X
f = @(yh, yv, lambda) yh + yv * lambda; % Descobrir componente Y
d = @(x, x0, y, y0, z, z0) ((x - x0)^2 + (y - y0)^2 + (z - z0)^2)^0.5; % Calcular Distância Euclidiana

for k = 1:ns
    tt = 0;
    ttx = 0;
    tty = 0;
    ttz = 0;
    
    xe = cx(k);
    ye = cy(k);
    ze = cz(k);
    
    x_base = xe;
    y_base = ye;
    z_base = ze;
    
    xh = s(1);
    yh = s(2);
    zh = s(3);
    
    v_d = f_vd(xe, xh, ye, yh, ze, zh);
    
    for j = 1:size(v, 1)
        
        if j < size(v, 1)
            z_layer = v(j, 1);
        else
            z_layer = zh;
        end
        
        lambda = f_lambda(z_layer, zh, v_d(1, 3));
        x_layer = g(xh, v_d(1, 1), lambda);
        y_layer = f(yh, v_d(1, 2), lambda);
        
        if j+1 > size(v, 1)
            tt = tt + d(xh, x_base, yh, y_base, zh, z_base) / v(j, 2);
            ttx = ttx + d(xh*1.1, x_base, yh, y_base, zh, z_base) / v(j, 2);
            
            Jx(k, j) = (ttx - tt) / (0.1 * s(1));
            
            tty = tty + d(xh, x_base, yh*1.1, y_base, zh, z_base) / v(j, 2);
            
            Jy(k, j) = (tty - tt) / (0.1 * s(2));
            
            ttz = ttz + d(xh, x_base, yh, y_base, zh*1.1, z_base) / v(j, 2);
            
            Jz(k, j) = (ttz - tt) / (0.1 * s(3));            
        else
            if zh > v(j+1, 1) && v(j+1, 1) ~= -Inf
                tt = tt + d(xh, x_base, yh, y_base, zh, z_base) / v(j, 2);
                
                ttx = ttx + d(xh*1.1, x_base, yh, y_base, zh, z_base) / v(j, 2);
                
                Jx(k, j) = (ttx - tt) / (0.1 * s(1));
                
                tty = tty + d(xh, x_base, yh*1.1, y_base, zh, z_base) / v(j, 2);
                
                Jy(k, j) = (tty - tt) / (0.1 * s(2));
                
                ttz = ttz + d(xh, x_base, yh, y_base, zh*1.1, z_base) / v(j, 2);
                
                Jz(k, j) = (ttz - tt) / (0.1 * s(3));   
                break;
            else
                tt = tt + d(x_layer, x_base, y_layer, y_base, z_layer, z_base) / v(j, 2);
                
                ttx = ttx + d(x_layer*1.1, x_base, y_layer, y_base, z_layer, z_base) / v(j, 2);
                
                Jx(k, j) = (ttx - tt) / (0.1 * s(1));
                
                tty = tty + d(x_layer, x_base, y_layer*1.1, y_base, z_layer, z_base) / v(j, 2);
                
                Jy(k, j) = (tty - tt) / (0.1 * s(2));
                
                ttz = ttz + d(x_layer, x_base, y_layer, y_base, z_layer*1.1, z_base) / v(j, 2);
                
                Jz(k, j) = (ttz - tt) / (0.1 * s(3));  
            end
        end
        
        x_base = x_layer;
        y_base = y_layer;
        z_base = z_layer;
    end
    
    Jx = sum(Jx, 2);
    Jy = sum(Jy, 2);
    Jz = sum(Jz, 2);
    
    % Definição da Matriz Jacobiana Principal
    J = [Jx Jy Jz];
end
end


