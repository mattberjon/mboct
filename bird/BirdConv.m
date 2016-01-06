function [converted_data] = BirdConv(varargin)
% function [converted_data] = BirdConv(varargin)
% 
% convertion in degree for angles and in inches for position
%
%
% Input arguments
%
%     the compulsory arguments are preceed by **.
%
% **  data [matrix, vector, scalar]
%       Vector containing raw position or angle data.
%
%     type [char]
%       Conversion type 'pos' (position converstion) or 'ang' (angle
%       conversion.
%       If this argument is not specified, the function will execute a angle
%       conversion.
%
%
% Output arguments
%
%     converted_data [matrix]
%       Matrix containing the converted data:
%
%
% EXAMPLES
%
% data_converted = BirdConv('data', bird_ang_data)
% data_converted = BirdConv('data', bird_pos_data, 'type', 'pos')
% data_converted = BirdConv('data', bird_ang_data, 'type', 'ang')
%
% The third example lead to the same result as the first one.
%
%
% KNOWN BUGS
% 
% No known bugs.
%
%
% TODO
%
% - integrate other bird conversion possibilities:
%   - matrix conversion
%   - quaternion conversion
%
%
% last update: 20 April 2012
% author: matthieu berjon <matthieu.berjon@wavefield.fr>
% license: WTFPL


% check if the number of argument is sufficient
if (round(length(varargin)/2) ~= length(varargin)/2)
  disp('Error: illegal number of arguments')
  return
end % end if

%% Default parameters
normalisation         = 32768;
scale                 = 180;
converted_data.type   = 'ang';

% useful flags
flags = [0];

%% Checking of input arguments given by the user
for I = 1:2:length(varargin)-1
  switch varargin{I}
      
    case 'data'
      % check data
      if (ismatrix(varargin{I+1}) == 0)
        disp('Error: data must be a scalar, a vector or a matrix')
        return
      else
        data = varargin{I+1};
        flags(1) = 1;
      end % end if

    case 'type'
      % check type of conversion
      if (ischar(varargin{I+1}) == 0)
        disp('Error: type must be a char')
        return
      elseif (varargin{I+1} == 'ang' || varargin{I+1} == 'pos')
        converted_data.type = varargin{I+1};

        % according to the type we select the right scale (degree or inch)
        if (varargin{I+1} == 'ang')
          scale = 180;
        elseif (varargin{I+1} == 'pos')
          scale = 36;
        end % end if
      else
        disp('Error: type can be only "ang" or "pos"')
        return
      end % end if

    otherwise
      badarg = varargin{I};
      disp(['Error ' bararg ' is not a valid argument']')
      return
  end % end switch
end % end for


%% Checking of arguments according to the flags
if (flags(1) == 0)
  disp('Error: you must specify data that you want to convert')
  return
end

%% Program itself

%{
if (converted_data.type == 'pos')
  disp('Warning: position conversion in progress (inch output)')
elseif (converted_data.type == 'ang')
  disp('Warning: angle conversion in progress (degree output)')
else
  disp('Error: there was a problem on the specified conversion')
  return
end
%}

converted_data = data .* scale / normalisation;

end % end function
