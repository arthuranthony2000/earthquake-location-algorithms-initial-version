function [f, s_estimated, h_estimated] = HybridGWO(fobj, tobs, nVar, lb, ub, maxIter, wolvesNo, cx, cy, cz, ns, v, cross_constant, mutation_constant, sigma, tournament_size)
t = 0; % Contador de iterações

alpha_pos = zeros(1, nVar);
alpha_score = inf;

beta_pos = zeros(1, nVar);
beta_score = inf;

delta_pos = zeros(1, nVar);
delta_score = inf;

nchildrens = round(cross_constant * wolvesNo / 2) * 2;

f = zeros(1, maxIter);

h_estimated = zeros(maxIter, nVar);

% Inicializar a primeira população de lobos cinzentos
positions = initialization(wolvesNo, nVar, ub, lb);
positions_score = zeros(wolvesNo, 1);

while t < maxIter
    % Calcular os custos e as posições do alpha, beta, e delta
    for i = 1:wolvesNo % for each wolf
        % Ajustar os parâmetros dos lobos por meio dos limites impostos
        Flag4ub = positions(i, :) > ub;
        Flag4lb = positions(i, :) < lb;
        positions(i, :) = (positions(i, :) .* (~(Flag4ub + Flag4lb))) + ub .* Flag4ub + lb .* Flag4lb;
        
        % Calcular o custo das posições por meio da função objetivo
        fitness = fobj(positions(i, :), tobs, cx, cy, cz, ns, v);
        
        % Atualizar alpha, beta, e delta
        if fitness < alpha_score
            alpha_pos = positions(i, :);
            alpha_score = fitness;
        end
        
        if fitness < beta_score
            beta_pos = positions(i, :);
            beta_score = fitness;
        end
        
        if fitness < delta_score
            delta_pos = positions(i, :);
            delta_score = fitness;
        end
    end
    
    % Atualizar posição dos lobos
    a = 2 - t * ((2)/maxIter); % 'a' decresce linearmente de 2 para 0
    
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
            positions(i, j) = (X1 + X2 + X3) / 3;
        end
        
        positions_score(i) = fobj(positions(i, :), tobs, cx, cy, cz, ns, v); 
    end
    
    % Cruzamento
    pop_childrens_Solution = zeros(nchildrens, nVar);
    
    pop_childrens_Score = zeros(nchildrens, 1);
    
    k1 = 1;
    k2 = 2;
    for c = 1:nchildrens/2
        random_index_parent = randperm(wolvesNo);
        parent_1 = positions(random_index_parent(1), :);
        parent_2 = positions(random_index_parent(2), :);
        
        [pop_childrens_Solution(k1, :), pop_childrens_Solution(k2, :)] = CrossOver(parent_1, parent_2);
        k1 = k2 + 1;
        k2 = k1 + 1;
    end
    
    % Mutação
    for m = 1:nchildrens
        pop_childrens_Solution(m, :) = Mutation(pop_childrens_Solution(m, :), mutation_constant, sigma); 
        
        pop_childrens_Score(m) = fobj(pop_childrens_Solution(m, :), tobs, cx, cy, cz, ns, v);
        
        if pop_childrens_Score(m) < fobj(alpha_pos, tobs, cx, cy, cz, ns, v)
            alpha_pos = pop_childrens_Solution(m, :);
        end
    end
    
    % Seleção por torneio
    for i = 1:size(pop_childrens_Solution, 1)
        tournament_indices = randperm(nchildrens, tournament_size);
        tournament_scores = pop_childrens_Score(tournament_indices);
        [~, winner_index] = min(tournament_scores);
        winner_solution = pop_childrens_Solution(tournament_indices(winner_index), :);

        pop_childrens_Solution(i, :) = winner_solution;
    end
    
    elitism_pop = zeros(wolvesNo - size(pop_childrens_Solution, 1), nVar);

    % Ordena os índices dos escores
    [~, sorted_indices] = sort(positions_score);

    for i = 1:wolvesNo - size(pop_childrens_Solution, 1)
        elitism_pop(i, :) = positions(sorted_indices(i), :);
    end

    positions = [elitism_pop; pop_childrens_Solution];
    
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
    
    h_estimated(t, :) = alpha_pos;
    f(t) = alpha_score;
end

s_estimated = alpha_pos;
end

