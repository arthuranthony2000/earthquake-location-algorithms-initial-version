function [f, s_estimated, h_estimated] = GA(fobj, nvars, lb, ub, cross_constant, mutation_constant, sigma, tournament_size, popsize, niterations, tobs, cx, cy, cz, ns, v)
% Modelo de indivíduo
default_individual.Solution = [];
default_individual.Score = [];
nvars = [1 nvars];

f = zeros(1, niterations);

% Inicializar população com valores vazios e calcular o número de filhos
population = repmat(default_individual, popsize, 1);
nchildrens = round(cross_constant * popsize / 2) * 2;

% Inicializar o melhor indivíduo
better_individual.Solution = [];
better_individual.Score = inf;

h_estimated = zeros(niterations, 3);

% Criar população
for i = 1:popsize
    population(i).Solution = unifrnd(lb, ub, nvars);
    population(i).Score = fobj(population(i).Solution, tobs, cx, cy, cz, ns, v);
    
    if population(i).Score < better_individual.Score
        better_individual = population(i);
    end
end

for it = 1:niterations
    % Seleção por torneio
    new_population = repmat(default_individual, popsize, 1);
    for i = 1:popsize
        tournament_indices = randperm(popsize, tournament_size);
        [~, winner_index] = min([population(tournament_indices).Score]);
        new_population(i) = population(tournament_indices(winner_index));
    end
    
    % Cruzamento
    pop_childrens = repmat(default_individual, nchildrens / 2, 2);
    for c = 1:nchildrens/2
        random_index_parent = randperm(popsize);
        parent_1 = new_population(random_index_parent(1));
        parent_2 = new_population(random_index_parent(2));
        
        [pop_childrens(c, 1).Solution, pop_childrens(c, 2).Solution] = ...
            CrossOver(parent_1.Solution, parent_2.Solution);
    end
    pop_childrens = pop_childrens(:);
    
    % Mutação
    for m = 1:nchildrens
        pop_childrens(m).Solution = Mutation(pop_childrens(m).Solution, mutation_constant, sigma);
        
        pop_childrens(m).Score = fobj(pop_childrens(m).Solution, tobs, cx, cy, cz, ns, v);
        
        if pop_childrens(m).Score < better_individual.Score
            better_individual = pop_childrens(m);
        end
    end
    
    population = new_population;
    
    h_estimated(it, :) = better_individual.Solution;
    
    f(it) = fobj(better_individual.Solution, tobs, cx, cy, cz, ns, v);
end

s_estimated = better_individual.Solution;
end


