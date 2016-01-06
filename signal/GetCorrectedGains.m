function [gains] = GetCorrectedGains(impulse_responses, normalisation)
% function [gains] = GetCorrectedGains(impulse_responses, normalisation)
%
% Compute the corrected gains according to a matrice corresponding to the
% impulse response of each speaker.
%
%
% Input arguments
%
%   The compulsory arguments are preceed by **.
%
%
% **  impulse_responses [matrice]
%       Impulse responses matrice.
%
%     normalisation [scalar]
%       set to one if you want a normalised gain.
%
%
% Output arguments
%
%     gains [vector]
%       Vector containing new gains to apply on the speaker array.
%
%
% KNOWN BUGS
%
% No known bugs.
%
%
% TODO
%
% No todo
%
% modified: 22 August 2012
% author: matthieu berjon <matthieu.berjon@wavefield.fr>
% licence: BSD


if nargin < 2
  normalisation = 0;
end

% we take the absolute value of the 
imp_resp = abs(impulse_responses);
% we take the max on each channel
imp_resp_max = max(imp_resp, [], 1);
% we take the min in this bunch of speakers
imp_resp_min = min(imp_resp_max);

% substraction on each speakers
new_gains = imp_resp_max - imp_resp_min;

% gain normalisation
if normalisation
  gains = new_gains / max(imp_resp_max);
else
  gains = new_gains;
end

end
