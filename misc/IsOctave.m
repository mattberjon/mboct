function r = IsOctave ()
% function r = is_octave ()
%
% Test if the software currently used is Octave.
%
% Input arguments
%
%   No input arguments
%
%
% Output arguments
%
%   r: is set to one is the answer is true, 0 otherwise
%
%
%
%
   persistent x;
   if (isempty (x))
     x = exist ('OCTAVE_VERSION', 'builtin');
   end
   r = x;
 end
