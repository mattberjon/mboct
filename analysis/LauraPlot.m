function [fighandle p50] = LauraPlot (filename)
% function [fighandle p50] = LauraPlot (filename)
%
% Plot the psychometric function for the intensity experiment
%
% Input Arguments
%
% **  filename [string]
%     filename of the .dat file required for the analysis. In order to get 
%     everything working with this function the filename must follow this
%     rule: 
%       * participant initials (2 letters), 
%       * condition (2 numbers),
%       * session (2 letters).
%
%     example: matthieu berjon, 55dB, session 1
%               mb_55_s1.dat
%     example: matthieu berjon, 40, pilot session
%               mb_40_ps.dat
%
%
% Output arguments
%
%     p50 [scalar]
%     Point of subjective equality.
%
%     fighandle [scalar]
%     Handle to the figure
%   
%
% More information
%
% The file contains on each line the following data
% test speed; standard intensity; direction; presentation; answer
%
% test speed: degree/sec
% standard intensity: decibels
% direction: 0 = left to right; 1 = right to left
% presentation: 0 = standard then test; 1 = test then standard
% answer: 0 = first goes faster; 1 = second goes faster
%
% We want to display on x (the speed) and on y (the test appears faster)
%
%
%
% KNOWN BUGS
% 
% No known bugs
%
%
% TODO
%
% No todo
%
%
% modified: 08 Feb 2013
% author: matthieu berjon <matthieu.berjon@wavefield.fr>
% licence: BSD


% depending on the Operating system the path where are stored the data will be
% different
if IsOs('WIN')
  pathname = 'D:\phd\data\intensity\orig';
else
  pathname = '/home/mattberjon/phd/data/intensity/orig';
end

% we get information according to the name file
participant = filename(1:2);
intensity = filename(4:5);
session = filename(7:8);

% data loading
data = load ([pathname '/' filename]);

% store the data in a new variable
data_cur = data;

% speed and answers ID related to the current data format
SPD = 1;
RSP = 5;

% speeds and answers in new variables
speeds_cur = data_cur(:, SPD);
answers_cur = data_cur(:, RSP);

% extraction of the range of speeds used
speeds_u = unique (speeds_cur);

% some trials have the presentation inversed we need to inverse the answer in 
% order to get all trials as standard then test presentation and inverse the 
% related answers
pres_id = find (data_cur(:, 4) == 1);
answers_cur(pres_id) = ~answers_cur(pres_id);

% Now we compute the percentage of good answers for each test conditions
for a = 1:length (speeds_u)
  % we look for trials corresponding to the given test value
  id = find (speeds_cur == speeds_u(a));
  % we sum the answers (because it only ones or zeros
  r = sum (answers_cur(id));
  % counting of the number of trials for that condition
  n(a) = length (id);
  % percentage of the given condition
  pc(a) = r / n(a) * 100;
end

% Fitting of the points through a Probit analysis
[fit_signal prob_perc p50] = ProbitFit (speeds_u', pc, n);

% some parameters for plotting such as color, marker for the points and the
% size of the labels
color = [27 158 119] / 255;
marker = ['o'];
label_size = 18;
text_size = 14;
% to place some information correctly we need to convert some units in 
% percentages
speeds_range = max (speeds_u) - min (speeds_u);
margin = 2 * speeds_range / 100;
% plot infos
infos = {['participant: ' participant]; ...
        ['session: ' session]; ...
        ['condition: ' intensity]; ...
        ['P50: ' num2str(p50)]};

% creation of new figure
fighandle = figure();
% points representing the percentages
plot (speeds_u, pc, marker, 'MarkerFaceColor', color, 'MarkerEdgeColor', color)
% hold on let us to draw several things on the same figure (otherwise it will 
% erase what we drawn before and plot the new result
hold on
% psychometric fit
plot (fit_signal, prob_perc, 'Color', color, 'LineWidth', 2)
% line representing the p50 along the X axis
plot ([min(speeds_u) max(speeds_u)], [50 50], 'k', 'LineStyle', '-.')
% line representing the p50 along the Y axis
plot ([p50 p50], [0 50], 'Color', color, 'LineStyle', '--')
% information about the participant, session and p50
text ((min(speeds_u)+margin), 80, infos, 'FontSize', text_size)
% label on X
xlabel ('test speeds (deg/s)', 'FontSize', label_size)
% label on Y
axis ([min(speeds_u) max(speeds_u) 0 100])
ylabel ('test perceived as fastest (%)', 'FontSize', label_size)
set (gca, 'YTick', [0 50 100])
end
