function t = hypo_direct(s, cx, cy, cz, ns, v)
    t_temp = zeros(1, ns);

    f_vd = @(xe, xh, ye, yh, ze, zh) [xe-xh, ye-yh, ze-zh]; % Descobrir vetor diretor
    f_lambda = @(z, zh, zv) (z - zh) / zv; % Descobrir Lambda
    g = @(xh, xv, lambda) xh + xv * lambda; % Descobrir coordenada x da interface
    f = @(yh, yv, lambda) yh + yv * lambda; % Descobrir coordenada y da interface
    d = @(x, x0, y, y0, z, z0) ((x - x0)^2 + (y - y0)^2 + (z - z0)^2)^0.5; % Calcular distância euclidiana

    for k = 1:ns
        tt = 0;

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
        t_temp(k) = tt;
    end
    t = t_temp;
end
