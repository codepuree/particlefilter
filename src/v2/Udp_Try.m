close all, clear all, clc
%% 
ptcl = pcread('../../Data/Rundgang/Rundgang_01.ply');
data_of_interest = ptcl.Location;
s = whos('data_of_interest');

tcpipServer = tcpip('0.0.0.0',55000,'NetworkRole','Server');

set(tcpipServer,'OutputBufferSize',s.bytes);
fopen(tcpipServer);

fwrite(tcpipServer,data(:),'double');
fclose(tcpipServer);
delete(tcpipServer);
disp('Work is done');