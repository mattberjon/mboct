function [devicesinfo] = GetDevices()
%
% function [devicesinfo] = getdevices()
%
% extract basic information (id and device name) from playrec getDevices
% function.
%
% Deprecated!!!
% Use GetDeviceId instead.

devicesinfoall = playrec('getDevices');
devicesinfo.min = [{devicesinfoall.('deviceID')}' {devicesinfoall.('name')}'];
id = {devicesinfoall.('deviceID')};
devicesinfo.id = cell2mat(id);
devicesinfo.raw = devicesinfoall;
end
