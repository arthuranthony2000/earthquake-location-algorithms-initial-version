clc
clear all
close all

addpath('../');

fobj = @(s, tobs, st, v) 1/length(tobs) * norm(tobs - hypo_direct(s, st(:, 1), st(:, 2), st(:, 3), size(st(:, 1), 1), [-Inf, v]));

vp = 6.15;
vs = 3.55;

t = @(s, c, v) norm(s - c) / v;

fixed_z = -6;

event = [46, 53, -8];

st = [40, 33, 0;
    45, 50, 0;
    43, 52, 0;
    44, 55, 0;
    42, 50, 0;
    50, 51, 0
    52, 58, 0];

tobs_p = zeros(1, 7);
tobs_s = zeros(1, 7);

for i=1:7
    tobs_p(i) = t(st(i, :), event, vp);
    tobs_s(i) = t(st(i, :), event, vs);
end

tobs_p = tobs_p + 0.025*randn(size(tobs_p)) .* tobs_p;
tobs_s = tobs_s + 0.025*randn(size(tobs_s)) .* tobs_s;

save('tobs_p_inside', 'tobs_p');
save("-v7", "tobs_p_inside.mat", "tobs_p");

save('tobs_s_inside', 'tobs_s');
save("-v7", "tobs_s_inside.mat", "tobs_s");

save('st_inside', 'st');
save("-v7", "st_inside.mat", "st");

save('vp_inside', 'vp');
save("-v7", "vp_inside.mat", "vp");

save('vs_inside', 'vs');
save("-v7", "vs_inside.mat", "vs");

save('event_inside', 'event');
save("-v7", "event_inside.mat", "event");

