clear all
close all
clc
%% 
a = 0:1/(10*pi):2*pi;
sin_a = Sin_val(a);

figure()
scatter(a,sin_a, '.b');
