function plotScore(iterations_limit, vector_score_solutions, hipo_names, i)
  x = 1:iterations_limit;
  y = vector_score_solutions;  
  plot(x,y,"LineWidth",2, 'DisplayName',strcat('Hypocenter', " ", hipo_names(i)));
  xlabel('Iteration');
  ylabel('RMS');
end