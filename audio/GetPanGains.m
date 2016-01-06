function [gains] = GetPanGains(spk_fmt, position, width)
% function [gains_norm] = PanGains(varargin)
%
% Compute panoramic gains according to a gaussian function. It is suitable for
% moving sound over a bunch of speakers for incoherent sounds.
%
%
% Input arguments
%
%   The compulsory arguments are preceed by **
%
% **  spk_fmt [struct]
%       Need to use GenSpkFmt function. [WIP]
%
%     pos [scalar]
%       Position of the source in degrees. If this argument is not set up,
%       then a position at 0 degree will be computed.
%
%     width [scalar]
%       Source width. If the arguement is not set up, then a width of 1 degree
%       will be computed.
%
%
% Output arguments
%
%     gains [vector]
%       Gains to apply to the signal.
%
%
% EXAMPLES
%
% GetPanGains('spk_fmt', spk_fmt)
% GetPanGains('spk_fmt', spk_fmt, 'pos', 0)
% GetPanGains('spk_fmt', spk_fmt, 'width', 10)
% GetPanGains('spk_fmt', spk_fmt, 'pos', 0, 'width', 5)
%
%
% KNOWN BUGS
%
% No known bugs.
%
% TODO
%
% - implement varargin and tests
% - implement a modified version of the algorithm that take into account
% cohenrent sounds (almost everything appart from noises) by a conditions on
% the square root.
%
% Modified: 18 June 2012
% Author: Matthieu Berjon <matthieu.berjon@wavefield.fr>
%   based on the idea of John Culling.
% License: WTFPL

  disparity = spk_fmt - position;

  if width <= 0
    width = 1;
  end

  gains = sqrt(exp(-((2*disparity/width).^2)));

  % normalisation (somme des gains au carré = 1)
  norma = sqrt(sum(gains.^2));
  gains_norm = gains ./ norma;
end
