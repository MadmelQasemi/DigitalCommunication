%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Name: Brianna, Madmel
% Date: 27.05.2025
% This function modulates the real and imaginary part of the signal
%
% Input: signals coding the real and imaginary part of the message
% Output: modulated signal which is ready to transfer
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function signalToSend = modulation(signalReal,signalImaginary)

global debug_mode; 

% defining the variables needed
fsa = 48000;
Tsa = 1/fsa;
fCarrier = 10000;
t = (0:length(signalReal)-1);

% make a time axis
for n = 1:length(signalReal)
    m = (n-1)*Tsa;
    time(n) = m;
end

carrierSignalReal = cos(2*pi*fCarrier*time);           % real*cos
carrierSignalImaginary = -sin(2*pi*fCarrier*time);     % imaginary*-sin

% giving the signal to a carrier
signalRealModulated = carrierSignalReal .* signalReal;
signalImaginaryModulated = carrierSignalImaginary .* signalImaginary;

% adding them because we have only one channel to send
signalToSend = signalRealModulated + signalImaginaryModulated;
% add noise
% p_N= 0.1; 
% signalToSendNoisy = signalToSend + p_N * randn(size(signalToSend)); 
% signalToSend = signalToSendNoisy; 

if debug_mode
% plot the original symbols and the signal that suppose to transfer them  
figure;                                             % real part
subplot(3,1,1);
plot(time, signalRealModulated);
title('real signal after multiplication');

subplot(3,1,2);                                     % imaginary part
plot(time, signalImaginaryModulated);
title('imaginary signal after multiplication');

subplot(3,1,3);                                     % addition of both
plot(time, signalToSend);
title('signal after modulation');
end
end