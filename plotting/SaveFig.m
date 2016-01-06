function [] = SaveFig (handle, filename)
% function [] = SaveFig (handle, filename)
%
% Export a given figure in different format files. All files will be created
% in the current folder following this architecture:
%
% - parent directory
% |- img
%  |- emf
%  |- svg
%  |- pdf
%
% At the moment only emf, svg and pdf files are supported.
%
%
% Input Arguments
%
%     The compulsory arguments are preceed by **.
%
% **  handle [scalar]
%       Handle of the figure that you want to export
%
% **  filename [char]
%       Filename of the file without any extensions.
%
%
% Output arguments
%
% No output arguments
%
%
% EXAMPLES
%
% SaveFig (fig, 'my_fig')
%
%
% KNOWN BUGS
%
% No known bugs
%
%
% TODO
%
% Take into account the tex format (Tikz)
%
% 
% modified: 01 November 2012
% author: matthieu berjon <matthieu.berjon@wavefield.fr>
% licence: WTFPL

  % Type of image that we want to support
  img_root = 'img';
  ext = ['emf'; 'svg'; 'pdf'; 'tex'];

  % checking of the folders existence
  if ~exist ('img_root', 7)
    mkdir ('.', img_root)

    % if img doesn't exist the subfolder have to be created as well
    for a = 1:length (ext)
      [status] = mkdir (img_root, ext(a, :));
    end
  else
    % check the existence of the subfolders
    for a = 1:length (ext)
      mkdir (img_root, ext(a, :));
    end
  end

  % now we can export the image in different vectorial formats
  % emf file for people who really want to works with ... Powerpoint and other
  % very good microsoft softwares...
  print (handle, [img_root '/' ext(1, :) '/' filename '.' ext(1, :)], '-dmeta');
  % svg file for including easily in web pages
  print (handle, [img_root '/' ext(2, :) '/' filename '.' ext(2, :)], '-dsvg');
  % pdf to use everywhere and especially in latex documents (we use
  % PreparePdfExport to crop the figure before the export
  PreparePdfExport (handle);
  print (handle, [img_root '/' ext(3, :) '/' filename '.' ext(3, :)], '-dpdf');
end
