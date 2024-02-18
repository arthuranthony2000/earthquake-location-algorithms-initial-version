function child_mutated = Mutation(child_original, mutation_constant, sigma)
    flag = (rand(size(child_original)) < mutation_constant);
    random_v = randn(size(child_original));
    child_mutated = child_original;
    child_mutated(flag) = child_original(flag) + sigma * random_v(flag);
end