function [spk_x spk_y] = DrawSpk (x0, y0, x_len, y_len, scale)

  new_x_len = x_len * scale;
  new_y_len = y_len * scale;
  
  spk_x = [x0-new_x_len x0-new_x_len/2 x0-new_x_len/2 x0+new_x_len/2 x0+new_x_len/2 x0+new_x_len x0-new_x_len];
  spk_y = [y0-new_y_len y0 y0+new_y_len y0+new_y_len y0 y0-new_y_len y0-new_y_len];
end