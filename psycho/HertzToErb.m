function [erb] = HertzToErb (frequency)
% function [erb] = HertzToErb (frequency)
%
% Convert a frequency center into an Equivalent Rectangular Band (ERB) band.
% Based on ERB rate (called E) , see paper:
% Moore, BCJ & Glasberg, BR. Suggested formulae for calculating
% auditory-filter bandwidths and excitation patterns. J. Acoust. Soc. Am.,
% 1983 (74), 750-753.
%
% Inputs arguments
%
%     The compulsory arguments are preceed by **.
%
% **  frequency [scalar, vector]
%       Scalar or vector corresponding to the frequency center that you want to convert.
%
%
% Output arguments
%
%     erb [scalar, vector]
%       Converted ERB.
%
%
% EXAMPLES
%
% erb = HertzToErb (frequency);
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
% modified: 07 October 2012
% author: matthieu berjon <matthieu.berjon(at)wavefield.fr>
% licence: BSD
%
% Based on John Culling code.

  f_khz = frequency / 1000;
  erb = 11.17 .* log ((f_khz + 0.312) ./ (f_khz + 14.675)) + 43;
  erb(find (erb) <= 0) = 0.1;
end
