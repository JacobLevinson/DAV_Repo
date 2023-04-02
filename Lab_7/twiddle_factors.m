%% FFT Twiddle factor calculations
clc; clear all; close all;
%We need 2 factors for a 4 pt twiddle, idk which ones tho so ill just do
%all 4
k = 1;
W1 = exp(-1j*2*pi*k/4);
k = k+1;
W2 = exp(-1j*2*pi*k/4);
k = k+1;
W3 = exp(-1j*2*pi*k/4);
k = k+1;
W4 = exp(-1j*2*pi*k/4);
