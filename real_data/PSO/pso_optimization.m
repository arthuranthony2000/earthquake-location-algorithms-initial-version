function [fss, ssf, fmss, mss, ssh] = pso_optimization(fobj, tobs, num_sol, itermax, cx, cy, cz, v)

rng('shuffle');  % Isso define a semente aleatória com base no relógio do sistema

ns = numel(cx);

% ga params

nvars = 3;

lb = [min(cx), min(cy), -10];

ub = [max(cx), max(cy), -3];

w_max = 0.9;  % Valor máximo para o fator de inércia

w_min = 0.4;  % Valor mínimo para o fator de inércia

c1 = 2;

c2 = 2;

epoch = 100;

limiar = 1e-18;

popsize = 100;

%

ssf = zeros(num_sol, 3);

fss = zeros(num_sol, itermax);

ssh = zeros(itermax, 3 * (num_sol));

col_idx = 1; % Índice da próxima coluna em ssh

for i = 1:num_sol
    [f, s_estimated, h_estimated] = PSO(fobj, nvars, lb, ub, itermax, popsize, c1, c2, limiar, epoch, w_max, w_min, tobs, cx, cy, cz, ns, v);

    ssf(i, :) = s_estimated;
    fss(i, :) = f;
    
    ssh(:, col_idx:col_idx+2) = h_estimated;
    
    col_idx = col_idx + 3;
end

mss = mean(ssf(:, 1:size(ssf, 2)));
fmss = fobj(mss, tobs, cx, cy, cz, ns, v);

end




