function [gains] = ComputeGains (impulse_responses, speakers_to_avoid)
% function [gains] = ComputeGains (impulse_responses, speakers_to_avoid)
%
% Compute gains according a matrix of impulse responses. It is possible to
% avoid some speakers during the computation.
%
% Input arguments
%
%     Compulsory argument are preceed by **.
%
% **  impulse_responses [matrix]
%       Matrix of impulse responses.
%
%     speakers_to_avoid [vector]
%       Speakers id that you don't want to use in the computation. In that
%       case, these speakers will be set at 0 (no sound).
%
% Output arguments
%
%     gains [vector]
%       Normalised gains.
%
%
% EXAMPLES
%
% gains = ComputeGains (impulse_responses);
% gains = ComputeGains (impulse_responses, [1 2:5 18]);
%
%
%
% KNOWN BUGS
%
% No known bugs.
%
%
% TODO
%
% No todo.
%
% 
% modified: 30 August 2012
% author: matthieu berjon <matthieu.berjon-dev(at)wavefield.fr>
% licence: BSD

  % Get the number of channels
  ind = [1:min(size(impulse_responses))];
  
  % take into account the speakers that we do not want to use
  if nargin < 2
    exception = ind;
  else
    exception = find(ind ~= speakers_to_avoid);
  end

  % get the max of each speakers
  impulses_max = max(abs(impulse_responses(:,exception)));

  % find the min of all speakers (be careful
  impulse_min = min(impulses_max);

  level = impulses_max - impulse_min;

  % normalisation
  gains = zeros (1, min (size (impulse_responses)));
  gains_tmp = level / max(impulses_max);
  
  gains(exception) = 1 - gains_tmp;
end % end function
