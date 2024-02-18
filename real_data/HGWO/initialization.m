function positions = initialization(wolvesNo, nVar , ub, lb)

boundaryNo = size(ub , 2);

  if boundaryNo == 1
      positions = rand(wolvesNo, nVar) .* (ub-lb) + lb;
  else % more than one boundary
      for i = 1 : wolvesNo % for each wolf
          for j = 1 : nVar % for each variable (dimension)
              ub_j = ub(j);
              lb_j = lb(j);
              positions(i,j) = rand() * (ub_j-lb_j) + lb_j;
          end
      end
  end

end
