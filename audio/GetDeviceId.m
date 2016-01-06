function [id_info] = GetDeviceId(varargin)
% function [id_info] = GetDeviceId(varargin)
%
% Get the ID of a sound card depending of a pattern.
% This function uses playrec. This function can be useful when you use several
% USB, firewire (or even PCI) sound cards that are plugged in a different
% order sometimes.
% The patterns are case insensitive.
%
%
% Input arguments
%
%     The compulsory arguments are preceed by **.
%
% **  play [char]
%       pattern corresponding to the play ID.
%
%     rec [char]
%       Specify which sound card you want to use for the record part.
%       If rec is empty, the ID will be the same as play. If rec is not
%       specified, rec will be set at -1 (not used playrec setting).
%
%
% Output arguments
%
%     id_info [struct]
%       Structure corresponding to selected ID's and playrec raw data (just in
%       case) provided by playrec('getDevices') function.
%         - play: ID play (hardware or software outputs)
%         - rec: ID record (hardware of software inputs)
%         - raw: raw information from playrec
%
%
% EXAMPLES
%
% id_info = GetDeviceId('play', 'asio4all')
% id_info = GetDeviceId('play', 'mottu pci', 'rec', 'realtek')
% id_info = GetDeviceId('play', '', record, '')
%
%
% KNOWN BUGS
% 
% no known bugs.
%
%
% TODO
%
% let the regex match with a part of the expression within the pattern or
% maybe use strfind.
% 
% - better documentation and comments
%
% last update: 16 April 2012
% author: matthieu berjon <matthieu.berjon@wavefield.fr>
% license: WTFPL

% check the presence of playrec
if (exist('playrec') ~= 3)
  disp('You need playrec installed on your machine to run this function');
  return;
end

%% Initialization
% check if the number of argument is sufficient
if (round(length(varargin)/2) ~= length(varargin)/2)
    disp('illegal number of arguments') ;
    return;
end

% Useful flags
flags = [0 0 0];

%% Checking of each arguments given by the user
for I = 1:2:length(varargin)-1
  switch varargin{I}
    
    case 'play'
      if (ischar(varargin{I+1}) ~= 1)
        disp('The play has to be a char (the seeking pattern)');
        return;
      else
        play_pattern = varargin{I+1};
        flags(1) = 1;
      end % end of if


    case 'rec'
      if (ischar(varargin{I+1}) ~= 1)
        disp('The rec has to be a char (the seeking pattern)');
        return;
      else
        rec_pattern = varargin{I+1};
        flags(2) = 1;

        if (isempty(rec_pattern))
          flags(3) = 1;
        end
      end % end of if
    
    otherwise
      badarg = varargin{I};
      disp([badarg ' is not a consistent argument']);
      return;
  end % end of switch
end % end for

%% check consistence of arguments according to the flags
if (flags(1) == 0)
  disp('You must specify a pattern for the play ID');
  return;
end

if (flags(2) == 0)
  id_info.rec = -1;
end

%% Now the program itself
id_info.raw = playrec('getDevices');
devices_nb = length(id_info.raw);

% seeking which play ID correspond to the pattern (insensitive case)
for a = 1:devices_nb
  play_pattern_match = regexpi(id_info.raw(a).name(1,:), play_pattern, 'match');
  if isempty(play_pattern_match)
    play_match_id(a) = 0;
  else
    play_match_id(a) = play_pattern_match;
  end % end if
end % end for

% seeking which rec ID correspond to the pattern (insensitive case)
if (flags(2) == 1 && flags(3) == 0)
  for a = 1:devices_nb
    rec_pattern_match = regexpi(id_info.raw(a).name(1,:), rec_pattern, 'match');
    if isempty(rec_pattern_match)
      rec_match_id(a) = 0;
    else
      rec_match_id(a) = rec_pattern_match;
    end % end if
  end % end for
end % end if


% looking for match playrec ID
id_play_ind = find(play_match_id == 1);
id_play_ind_len = length(id_play_ind);

if (flags(2) == 1 && flags(3) == 0)
  id_rec_ind = find(rec_match_id == 1);
  id_rec_ind_len = length(id_rec_ind);
end

% management of problems (if there is more than 1 ID per argument or no
% ID at all

flags_matching = [0 0 0 0];
% several proposition for play or rec
if (id_play_ind_len > 1)
  id_info.play = id_info.raw(id_play_ind(1)).deviceID;
  disp('Warning: there are several ID corresponding to this play pattern')
  disp('We stored the first ID.')
  flags_matching(1) = 1;
  return;
end % end of if


if (flags(2) == 1 && flags(3) == 0)
  if (id_rec_ind_len > 1)
    id_info.rec = id_info.raw(id_rec_ind(1)).deviceID;
    disp('Warning: there are several ID corresponding to this rec pattern')
    disp('We store the first ID.')
    flags_matching(2) = 1;
  end % end of if
end % end if

% 0 pattern matching...
if (isempty(id_play_ind))
  id_info.play = -1;
  disp('No ID corresponds to this play pattern. ID set to -1')
  flags_matching(3) = 1;
  return;
end


if (flags(2) == 1 && flags(3) == 0)
  if (isempty(id_rec_ind))
    id_info.rec = -1;
    disp('No ID corresponds to this rec pattern. ID set to -1')
    flags_matching(4) = 1;
  end
end

% otherwise, it is ok
if (flags_matching(1) == 0 && flags_matching(3) == 0)
  id_info.play = id_info.raw(id_play_ind).deviceID;
end% end if

if (flags_matching(2) == 0 && flags_matching(4) == 0)
  if (flags(2) == 0)
    id_info.rec = -1;
  elseif (flags(2) == 1 && flags(3) == 0)
    id_info.rec = id_info.raw(id_rec_ind).deviceID;
  elseif (flags(2) == 1 && flags(3) == 1)
    id_info.rec = id_info.play;
  end% end if
end % end if

end % end function
