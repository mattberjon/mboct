function [raw_pos raw_ang] = BirdPosAng(raw_data)
% function [raw_pos raw_ang] = BirdPosAng(raw_data)
%
% Extract from a FoB (Flock of Bird) raw vector raw positions and  angules
% information.
%
%
% Input arguments
% 
% raw_data [vector]
%   the raw vector containing position and angle information (3 digits for the
%   position and 3 digits for the angle)
%
%
% Output arguments
%
% raw_pos_ang [matrix]
%   matrix containing all hierarchical position and angle information.
%     raw_pos_ang(:,:,1): position information
%     raw_pos_ang(:,:,2): angle information
%
%   position:
%     [x y z]
%   angle:
%   [azim elev roll]
%
% EXAMPLES
%
% BirdPosAng(raw_data)
%
%
% KNOWN BUGS
%
% No known bugs.
%
%
% TODO
%
% - make better tests to ensure that the user will know why it does not work.
% - adapt the conversion system to the other possibility position/quaternions
%
%
% last update: 19 April 2012
% author: matthieu berjon <matthieu.berjon@wavefield.fr>
% license: WTFPL


if (isvector(raw_data) == 0)
  disp('Error: the data must be a vector')
  return
end % end if

% we consider a step of 6 for a raw data vector containing positions and
% angles (3 digits for positions, 3 digits for angles)
step = 6;

% check if the vector can be divided by 6
raw_data_len = length(raw_data);
is_splitable = mod(raw_data_len, step);

if (is_splitable ~= 0)
  warning('There is a problem in your vector, it cannot be divided by 6.')
  warning('We cut your vector to fit with the Flock of Bird data requirements.')

  % Optimisation of the vector size (based on the idea that a problem occured
  % at the end of the file
  raw_data_upd = raw_data(1:raw_data_len - is_splitable);
else
  raw_data_upd = raw_data;
  raw_data_upd_len = raw_data_len;
end % end if

% reshape 6xn to get position and angle
rows_nb = length(raw_data_upd) / step;
raw_pos_ang_2 = reshape(raw_data_upd, step, rows_nb)';
raw_pos = raw_pos_ang_2(:, 1:3);
raw_ang = raw_pos_ang_2(:, 4:6);

end % end function
