%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Name: Brianna, Madmel
% Date: 27.05.2025
% This function ...
%
% Input: signal which was transmitted over the channel
% Output: extract the real and imaginary signal through fft
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function signal = demodulation(transmittedSignal)

% variables
fsa = 48000;
Tsa = 1/fsa;
fCarrier = 10000;

% make a time axis
for n = 1:length(transmittedSignal)
    m = (n-1)*Tsa;
    time(n) = m;
end

carrierSignalReal = cos(2*pi*fCarrier*time);           % real*cos
carrierSignalImaginary = -sin(2*pi*fCarrier*time);     % imaginary*-sin

real = transmittedSignal.*carrierSignalReal;
imaginary = transmittedSignal.*carrierSignalImaginary; 
signalRecieved = real + imaginary; 

real = real.*2;
imaginary = imaginary.*2; 

signal = zeros(); 
rows = length(real); 
realCol = reshape(real,[],1);
imaginaryCol = reshape(imaginary,[],1);

for n = 1: rows
    signal(n,1)= realCol(n,1); 
    signal(n,2)= imaginaryCol(n,1); 
end
 
%%%%%%%%%%%%%%%%%%%%%%%%%%% frequency Domain plot %%%%%%%%%%%%%%%%%%%%%%%%%

% this signal includes both real and imaginary signal
% fft to extract all frquencies in the "mixed and added" signal
sTX = abs(fftshift(fft(transmittedSignal)));
freqAxis = ((-length(sTX)/2):(length(sTX)/2)-1)/(length(sTX)*fsa);

% plot the frequency domain
figure;
plot(freqAxis, sTX);
title('Frequency Domain of transmitted signal');

% this signal includes both real and imaginary signal recieved
% fft to extract all frquencies in the "mixed and added" signal
sRX = abs(fftshift(fft(signalRecieved)));
freqAxis = ((-length(sRX)/2):(length(sRX)/2)-1)/(length(sRX)*fsa);

% plot the frequency domain
figure;
plot(freqAxis, sRX);
title('Frequency Domain of recieved signal');
end

