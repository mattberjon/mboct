function [sig] = GenSinus(varargin)
% function [sig] = GenSinus(varargin)
%
% Generate a sinus signal
%
%
% Input Arguments
%
%     Compulsory argument are preceed by **.
%
% Input arguments
%
%     gain [scalar]
%       normalised gain (0 < G < 1).
%
%     fs [scalar]
%       samplerate (defined in Hertz).
%
%     freq [scalar]
%        frequency of the sinus.
%
%     duration [scalar]
%       duration (defined in seconds).
%
%
% Output arguments
%
%     sig
%       Structure containing the following information:
%         - gain: gain used to generate the signal.
%         - fs: samplerate used to generate the signal.
%         - freq: frequency of the sinus.
%         - duration: duration of the signal (in seconds).
%         - sig: signal itself.
%
%
% EXAMPLES
%
% GenSinus()
% GenSinus('gain', 0.9)
% GenSinus('fs', 44100)
% GenSinus('freq', 1000)
% GenSinus('duration', 2)
% GenSinus('duration', 2, 'freq', 1000, 'gain', 0.9, 'fs', 44100)
%
% The argument used here are those defined by default in the program.
%
%
% KNOWN BUGS
%
% No known bugs.
% 
%
% TODO
%
% no todo
%
% last update: 24 April 2012
% author: matthieu berjon <matthieu.berjon@wavefield.fr>
% license: WTFPL

%% Initialization
% check if the number of argument is sufficient
if round(length(varargin)/2) ~= length(varargin)/2
    error('illegal number of arguments') ;
end

% default parameters
sig.gain      = 0.9; % normalised
sig.freq      = 1000; % hertz
sig.fs        = 44100; % hertz
sig.duration  = 2; % seconds


%% Checking of each arguments given by the user
for I = 1:2:length(varargin)-1
  switch varargin{I}
    case 'gain'
      if ((varargin{I+1} < 0) || (varargin{I+1} > 1))
        error('The gain must be a scalar (normalized: 0 < G < 1)')
      else
        sig.gain = varargin{I+1};
      end % end of if

    case 'freq'
      if (isscalar(varargin{I+1}))
        sig.freq = varargin{I+1};
      else
        error('The frequence "freq" must be a scalar (in Hertz)')
      end % end of if

    case 'fs'
      if (isscalar(varargin{I+1}))
        sig.fs = varargin{I+1};
      else
        error('The samplerate "fs"  must be a scalar (in Hertz)');
      end

    case 'duration'
      if (isscalar(varargin{I+1}))
        sig.duration = varargin{I+1};
      else
        error('The duration "duration" must be a scalar (in seconds)');
      end

  end % end switch
end % end for


%% program itself

% number of samples
smp_nb = sig.fs * sig.duration;
% computing of omega
omega = 2 * pi * sig.freq;
% time vector creation
duration = (1:smp_nb) / sig.fs;

% creation of the sinus signal
sig.sig = (sig.gain * sin(omega * duration))';

end % end function
