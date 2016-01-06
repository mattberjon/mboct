function [param good_ans_perc] = ComputePsychFunc(data, answer_comp)
% function [param good_ans_perc] = ComputePsychFunc(data, answer_comp)
% compute the psychometric function for one parameter based on a 2AFC. The
% parameters has to be the first the first column, the answer on the second
% column.

  [b, id] = sort(data(:, 1));
  data_sort = data(id, :);

  % for each speed, we count the number of trials
  param = unique(data_sort(:, 1));
  for a = 1:length(param)
    nb_trials_per_param = length(find(data_sort(:, 1) == param(a)));
    ids = find(data_sort(:, 1) == param(a));
    good_ans_perc(a) = length(find(data_sort(ids, 2) == answer_comp)) ...
      * 100 / nb_trials_per_param;
  end

%  plot(speeds, right_left_ans_perc)
end % end function
