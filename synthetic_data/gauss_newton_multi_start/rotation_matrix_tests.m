clc
clear all
close all

load('s_1');
load('tobs_1');
load('cx_1');
load('cy_1');
load('cz_1');
load('v_1');

ns = size(cx, 1);

t2 = zeros(1, ns);

[xl, yl, zl] = generate_s0_ray_tracing(s, cx, cy, cz, v);

for k=1:ns
    st = [cx(k), cy(k), cz(k)];
    
    tt = travel_time(xl(k, :), yl(k, :), s, st, v);
    
    t2(k) = tt;
end

t1 = hypo_direct(s, cx, cy, cz, ns, v);
t3 = hypo_direct_ray_tracing(s, cx, cy, cz, ns, v);




