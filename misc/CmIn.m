function [result] = CmIn(varargin)
% function [result] = CmIn(varargin)
% 
% Convert centimeters to inches or inches to centimeters.
%
% 1 cm = 0.3937 in
% 1 in = 2.54 cm
%
% Inputs arguments
% 
%
%       data [scalar, vector]
%
%
%       type [char]
%       in2cm or cm2in
%
%
% Output arguments
%
%       result [struct]
%         processing of the conversion:
%           - data: the data itself
%           - type: type of conversion in2cm or cm2in
%

% check if the number of argument is sufficient
if (round(length(varargin)/2) != length(varargin)/2)
  disp('Error: illegal number of arguments')
  return
end % end if

% Initialisation
result.type = 'in2cm';
scale = 2.54;

% useful flags
flags = [0];

%% Checking of input arguments given by the user
for I = 1:2:length(varargin)-1
  switch varargin{I}
      
    case 'data'
      % check data
      if (isvector(varargin{I+1}) == 0)
        disp('Error: data must be a scalar or a vector')
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
      elseif (varargin{I+1} == 'in2cm' || varargin{I+1} == 'cm2in')
        result.type = varargin{I+1};

        if (varargin{I+1} == 'in2cm')
          scale = 2.54;
        elseif (varargin{I+1} == 'cm2in')
          scale = 0.3937;
        end
      else
        disp("Error: type can be only 'in2cm' or 'cm2in'")
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
result.data = data .* scale;

end % end function
