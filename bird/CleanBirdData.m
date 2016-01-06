function [clean_data] = CleanBirdData(calibration, conditions, bird, directions)

  % calibration transformation
  [calib_pos calib_ang] = BirdPosAng(calibration);
  clean_data.calib.pos = BirdConv('data', calib_pos, 'type', 'pos');
  clean_data.calib.ang = BirdConv('data', calib_ang);
  clean_data.calib.ang = ScaleAngles(clean_data.calib.ang);

  % then suppress redundancy in conditions in a temp var
  inc = 1;
  for a = 1:4:length(conditions)
    cond_temp(inc,:) = conditions(a,:);
    inc = inc + 1;
  end % end for length(conditions)
  clean_data.param = cond_temp;


  % pos/ang separation
  [raw_pos raw_ang] = arrayfun(@(raw_data) BirdPosAng(raw_data.trials), ...
                      bird, 'UniformOutput', false);

  % angular conversion
  [ang_conv] = cellfun(@(ang_conv) BirdConv('data', ang_conv), ...
                raw_ang, 'UniformOutput', false);

  % angular scaling [-180; 180]
  ang_scale = cellfun(@(ang_scale) ScaleAngles(ang_scale), ...
              ang_conv, 'UniformOutput', false);

  % compute the length of each cells
  cols_nb = cellfun(@(siz) size(siz, 1), ang_scale);

  % for each group of 4 trials we execute a bunch of functions

  % condition number
  condition_nb = 1;

  % find the min in the set
  for b = 1:4:length(bird)

    % find the minimum length
    min_length = min(cols_nb(b:b+3));

    % cutting of the trials
    for c = 0:3
      ang_cut(:,:,c+1) = ang_scale{b+c}(1:min_length, :);
    end % end c

    % corrections
%{    
    for d = 1:4
      ang_corr(:, d) = BirdCalib(clean_data.calib.ang, ang_cut(:,:, d));
    end % end for d
%}

    ang_corr = ang_cut(:, 1, :);
    % inversion of trials
    ang_corr(:, find(directions(b:b+3,1))) = ...
      ang_corr(:,find(directions(b:b+3,1) == 1)) .* (-1);

%{
    % create the x axis
    x_axis = [0:length(ang_corr)-1] ...
      .* cond_temp(1,4) / length(ang_corr);
    x_axis = repmat(x_axis, 4, 1);

    % plotting
    figure
    handle = plot(x_axis', ang_corr);
    main_title = ['ang: ' num2str(cond_temp(condition_nb,1)/2) ' - ' ...
      'time: ' num2str(cond_temp(condition_nb, 2))];
    main_legend = ['trial ' num2str(b); 'trial ' num2str(b+1); 'trial ' num2str(b+2); 'trial ' num2str(b+3)];
    title(main_title);
    xlabel('Time (seconds)');
    ylabel('Angle (degrees)');
    legend([handle], main_legend);

    % designation of the outliers (by input entry
    outliers = input("which trials are outliers? [vector] ", "s");
    clean_data(condition_nb).trials = ang_cut();
%}

    % condition incrementation
    condition_nb = condition_nb + 1;

    ang_end{condition_nb} = ang_corr;

%    print -djpg 'katerina.jpg'
%    print -dpdf 'katerina.pdf'
    clear ang_cut;
    close all;
  end % end for b

  % order
  [clean_data.param_ordered param_id] = sortrows(cond_temp);
  clean_data.bird = ang_end(param_id);

end % end function
