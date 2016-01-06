function [] = PreparePdfExport (handle)
% function [] = PreparePdfExport (handle)
%
% Prepare a fiigure to be exported as PDF file. This function has to used in
% conjunction with SaveFig.
%
% Input Arguments
%
%     The compulsory arguments are preceed by **.
%
% **  handle [scalar]
%       handle of the figure that you want to export.
%
% Output Arguments
%
% No output arguments
%
%
% EXAMPLES
%
% Fig2Pdf (fig)
%
%
% KNOWN BUGS
%
% No known bugs
%
%
% TODO
%
% Add more arguments maybe such as the quality
%
%
% modified: 01 November 2012
% author: matthieu berjon <matthieu.berjon@wavefield.fr>
% license: WTFPL

  if nargin < 3
    path_name = '.';
  end

  set (handle, 'paperunits', 'centimeters')
  set (handle, 'papersize',  [10 7])
  set (handle, 'paperposition', [0 0 10 7])
%  print (handle, [path_name '/' file_name '.pdf'], '-dpdf');
end
