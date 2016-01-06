function answer = IsMatrix(varargin)
% function answer = ismatrix(varargin)
%
% Test if the variables are matrices. (Needed for not recent version of Matlab)
%
%
% Input arguments
%
% **  variable
%       variable to test.
%
%
% Output arguments
%
%     answer
%       boolean value:
%         - 1 if it is true,
%         - 0 if it is false.
%
%
% EXAMPLES
%
% IsMatrix(foo)
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
% modified: 13 July 2012
% author: Matthieu Berjon <matthieu.berjon@wavefield.fr>
% license: WTFPL

for a= 1:length(varargin)
  cur_size = size(varargin{a});

  if length(cur_size) > 2
    answer(a) = 1;
  elseif cur_size(1) >= 2 && cur_size(2) >= 2
    answer(a) = 1;
  else
    answer(a) = 0;
  end
end
