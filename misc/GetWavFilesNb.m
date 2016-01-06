function [files_sorted] = GetWavFilesNb (pathname)
% function [files_sorted] = GetWavFileNb (pathname)
%
% Extract from a bunch of wav files that have the following pattern naming
% (n.wav with n corresponding the number of a something) its number and sort
% all the elements.
%
% Input arguments
%
% **  pathname [char]
%       The absolute path to the folder containing the wav files.
%
%
% Output arguments
%
%     files_sorted [vector]
%       the files number sorted.
%
%
% EXAMPLES
%
% GetWavFileNb ('/home/user/path/to/wavfiles');
%
%
% KNOWN BUGS
%
% No known bugs
% 
%
% TODO
%
% No todo
%
% modified: 17 October 2012
% author: matthieu berjon <matthieu.berjon@wavefield.fr>
% licence: BSD


  file_names = dir ([pathname '/*.wav']);
  files_nb = length (file_names);

  % get the numbers of the files
  for a = 1:files_nb
    file_nb_names(a) = str2num (strtok (file_names(a).name, '.'));
  end
  [files_sorted files_id] = sort (file_nb_names);
end
