function [global_rotation] = Rotation(yaw, pitch, roll)
% function [rotation_matrix] = Rotation(yaw, pitch, roll)
%
% Compute the global rotation matrix according to yaw, pitch and roll in
% degree.
%
%
% Input arguments
%
%   the compulsory arguments are preceed by **.
%
% **  yaw [scalar]
%       the yaw (azimuth) in degree.
%
% **  pitch [scalar]
%       the pitch (elevation) in degree
%
% **  roll [scalar]
%       the roll in degree
%
%
% Output arguments
%
% global_rotation [matrix]
%   global rotation matrix including yaw, pitch and roll to apply to your
%   object.
%
%
% EXAMPLES
%
% Rotation(90, 0, 0)
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
% last update: 30 April 2012
% author: matthieu berjon <matthieu.berjon@wavefield.fr>
% license; WTFPL

yaw = yaw * pi / 180;
pitch = pitch * pi / 180;
roll = roll * pi / 180;

rot_z = [ ...
cos(yaw) -sin(yaw) 0; ...
sin(yaw) cos(yaw)  0; ...
0 0 1];

rot_y = [ ...
cos(pitch) 0 sin(pitch); ...
0 1 0; ...
-sin(pitch) 0 cos(pitch)];

rot_x = [ ...
1 0 0; ...
0 cos(roll) -sin(roll); ...
0 sin(roll) cos(roll)];

global_rotation = rot_z * rot_y * rot_x;
end % end function
