function [hertz] = ErbToHertz (erb)
% function [hertz] = ErbToHz (erb)
%
% Convert a Equivalent Rectangular Band (ERB) band to the frequency center in 
% hertz.
% Based on ERB rate (called E) , see paper:
% Moore, BCJ & Glasberg, BR. Suggested formulae for calculating
% auditory-filter bandwidths and excitation patterns. J. Acoust. Soc. Am.,
% 1983 (74), 750-753.
%
% Inputs arguments
%
%     The compulsory arguments are preceed by **.
%
% **  erb [scalar, vector]
%       Scalar or vector corresponding to the ERB's that you want to convert.
%
%
% Output arguments
%
%     hertz [scalar, vector]
%       Frequencies center converted.
%
%
% EXAMPLES
%
% hertz = ErbToHertz (erb);
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
% modified: 28 August 2012
% author: matthieu berjon <matthieu.berjon(at)wavefield.fr>
% licence: BSD
%
% Based on John Culling code.

  tmp = exp ((erb - 43) / 11.17);
  hertz = (0.312 - 14.675 .* tmp) ./ (tmp - 1.0) .* 1000;
  
  % correction of all negative of null values
  hertz(find (hertz) <= 0) = 1;
end
