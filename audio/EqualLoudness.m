function [] = EqualLoudness(varargin)
% function [] = EqualLoudness(path_in, path_out)
%
% Equal in loudness (according to LKFS value from standard ITU-R BS.1770-2) a
% group of audio files located in a folder.
%
%
% Input arguments
%
%     the compulsory arguments are preceed by **.
%
% **  path_in [char]
%       relative or absolute path where files are stored. (the path must end
%       without a slash. See examples section).
%
%     path_out [char]
%       relative or absolute path where you want to store new files. (the path
%       must end without a slash. See examples section).
%       If nothing is specified, new files will be stored in the same folder
%       as path_in argument.
%
%
% Output arguments
%
%     No output arguments.
%
%
% EXAMPLES
%
% EqualLoudness('path_in', '/path/folder/in')
% EqualLoudness('path_in', '/path/folder/in', 'path_out', '/path/folder/out')
%
%
% KNOWN BUGS
%
% no known bugs.
%
%
% TODO
%
% - accept other formats rather than only wav files.
%
% nothing at the moment.
%
% last update: 12 April 2012
% author: matthieu berjon <matthieu.berjon@wavefield.fr>
% based on marui atsushi <marui@ms.geidai.ac.jp> script.
% license: WTFPL

if exist('loudness_match') ~= 2
  error('You need "loudness_match" function on your machine to run this function. See http://www.geidai.ac.jp/~marui/matlab/node40.html')
end

if exist('loudness_itu') ~= 2
  error('You need "loudness_itu" function on your machine to run this function. See http://www.geidai.ac.jp/~marui/matlab/node40.html')
end

% Useful flags
flags = [0 0];
%% Checking of each arguments given by the user
for I = 1:2:length(varargin)-1
  switch varargin{I}

    case 'path_in'
      if (isdir(varargin{I+1}))
        path_in = varargin{I+1};
        path_check = [varargin{I+1} '/*.wav'];
        files = dir(path_check);
        flags(1) = 1;
      else
        error('"path_in" is not a valid directory')
      end % end of if

    case 'path_out'
      if (isdir(varargin{I+1}))
        path_out = varargin{I+1};
        flags(2) = 1;
      else
        error('"path_out" is not a valid directory')
      end % end of if

    otherwise
      badarg = varargin{I};
      error([badarg ' is not a consistent argument'])
  end % end switch
end % end for


%% check consistence of arguments according to the flags
if (flags(1) == 0)
  error('You must enter "path_in" argument')
elseif (flags(1) == 1 && flags(2) == 0)
  path_out = path_in;
end



%% Program itself (yes it's shorter than the checking)
targetLKFS = -24;

path_in
path_out

for n=1:length(files)
  [x,fs,nbits] = wavread([path_in '/' files(n).name]);
  y = x * loudness_match(x, fs, targetLKFS);
  wavwrite(y, fs, nbits, [path_out '/eq_' files(n).name]);
end % end for

end
