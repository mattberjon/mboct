function [azimuth] = GetAzimuth (bird_data)
% function [azimuth] = GetAzimuth (bird_data)
%
% Extract the azimuth from FoB raw data (6 digits = position and angle)
% In order to work each trial has to be in a cell.
%
% Arguments preceed by ** are mandatory.
%
% Inputs arguments
%
% **  bird_data [cell]
%       Cell containing each trial of a block
%
%
% Output arguments
%
%     azimuth [cell]
%       azimuth in degrees of the bird data
%
%
% EXAMPLES
%
% GetAzimuth (bird_data)
%
%
% KNOWN BUGS
%
% No known bugs.
%
%
% TODO
%
% * develop tests in order to be sure of the type of data entered and warn
%   the user if they are wrong.
%
%
% modified: 26 March 2013
% author: Matthieu Berjon <matthieu.berjon@wavefield.fr>
% licence: WTFPL


  % Separate raw position from raw angles
  [raw_pos raw_ang] = cellfun (@(separation) BirdPosAng(separation), ...
    bird_data, 'UniformOutput', false);
  % Convert in degrees the angles
  ang = cellfun (@(conversion) BirdConv('data', conversion), ...
    raw_ang, 'UniformOutput', false);
  % Keep only the azimuth
  azimuth = cellfun (@(extract_ang_disp) extract_ang_disp(:,1), ...
    ang, 'UniformOutput', false);
  % rotate the azimuth in order to be defined between -180;180 degrees
  azimuth = cellfun (@(scaling) ScaleAngles(scaling), ...
    azimuth, 'UniformOutput', false);
end
