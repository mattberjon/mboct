function [scale_ang] = ScaleAngles(angles)
% scaling [-180 180]

  scale_ang = angles;
  scale_ang(find(scale_ang > 180)) = scale_ang(find(scale_ang > 180)) - 360;

end % end function
