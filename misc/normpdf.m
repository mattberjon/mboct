% function p = normpdf ( x, mean, sigma )
% % NORMPDF.M calculates and plots a
% % normal probability density function.
% 
% %===============================================
% % mean   = mean of the data vector, x
% % sigma  = standard deviation of data vector, x
% % x      = data vector over which to find p(x)
% % p(x)   = probability density function
% %===============================================
% 
% normalizer = 1/(sigma*sqrt(2*pi));
% p = normalizer*exp( -0.5*( (x - mean)/sigma ).^2 );



% % function y = normpdf(x,mu,sigma)
% % NORMPDF Normal probability density function (pdf).
% %   Y = NORMPDF(X,MU,SIGMA) Returns the normal pdf with mean, MU, 
% %   and standard deviation, SIGMA, at the values in X. 
% % 
% %   The size of Y is the common size of the input arguments. A scalar input  
% %   functions as a constant matrix of the same size as the other inputs.     
% % 
% %   Default values for MU and SIGMA are 0 and 1 respectively.
% % 
% %   References:
% %      [1]  M. Abramowitz and I. A. Stegun, "Handbook of Mathematical
% %      Functions", Government Printing Office, 1964, 26.1.26.
% % 
% % if nargin < 3, 
% %     sigma = 1;
% % end
% % 
% % if nargin < 2;
% %     mu = 0;
% % end
% % 
% % if nargin < 1, 
% %     error('Requires at least one input argument.');
% % end
% % 
% % [errorcode x mu sigma] = distchck(3,x,mu,sigma);
% % 
% % if errorcode > 0
% %     error('Requires non-scalar arguments to match in size.');
% % end
% % 
% %   Initialize Y to zero.
% % y = zeros(size(x));
% % 
% % k = find(sigma > 0);
% % if any(k)
% %     xn = (x(k) - mu(k)) ./ sigma(k);
% %     y(k) = exp(-0.5 * xn .^2) ./ (sqrt(2*pi) .* sigma(k));
% % end
% % 
% % Return NaN if SIGMA is negative or zero.
% % k1 = find(sigma <= 0);
% % if any(k1)
% %     tmp   = NaN;
% %     y(k1) = tmp(ones(size(k1))); 
% % end




function pdf = normpdf (x, m, s)
% NORMPDF  PDF of the normal distribution
%  PDF = normpdf(X, M, S) computes the probability density
%  function (PDF) at X of the normal distribution with mean M
%  and standard deviation S.
%
%  PDF = normpdf(X) is equivalent to PDF = normpdf(X, 0, 1)

% Adapted for Matlab (R) from GNU Octave 3.0.1
% Original file: statistics/distributions/normpdf.m
% Original author: TT <Teresa.Twaroch@ci.tuwien.ac.at>

% Copyright (C) 1995, 1996, 1997, 2005, 2006, 2007 Kurt Hornik
% Copyright (C) 2008 Dynare Team
%
% This file is part of Dynare.
%
% Dynare is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
%
% Dynare is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with Dynare.  If not, see <http://www.gnu.org/licenses/>.

  if (nargin ~= 1 && nargin ~= 3)
    error('normpdf: you must give one or three arguments');
  end

  if (nargin == 1)
    m = 0;
    s = 1;
  end

  if (~isscalar (m) || ~isscalar (s))
    [retval, x, m, s] = common_size (x, m, s);
    if (retval > 0)
      error ('normpdf: x, m and s must be of common size or scalars');
    end
  end

  sz = size (x);
  pdf = zeros (sz);

  if (isscalar (m) && isscalar (s))
    if (find (isinf (m) | isnan (m) | ~(s >= 0) | ~(s < Inf)))
      pdf = NaN * ones (sz);
    else
      pdf = stdnormal_pdf ((x - m) ./ s) ./ s;
    end
  else
    k = find (isinf (m) | isnan (m) | ~(s >= 0) | ~(s < Inf));
    if (any (k))
      pdf(k) = NaN;
    end

    k = find (~isinf (m) & ~isnan (m) & (s >= 0) & (s < Inf));
    if (any (k))
      pdf(k) = stdnormal_pdf ((x(k) - m(k)) ./ s(k)) ./ s(k);
    end
  end

  pdf((s == 0) & (x == m)) = Inf;
  pdf((s == 0) & ((x < m) | (x > m))) = 0;

end
