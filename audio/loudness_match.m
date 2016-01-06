function factor = loudness_match (X, fs, lkfs)
%LOUDNESS_MATCH
%   LOUDNESS_MATCH (X, fs, lkfs) calculates an amplitude multiplication factor
%   which equalizes a sound to match the specified loudness (in LKFS).
%
%   2010-02-23 by MARUI Atsushi

factor = 1.0;
factorHigh = 10^(+60/20);
factorLow = 10^(-60/20);
i = 1;

while i
  s = loudness_itu(factor * X, fs);
  k = (s - lkfs) / lkfs;
  
  disp(sprintf('%3d:   Factor %7.5f   LKFS %7.3f   (%6.2f%% difference)', i, factor, s, k*100));
  i = i + 1;
  
  if abs(k) < 0.001
    return;
  end
  
  if k < 0.0
    factorOld = factor;
    factor = (factorLow + factor) / 2.0;
    factorHigh = factorOld;
  elseif k > 0.0
    factorOld = factor;
    factor = (factorHigh + factor) / 2.0;
    factorLow = factorOld;
  end
end
