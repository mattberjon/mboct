function c = Columns (M)
% function c = Columns (M)
%
% Get the length of the column of a matrix. It should be used on matlab to
% replace the buitin function column on octave.
%
% modified: 09 October 2012
% author: matthieu berjon <matthieu.berjon@wavefield.fr>
% licence: BSD

  c = size (M,2);
end
