function t_temp = ray_tracing(s, cx, cy, cz, ns, v)

[xl, yl] = generate_s0_ray_tracing(s, cx, cy, cz, v);

xl_estimated = xl;

t_temp = zeros(1, ns);

fobj = @(x, y, s, st, v) sum(travel_time(x, y, s, st, v));

for k=1:ns
    st = [cx(k), cy(k), cz(k)];
    
    s0 = xl(k, :);
    
    lb = s0*0.7;
    
    ub = s0*1.3;
    
    nVar = numel(s0);
    
    wolvesNo = 100; % Número de Lobos
    maxIter = 100; %% Número de Iterações
    
    [~, x_estimated] = GWO_rt(fobj, yl(k, :), s, st, v, nVar, lb, ub, maxIter, wolvesNo);
    
    xl_estimated(k, :) = x_estimated;
    
    tt = travel_time(x_estimated, yl, s, st, v);
    
    t_temp(k) = tt;
end

end  
     
