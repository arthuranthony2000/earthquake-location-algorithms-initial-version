function [fss, ssf, fmss, mss, ssh] = gwo_optimization(fobj, tobs, num_sol, itermax, cx, cy, cz, v)

rng('shuffle');  % Isso define a semente aleatória com base no relógio do sistema

ns = numel(cx);

% gwo params

lb = [1, 1, -10];

ub = [20, 17, -5];

nVar = 3;

wolvesNo = 100;

maxIter = 10;

%

ssf = zeros(num_sol, 3);

fss = zeros(num_sol, itermax);

ssh = zeros(itermax, 3 * (num_sol));

col_idx = 1; % Índice da próxima coluna em ssh

for i = 1:num_sol
    [f, s_estimated, h_estimated] = IGWO(fobj, tobs, nVar, lb, ub, maxIter, wolvesNo, cx, cy, cz, ns, v);
    
    ssf(i, :) = s_estimated;
    fss(i, :) = f;
    
    ssh(:, col_idx:col_idx+2) = h_estimated;
    
    col_idx = col_idx + 3;
end

mss = mean(ssf(:, 1:size(ssf, 2)));
fmss = fobj(mss, tobs, cx, cy, cz, ns, v);

end




