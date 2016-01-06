function [nv] = ExpandVector (v, nb)
% function [nv] = ExpandVector (v, nb)
%
% Expand the vector by adding n times each component of a vector
%
%   Compulsory argument are preceed by **.
%
% Input arguments
%
% **  v [vector]
%       Input vector that will be expanded.
%
%     nb [scalar]
%       Number of times that each component of v will be added. if nothing is
%       specified, nb will be set at 2.
%
%
% Output arguments
%
%     nv [vector]
%       The nex expanded vector.
%
%
% EXAMPLES
%
% ExpandVector ([1 3 5])
% ExpandVector ([8:12], 4)
%
%
% KNOWN BUGS
%
% I did not test that but it should work only with row vectors.
%
%
% TODO
%
% Do the same for matrices.
%
% modified: 18 October 2012
% author: matthieu berjon <matthieu.berjon@wavefield.fr>
% licence: BSD

  if (nargin < 2)
    nb = 2;
  end

  for a = 1:length (v)
    nv_tmp = repmat (v(a), [1 nb]);
    id = (a-1) * nb + 1;
    nv(id:id+nb-1) = nv_tmp;
  end
end
