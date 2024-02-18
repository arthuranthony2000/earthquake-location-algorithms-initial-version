function filtered_solutions = filter_solutions(solutions)
    [rows, columns] = find(solutions > 0.9);
    filtered_solutions = [rows, columns];
end