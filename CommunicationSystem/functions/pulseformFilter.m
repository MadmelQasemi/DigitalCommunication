%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Name: Brianna, Madmel
% Date: 17.05.2025
% This function apply the pulseshape filter to the symbols for a
% high qualitative transfer of the signal
%
% Input: the symbols and a factor for the gradient of the signal
% Output: signal after convolution with root raised cosine
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [signal,signalReal, signalImaginary] = pulseformFilter(symbols, alpha, method)

% variables needed
Nsym = 6;          % number of the symbols for each convolution step
Nsam = 8;          % number of the samples for one symbol
Tsym = 1 / Nsym;   % time for sending one symbol
fsa = 48000;       % sample frequency
Tsa = 1/fsa;       % sample time
index = 1;         % variable for loop control


%  adapt the vector of symbols (isolate real and imaginary parts)
symbolsVector = reshape(symbols,1,[]);

if (method == "ASK")
    rows = length(symbols);
    for i = 1: rows
        realSymbolsVector(i) = symbolsVector(i);
        imaginarySymbolVector(i)= 0; % set the imaginary part = 0
    end
else  % if method == "QAM16"
    rows = size(symbols,1);
    for i = 1: rows
        realSymbolsVector(i) = symbolsVector(i);
        imaginarySymbolVector(index)= symbolsVector(rows+1);
        rows = rows+1; index = index+1;
    end
end

% save the old values to plot later
real = realSymbolsVector;
imaginary = imaginarySymbolVector;

% amplify the signal to hear it better later
realSymbolsVector = Nsam*upsample(realSymbolsVector,Nsam);
imaginarySymbolVector =Nsam* upsample(imaginarySymbolVector,Nsam);

% plot after seprating the real and imaginary parts
disp('real symbol vector after the amplification and upsampling');
disp(realSymbolsVector);
disp('imaginary symbol vector after the amplification and upsampling');
disp(imaginarySymbolVector);

% the root raised cos coefficients are given by the following function
h = rcosdesign(alpha,Nsym,Nsam,'sqrt');

% normalisation
scale = sum(h);
rootRaisedCos = h/scale;

% pulseshape filter is applied sepreatly (first convolution with root raised cos before modulation)
yReal = conv(realSymbolsVector,rootRaisedCos,'same');
yImaginary = conv(imaginarySymbolVector,rootRaisedCos,'same');

% define the outputs immediatly
signalReal = yReal;
signalImaginary = yImaginary; 

% time axis for the plot
vectorLen= length(yReal);
xAchis = ((0:vectorLen-1)*Tsa);
t = (0:length(real)-1) * Tsym* (10^-3); % time axis for the original symbols

% plot the original soymbols and the signal that suppose to transfer them
figure;                                             % real part
subplot(2,1,1);
plot(xAchis, yReal);
hold on;
plot(t,real,'x');
title('Real Impulse Response after pulsefilter');

subplot(2,1,2);                                     % imaginary part
plot(xAchis,yImaginary);
hold on;
plot(t,imaginary,'x');
title('Imaginary Impulse Response after pulsefilter');

% adding white Gaussian noise to the signal
%yReal = awgn(yReal,10);                    % parameters:(signal,snr)
%yImaginary = awgn(yImaginary,10);

% plot signal with noise
% figure;
% subplot(2,1,1);
% plot(xAchis, yReal);
% title('signal representing the real values + noise');

subplot(2,1,2);
plot(xAchis, yImaginary);
title('signal representing the imaginary values + noise');


% puting the new representation of the signal into one matrix for later
for i = 1:vectorLen
    signal(i,1)= yReal(i);
    signal(i,2)= yImaginary(i);
end

end