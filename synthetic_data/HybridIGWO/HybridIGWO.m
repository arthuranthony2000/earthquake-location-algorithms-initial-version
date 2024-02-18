function [f, s_estimated, h_estimated] = HybridIGWO(fobj, tobs, nVar, lb, ub, maxIter, wolvesNo, cx, cy, cz, ns, v, cross_constant, mutation_constant, sigma, tournament_size)
lu = [lb .* ones(1, nVar); ub .* ones(1, nVar)];
s_estimated=zeros(1,nVar);
h_estimated = zeros(maxIter, nVar);
alpha_score=inf; 
Beta_pos=zeros(1,nVar);
Beta_score=inf; 
Delta_pos=zeros(1,nVar);
Delta_score=inf; 
positions=initialization(wolvesNo,nVar,ub,lb);
positions = boundConstraint(positions, positions, lu);
Fit = zeros(1, size(positions,1));
nchildrens = round(cross_constant * wolvesNo / 2) * 2;

for i=1:size(positions,1)
    Fit(i) = fobj(positions(i,:), tobs, cx, cy, cz, ns, v);
end

pBestScore = Fit;
pBest = positions;
neighbor = zeros(wolvesNo,wolvesNo);
f=zeros(1,maxIter);
iter = 0;

while iter < maxIter
    % Calcular os custos e as posições do alpha, beta, e delta
    for i=1:size(positions,1)
        fitness = Fit(i);
        
        % Update Alpha, Beta, and Delta
        if fitness<alpha_score
            alpha_score=fitness; % Update alpha
            s_estimated=positions(i,:);
        end
        
        if fitness>alpha_score && fitness<Beta_score
            Beta_score=fitness; % Update beta
            Beta_pos=positions(i,:);
        end
        
        if fitness>alpha_score && fitness>Beta_score && fitness<Delta_score
            Delta_score=fitness; % Update delta
            Delta_pos=positions(i,:);
        end
    end
    
    % Calculate the candiadate position Xi-GWO
    a=2-iter*((2)/maxIter); % a decreases linearly from 2 to 0
    
    X_GWO = zeros(size(positions,1), size(positions,2));
    Fit_GWO = zeros(1, size(positions,1));
    
    % Update the Position of search agents including omegas
    for i=1:size(positions,1)
        for j=1:size(positions,2)
            
            r1=rand(); 
            r2=rand(); 
            
            A1=2*a*r1-a;                                    
            C1=2*r2;                                        
            
            D_alpha=abs(C1*s_estimated(j)-positions(i,j));    
            X1=s_estimated(j)-A1*D_alpha;                     
            
            r1=rand();
            r2=rand();
            
            A2=2*a*r1-a;                                    
            C2=2*r2;                                        
            
            D_beta=abs(C2*Beta_pos(j)-positions(i,j));     
            X2=Beta_pos(j)-A2*D_beta;                       
            
            r1=rand();
            r2=rand();
            
            A3=2*a*r1-a;                                    
            C3=2*r2;                                        
            
            D_delta=abs(C3*Delta_pos(j)-positions(i,j));   
            X3=Delta_pos(j)-A3*D_delta;                    
            
            X_GWO(i,j)=(X1+X2+X3)/3;                        
            
        end
        X_GWO(i,:) = boundConstraint(X_GWO(i,:), positions(i,:), lu);
        Fit_GWO(i) = fobj(X_GWO(i,:), tobs, cx, cy, cz, ns, v);
    end
    
    radius = pdist2(positions, X_GWO, 'euclidean');         
    dist_Position = squareform(pdist(positions));
    r1 = randperm(wolvesNo,wolvesNo);
    
    X_DLH = zeros(wolvesNo, nVar);
    Fit_DLH = zeros(1, wolvesNo);
    
    for t=1:wolvesNo
        neighbor(t,:) = (dist_Position(t,:)<=radius(t,t));
        [~,Idx] = find(neighbor(t,:)==1);                                
        random_Idx_neighbor = randi(size(Idx,2),1,nVar);
        
        for d=1:nVar
            X_DLH(t,d) = positions(t,d) + rand .*(positions(Idx(random_Idx_neighbor(d)),d)...
                - positions(r1(t),d));                      
        end
        X_DLH(t,:) = boundConstraint(X_DLH(t,:), positions(t,:), lu);
        Fit_DLH(t) = fobj(X_GWO(i,:), tobs, cx, cy, cz, ns, v);
    end
    
    % Selection  
    tmp = Fit_GWO < Fit_DLH;                                
    tmp_rep = repmat(tmp',1,nVar);
    
    tmpFit = tmp .* Fit_GWO + (1-tmp) .* Fit_DLH;
    tmppositions = tmp_rep .* X_GWO + (1-tmp_rep) .* X_DLH;
    
    % Updating
    tmp = pBestScore <= tmpFit;                             
    tmp_rep = repmat(tmp',1,nVar);
    
    pBestScore = tmp .* pBestScore + (1-tmp) .* tmpFit;
    pBest = tmp_rep .* pBest + (1-tmp_rep) .* tmppositions;
    
    Fit = pBestScore;
    positions = pBest;
    
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
        
        if pop_childrens_Score(m) < fobj(s_estimated, tobs, cx, cy, cz, ns, v)
            s_estimated = pop_childrens_Solution(m, :);
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
    [~, sorted_indices] = sort(Fit);

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
    
    iter = iter + 1;
    neighbor = zeros(wolvesNo,wolvesNo);
    h_estimated(iter, :) = s_estimated;
    f(iter) = alpha_score;
end
end