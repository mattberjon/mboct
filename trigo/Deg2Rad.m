function [rad] = Deg2Rad(deg)
% function [rad] = Deg2Rad(deg)
%
% Give the angle in radian for a given angle in degree.

if (isnumeric(deg) == 0)
  error('You must specify a scalar')
end

rad = deg*pi/180;
end

