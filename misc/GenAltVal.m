function [res] = GenAltVal(cols, rows, order)
% function [res] = GenAltVal(cols, rows)

  halfn = floor(rows * .5);
  
  if order == 1
    res = [ones(1, cols * halfn); -ones(1, cols * halfn)];
  else
    res = [-ones(1, cols * halfn); ones(1, cols * halfn)];
  end
  
  res = reshape(res, 2 * halfn, cols);

  if mod(rows, 2) == 1
      res = [res; ones(1, cols)];
  end
end