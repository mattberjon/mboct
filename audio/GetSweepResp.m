function [measure] = GetSweepResp(varargin)
% function [measure] = GetSweepResp(varargin)
%
% automated impulse responses measure based on playrec toolbox
% (http://www.playrec.co.uk/documentation.php) for N microphones and M
% loudspeakers.
%
%
% Inputs Arguments
%
%     the compulsory arguments are preceed by **.
%
% **  idplay [scalar]
%       ID of output of the soundcard. To get the ID use GetDevices.
%       Prefer ASIO driver than others.
% **  idrec [scalar]
%       ID of input of the soundcard. To get the ID use GetDevices.
%       Prefer ASIO driver than others.
% **  sweep [char]
%       the absolute or relative path to the sweep file
%     level [scalar]
%       amplitude of signal *between 0 and 1* (0.01 is recommended to
%       prevent peaks).
%       If nothing is specified, default level will be 0.01.
%     spk [vector or scalar]
%       Vector containing all speakers that you want to use for the measure 
%       (example: [1:48] or [1 3 5]. Correspond with the number of outputs in
%       soundcard.
%       If nothing is specified, all available outputs will be used.
%     mic [vector or scalar]
%       Same as spk but for inputs (vector or scalar).
%       If nothing is specified, all available outputs will be used.
%     fs [scalar]
%       Samplerate for the measure.
%       If nothing is specified, the samplerate will be 44100Hz.
%     rectime [scalar]
%       Time in *seconds* of your recording. If you have a very reveberant
%       room, you need a long time record (around 12s in low frequencies).
%       If nothing is specified, the time will be the same as the sweep
%       file.
%     path [string]
%       *Absolute* path where you will store your measure (string).
%       If nothing is specified, the default path will be 'C:\measures' for
%       Windows users, '/tmp/measures' for Mac and GNU/Linux *BSD users, and
%       error message for others.
%     pause [scalar]
%       Time in *seconds* before start the automated measure (useful to leave 
%       the room before the beginning of the measure).
%       If nothing is specified the pause will be 0.
%     filters [char]
%       *Absolute path* where the filters are stored in order to convolve
%       it with the sweep.
%
%
% Outputs Arguments
%
%     measure
%       Structure containing the following information:
%         - info: summarize of all information need for the measure
%         - measure: the last sweep measure
%
%     The function store each sweep response in a matlab file in the
%     specified or default directory as spk_num.mat.
%
%
% EXAMPLES:
%
% GetSweepRes('idplay', 3, 'idrec', 4, 'sweep', '~/sounds/sweep.wav');
% GetSweepRes('idplay', 3, 'idrec', 4, 'sweep', '~/sounds/sweep.wav', 'level', 0.2);
% GetSweepRes('idplay', 3, 'idrec', 4, 'sweep', '~/sounds/sweep.wav', 'pause', 10);
% GetSweepRes('idplay', 3, 'idrec', 4, 'sweep', '~/sounds/sweep.wav', 'path', 'D:\matlab:measures');
% GetSweepRes('idplay', 3, 'idrec', 4, 'sweep', '~/sounds/sweep.wav', 'fs', 48000);
% GetSweepRes('idplay', 3, 'idrec', 4, 'sweep', '~/sounds/sweep.wav', 'rectime', 3);
% GetSweepRes('idplay', 3, 'idrec', 4, 'sweep', '~/sounds/sweep.wav', 'mic', [1 3 5]);
% GetSweepRes('idplay', 3, 'idrec', 4, 'sweep', '~/sounds/sweep.wav', 'spk', [4:12]);
%
% You can combine all of these arguments but you always have to specify at 
% least idplay *and* idrec arguments.
%
%
% KNOWN BUGS
%
% no known bugs
%
%
% TODO
%
% - find a solution regarding the OS detection when it failed instead of
% providing an error message
% - separate function that computes the impulse response with the inverse filter with
% fftfilt or equivalent
%
%
% last update: 28 March 2012
% author: matthieu berjon <matthieu.berjon@wavefield.fr>
% licence: WTFPL



%% Initialization
% check if the number of argument is sufficient
if round(length(varargin)/2) ~= length(varargin)/2
  disp('Error: illegal number of arguments');
  return
end

% check the presence of playrec
if (exist('playrec') ~= 3)
  disp('Error: you need playrec installed on your machine to use this function');
  return
end

%% Default measure parameters

playrec_info = playrec('getDevices');

% default parameters
measure.info.fs           = 44100;
measure.info.level        = 0.01;
measure.info.pause        = 0;
measure.info.rectime      = -1;
devices_info.id           = [1:length(playrec_info)];
devices_info.raw          = playrec_info;
if IsOs('WIN')
  measure.info.path       = 'C:\measures';
elseif IsOs('MAC')
  measure.info.path       = '/tmp/measures';
elseif IsOs('UNIX')
  measure.info.path       = '/tmp/measures';
else
  disp('Error: impossible to detect which Operating System you are using.');
  return
end

% Useful flags
flags = [0 0 0 0 0];
USE_FILTERS = flags(5);

%% Checking of each arguments given by the user
for I = 1:2:length(varargin)-1
  switch varargin{I}

    case 'level'
      if ((varargin{I+1} < 0) | (varargin{I+1} > 1))
        disp('Error: the level must be range between 0 AND 1.');
        return
      else
        measure.info.level = varargin{I+1};
      end % end of if

    case 'pause'
      if (varargin{I+1} < 0)
        disp('Error: the pause must be positive.');
        return
      else
        measure.info.pause = varargin{I+1};
      end % end of if
      
    case 'idplay'
      if (isempty(intersect(varargin{I+1}, devices_info.id)) == 1)
        disp(['Error: The input ID is not valid. Check the possible IDs ' ...
          'with GetDevices function.']);
        return
      else
        measure.info.idplay = varargin{I+1};
        flags(1) = 1;
      end
      
    case 'idrec'
      if (isempty(intersect(varargin{I+1}, devices_info.id)) == 1)
        disp(['Error: the input ID is not valid. Check the possible IDs with' ...
          ' GetDevices function.'])
        return
      else
        measure.info.idrec = varargin{I+1};
        flags(2) = 1;
      end
      
    case 'mic'
      mic_vector = varargin{I+1};
      nb_in_chan = devices_info.raw(1, measure.info.idrec + 1).inputChans;
      if ((isnumeric(mic_vector) == 0) ...
        | (length(mic_vector) > nb_in_chan) ...
        | (max(mic_vector) > nb_in_chan) ...
        | (min(mic_vector) <=0))
        disp('Error: you have a wrong interval of inputs.')
        disp(['max input channels: ' nb_in_chan])
        return
      else
        measure.info.mic = varargin{I+1};
        flags(3) = 1;
      end
      
    case 'spk'
      spk_vector = varargin{I+1};
      nb_in_chan = devices_info.raw(1, measure.info.idplay + 1).outputChans;
      if ((isnumeric(spk_vector) == 0) ...
        | (length(spk_vector) > nb_in_chan) ...
        | (max(spk_vector) > nb_in_chan) ...
        | (min(spk_vector) <=0))
        disp('Error: you have a wrong interval of outputs.')
        return
      else
        measure.info.spk = varargin{I+1};
        flags(4) = 1;
      end
      
    case 'fs'
      if (isempty(regexp(ls_sweeps, num2str(varargin{I+1}), 'once')))
        disp(['Error: we do not have the sweep corresponding to the samplerate' ...
          ' specified. Choose another samplerate or generate the sweep' ...
          ' with the GenSweep function.'])
        return
      else
        measure.info.fs = varargin{I+1};
      end
      
    case 'rectime'
      if (isscalar(varargin{I+1}) == 0)
        disp('Error: rectime have to be a scalar.');
        return
      else
        % tranformed from seconds to samples
        measure.info.rectime(1) = varargin{I+1} * measure.info.fs;
        % tranformed in seconds
        measure.info.rectime(2) = varargin{I+1};
      end
      
    case 'path'
      if (isdir(varargin{I+1}) == 0)
        disp('Warning: the specified folder does not exist.');
        % creation of the measure directory
        mkdir (varargin{I+1});
        disp('Folder created.');
      else
        measure.info.path = varargin{I+1};
        disp('Warning: the specified folder exists. You will maybe lose data');
        reply = input('Do you want to continue? (y/n) : ', 's');
        if (strcmp(reply,'y') ~= 1)
          disp('Program stopped.');
          return;
        end
      end
      
    case 'filters'
      if (ischar (varargin{I+1}) ~= 1)
        disp ('Error: the sweep has to be a char (the path to the filters).')
        return;
      else
        measure.info_filters = varargin{I+1};
        flags(5) = 1;
        USE_FILTERS = flags(5);
      end
      
    case 'sweep'
      if (ischar(varargin{I+1}) ~= 1)
        disp('Error: the sweep has to be a char (the path to the signal).')
        return
      else
        measure.info.sweep = varargin{I+1};
      end % end of if


      
    otherwise
      badarg = varargin{I};
      disp(['Error: ' badarg ' is not a consistent argument.']);
      return
  end % end switch
end % end for


%% check consistence of arguments according to the flags
if (flags(1) == 0 | flags(2) == 0)
  disp('Error: you do not specify any input or output ID.')
  return
end

if (flags(3) == 0)
  measure.info.mic   = 1:devices_info.raw(1, measure.info.idrec).inputChans;
end
if (flags(4) == 0)
  measure.info.spk   = 1:devices_info.raw(1, measure.info.idplay).outputChans;
end


  

%% Program itself (yes it's shorter than the checking)

% Pause to let you to move out from the room
pause(measure.info.pause);

% loading of sweep (we get the samplerate because we cannot be sure about
% the file name. in that way we will be coherent in the measure
[sweep, measure.info.fs] = wavread(measure.info.sweep);



% if rectime equal -1, we need to add a pause of at least the time of the
% recording (+ fs), in order to wait the buffer
if (measure.info.rectime == -1)
  pause_rec_time = (length(sweep) + measure.info.fs) / measure.info.fs;
end

% response measure
if playrec('isInitialised')
    playrec('reset');
end

% initialisation
playrec('init', measure.info.fs, measure.info.idplay, measure.info.idrec);

for k=1:length(measure.info.spk)

  if USE_FILTERS
    % load the current filter 
    filter_filename = [measure.info_filters '/' num2str(measure.info.spk(k)) '.wav'];
    [cur_filter fs_filter] = wavread (filter_filename);

    if fs_filter ~= measure.info.fs
      error ('The filter samplerate differs from the measure samplerate')
    end

    sweep = conv (sweep, cur_filter, 'same');
  end

  % after the application of the filter (or not), multiply the sweep by the
  % specified gain.
  sweep = measure.info.level .* sweep;

  % measure itself
  playrec('playrec', sweep, measure.info.spk(k), ...
    measure.info.rectime, measure.info.mic);
  
  % let to the playrec buffer to store information from the microphone(s)
  pause(pause_rec_time);

  % storage of sweep response
  page = playrec('getLastFinishedPage');
  measure.sweep = playrec('getRec', page);
  measure.sweep = double(measure.sweep); % converting to double type

  % current speaker
  measure.info.spk_meas = measure.info.spk(k);
  
  % file backup
  save([measure.info.path '\' num2str(measure.info.spk(k))], 'measure') ; 
end
