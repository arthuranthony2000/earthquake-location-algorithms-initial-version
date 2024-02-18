function [out, s] = GWO(fobj, tobs, nVar, lb, ub, maxIter, wolvesNo, cx, cy, cz, ns, v)

t = 0; % iteration counter

alpha_pos = zeros(1,nVar);
alpha_score = inf;

beta_pos = zeros(1,nVar);
beta_score = inf;

delta_pos = zeros(1,nVar);
delta_score = inf;

out = zeros(1, maxIter);

% Initialize the first population of grey wolves
positions = initialization(wolvesNo, nVar , ub, lb);

while t < maxIter
    % Calculate objectives and calculate alpha, beta, and delta
    for i = 1 : wolvesNo  %for each wolf
        
        % Return back the search agents that go beyond the boundaries of the search space
        Flag4ub=positions(i,:)>ub;
        Flag4lb=positions(i,:)<lb;
        positions(i,:)=(positions(i,:).*(~(Flag4ub+Flag4lb)))+ub.*Flag4ub+lb.*Flag4lb;
        
        % Calculate the objective values
        fitness  = fobj(positions(i,:), tobs, cx, cy, cz, ns, v);
        
        % Update alpha, beta, and delta
        if fitness < alpha_score
            alpha_pos = positions(i,:);
            alpha_score = fitness;
        end
        
        if fitness < beta_score
            beta_pos = positions(i,:);
            beta_score = fitness;
        end
        
        if fitness < delta_score
            delta_pos = positions(i,:);
            delta_score = fitness;
        end
    end
    
    % Update the position of wolves
    a = 2 - t * ((2)/maxIter); % 'a' decreases linearly fron 2 to 0
    
    for i = 1 : wolvesNo
        for j = 1 : nVar
            r1 = rand();
            r2 = rand();
            A = 2 * a * r1 - a;
            C = 2 * r2;
            D_alpha = abs(C * alpha_pos(j) - positions(i,j));
            X1 = alpha_pos(j) - A * D_alpha;
            
            r1 = rand();
            r2 = rand();
            A = 2 * a * r1 - a;
            C = 2 * r2;
            D_beta = abs(C * beta_pos(j) - positions(i,j));
            X2 = beta_pos(j) - A * D_beta;
            
            r1 = rand();
            r2 = rand();
            A = 2 * a * r1 - a;
            C = 2 * r2;
            D_delta = abs(C * delta_pos(j) - positions(i,j));
            X3 = delta_pos(j) - A * D_delta;
            positions(i,j) = (X1 + X2 + X3) / 3;
        end
    end
    
    % Check the boundary and update if necessary
    for i = 1 : wolvesNo  % For each wolf
        boundaryNo = size(ub , 2);
        if boundaryNo == 1
            lb_vec = lb .* ones (1,nVar);
            ub_vec = ub .* ones (1,nVar);
        else
            ub_vec = ub;
            lb_vec = lb;
        end
        
        for j = 1 : nVar
            if positions(i,j) > ub_vec(j)
                positions(i,j) =  ub_vec(j);
            end
            
            if positions(i,j) < lb_vec(j)
                positions(i,j) =  lb_vec(j);
            end
            
        end
    end
    
    t = t + 1;
    out(t) = alpha_score;
end

s = alpha_pos;
end

%% params function
% fobj
% tobs -> observed data
% cx -> x axis coordinates of seismic stations
% cy -> y axis coordinates of seismic stations
% cz -> z axis coordinates of seismic stations
% nVar -> number of params
% lb -> lower bound of params
% ub -> upper bound of params
% maxIter -> max iterations of algorithm


