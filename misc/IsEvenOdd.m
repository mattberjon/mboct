function [result] = IsEvenOdd(value)
% function [result] = IsEvenOdd(value)
%
% Check if the number is even or odd.
%
% 
% Input arguments
%
% value [scalar]
%   the value that you want to test.
%
%
% Output arguments
%
% result
%   return 1 if it is even, 0 if odd, -1 otherwise.
%
%
% EXAMPLES
%
% IsEvent(4)
%
%
% KNOWN BUGS
%
% No known bugs.
%
% TODO
%
% nothing
%
%
% last updated: 19 April 2012
% author: matthieu berjon <matthieu.berjon@wavefield.fr>
% license: WTFPL


if (isscalar(value) != 1)
  disp('error: You must enter an scalar value')
  return
end % end if

modulo = mod(value, 2);

if (modulo == 0)
  result = 1;
elseif (modulo == 1)
  result = 0;
else
  result = -1;
end % end if

end % function
