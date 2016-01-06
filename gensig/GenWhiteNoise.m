function [sig] = GenWhiteNoise(varargin)
% function [sig] = GenWhiteNoise(varargin)
%
% Generate a uniform white noise
%
%
% Input arguments
%
%     Compulsory argument are preceed by **.
%
%     gain [scalar]
%       normalised gain (0 < G < 1).
%
%     fs [scalar]
%       samplerate (defined in Hertz).
%
%     duration [scalar]
%       duration (defined in seconds).
%
%     norm [char]
%       amplitude normalisation.
%
%
% Output arguments
%
%     sig
%       Structure containing the following information:
%         - gain: gain used to generate the signal.
%         - fs: samplerate used to generate the signal.
%         - duration: duration of the signal (in seconds).
%         - smp_nb: duration of the signal (in samples).
%         - sig: signal itself.
%
%
% EXAMPLES
%
% GenWhiteNoise()
% GenWhiteNoise('gain', 0.9)
% GenWhiteNoise('fs', 44100)
% GenWhiteNoise('duration', 2)
% GenWhiteNoise('duration', 2, 'gain', 0.9, 'fs', 44100)
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
% - add normalisation function of the signal
%
% last update: 29 March 2012
% author: matthieu berjon <matthieu.berjon@wavefield.fr>
% license: WTFPL

%% Initialization
% check if the number of argument is sufficient
if round(length(varargin)/2) ~= length(varargin)/2
    error('illegal number of arguments') ;
end


% default parameters
sig.gain      = 0.9;    % normalised
sig.fs        = 44100;  % hertz
sig.duration  = 2;      % seconds


%% Checking of each arguments given by the user
for I = 1:2:length(varargin)-1
  switch varargin{I}
    case 'gain'
      if ((varargin{I+1} < 0) || (varargin{I+1} > 1))
        error('The gain must be a scalar (normalized: 0 < G < 1)')
      else
        sig.gain = varargin{I+1};
      end % end of if

    case 'fs'
      if (isscalar(varargin{I+1}))
        sig.fs = varargin{I+1};
      else
        error('The samplerate must be a scalar (in Hertz)');
      end

    case 'duration'
      if (isscalar(varargin{I+1}))
        sig.duration = varargin{I+1};
      else
        error('The duration must be a scalar (in seconds)');
      end

  end % end switch
end % end for
      
%% Program itself

sig.smp_nb = sig.fs * sig.duration; % samples number
sig.sig = (sig.gain * rand(1, sig.smp_nb))';
