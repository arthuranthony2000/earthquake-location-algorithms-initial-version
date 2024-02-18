function [fss, ssf, fmss, mss, ssh] = ga_optimization(fobj, tobs, num_sol, itermax, cx, cy, cz, v)

rng('shuffle');  % Isso define a semente aleatória com base no relógio do sistema

ns = numel(cx);

% ga params

nvars = 3;

popsize = 100;

lb = [1, 1, -10];

ub = [20, 17, -5];

cross_constant = 0.75;

mutation_constant = 0.01;

sigma = 0.1;

tournament_size = 3;

%

ssf = zeros(num_sol, 3);

fss = zeros(num_sol, itermax);

ssh = zeros(itermax, 3 * (num_sol));

col_idx = 1; % Índice da próxima coluna em ssh

for i = 1:num_sol
    [f, s_estimated, h_estimated] = GA(fobj, nvars, lb, ub, cross_constant, mutation_constant, sigma, tournament_size, popsize, itermax, tobs, cx, cy, cz, ns, v);
    ssf(i, :) = s_estimated;
    fss(i, :) = f;
    
    ssh(:, col_idx:col_idx+2) = h_estimated;
    
    col_idx = col_idx + 3;
end

mss = mean(ssf(:, 1:size(ssf, 2)));
fmss = fobj(mss, tobs, cx, cy, cz, ns, v);

end




