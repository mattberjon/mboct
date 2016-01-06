function [ret_val] = IsOs(tested_os)
% function [ret_val] = IsOs(tested_os)
%
% test which Operating System you are using
%
% Input arguments
%
%     the compulsory arguments are preceed by **.
%
% **  tested_os [char]
%       has to be char OS type that you want to test.
%         - WIN: test if you use Windows
%         - MAC: test if you use MacOs
%         - UNIX: test if you use GNU/Linux or *BSD
%
% Output arguments
%
%     ret_value [scalar]
%       return 1 if true, 0 otherwise.
%
% EXAMPLES
%
% IsOs('WIN')
% IsOs('MAC')
% IsOs('UNIX')
%
% KNOWN BUGS
%
% no known bugs
%
% TODO
% 
% no todo
%
% last update: 28 March 2012
% author: matthieu berjon <matthieu.berjon@wavefield.fr>
% license: WTFPL


% test
if ~ischar(tested_os)
  error('The input has to be a char!')
end

ret_val = 0;

if strcmpi(tested_os, 'WIN')
    % This should always be able to use ispc
    ret_val = ispc;
elseif strcmpi(tested_os, 'MAC')
    % Older versions of Matlab don't have 'ismac', so assume
    % if ismac doesn't exist then it's not a mac!
    if exist('ismac', 'builtin')
    	ret_val = ismac;
    end
elseif strcmpi(tested_os, 'UNIX')
    % UNIX should not be true if it's a mac.
    ret_val = isunix;
    if exist('ismac', 'builtin')
        if ismac
            ret_val = 0;
        end
    end
else
    error ('Invalid OS type.');
end
