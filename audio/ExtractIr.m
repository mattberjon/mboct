function [] = ExtractIr (ir_path_in, ir_path_out, inv_sweep_path)
% function [] = ExtractIr (ir_path_in, ir_path_out, inv_sweep_path)
%
% Extract the impulse response from raw files obtained from GetSweepResp.
%
% Important notice: the read files must be wav files in inputs with the
% following naming: n.wav where n is the number of the speaker. It is really
% important to use open formats for data storing.
%
% This function use fftfilt that is not avalaible in default versions of
% Matlab (use Octave instead).
%
% Input arguments
%   
%     The compulsory arguments are preceed by **.
%
% **  ir_path_in [char]
%       Absolute or relative path to the the impulse(s). If you specify a 
%       folder, the program will check all wav IR in it.
%
% **  ir_path_out [char]
%       Absolute or relative path where you want to store the IRs.
%
% **  inv_sweep_path [char]
%       Absolute or relative path and name of the inverse sweep for
%       convolution in order to get the impulse response.
%
%
% Output arguments
%
%   No output arguments. The impulse response will be stored as wav files in
%   the 'ir' folder.
%
%
% EXAMPLES
%
% ExtractIr ('/home/user/data/ir', '/home/user/data/sound/i_sweep.wav')
%
%
% KNOWN BUGS
%
% No known bugs
%
%
% TODO
%
% - at the moment the IR are cutted and last 0.6 seconds. If the IR has to 
%   be longer... you have to change the code. The problem is for files that
%   contains several channels (that represent different microphone, hence
%   several different positions, hence different path and hence different
%   length...)
%
%
% modified: 08 January 2013
% author: Matthieu Berjon <matthieu.berjon@wavefield.fr>
% licence: BSD

if isempty (regexp (ir_path_in, '\.wav$'))
  ir_names = dir ([ir_path_in '/*.wav']);
  ir_nb = length (ir_names);
  % get the numbers of the files
  ir_nb_names_sort = GetWavFilesNb (ir_path_in);
else
  ir_names = ir_path_in;
  ir_nb = 1;
  ir_nb_names_sort = 1;
end

[i_sweep isweep_fs] = wavread(inv_sweep_path);

for b = 1:length (ir_nb_names_sort)
  if isempty (regexp (ir_path_in, '\.wav$'))
    raw_ir_path = [ir_path_in '/' num2str(ir_nb_names_sort(b)) '.wav'];
  else
    raw_ir_path = ir_names;
  end

  [raw_ir raw_fs] = wavread (raw_ir_path);
  [raw_ir_info] = wavread (raw_ir_path, 'size');
  
  if isweep_fs == raw_fs
    for c = 1:raw_ir_info(2)
      ir(:, c) = fftfilt(i_sweep, raw_ir(:, c));
      % normalisation
      ir(:, c) = ir(:, c) .* (max (abs (raw_ir(:, c))) / ...
        max (abs (ir(:, c))));

      % cutting of the IR in order to get read of the silence
      [ir_max ir_max_id] = max (abs (ir(:, c)));
      ir_cutted(:, c) = ir((ir_max_id - 200):((ir_max_id - 200) + 0.6*raw_fs), c);
    end
    
    wavwrite (ir_cutted, raw_fs, ...
      [ir_path_out '/' num2str(ir_nb_names_sort(b)) '.wav']);
  else
    disp (['Samplerates don''' 't match for speaker ' num2str(b)]);
  end

end
