clc
clear all
close all

load('s_1');
load('tobs_1');
load('cx_1');
load('cy_1');
load('cz_1');
load('v_1');

ns = size(cx, 2);

xl = generate_s0_ray_tracing(s, cx, cy, cz, v);

fobj = @(x, s, st, v) sum(travel_time(x, s, st, v));

%% Teste para apenas uma estação

k = 1;

s0 = xl(k, :);

st = [cx(k), cy(k), cz(k)];

dcalc = fobj(s0, s, st, v);

for i=1:10  
    J = jacobian_rt(s0, s, st, v);
    
    dt = 1;
    
    deltam=(inv(J'*J))*(J'*dt');
    
    s0 = s0 + deltam';
    
    dcalc = fobj(s0, s, st, v);  
end

disp("Solução Inicial, " + fobj(xl(k, :), s, st, v))

disp("Solução Final, " + fobj(s0, s, st, v))





