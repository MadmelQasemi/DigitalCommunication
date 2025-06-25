%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Single Carrier Communication
% Name: Brianna, Madmel
% Datum: 22.04.2025
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 1. Zur Symboltaktrückgewinnung wird also zunächst der Betrag des Basisbandsignals |𝑠̂𝑝(𝑡)| genommen.
% Anschließend wird dann zur groben Vorselektion ein Bandpass angewendet
% und schließlich führt eine PLL den Symboltakt nach, um auch Strecken mit mehreren gleichen Symbolen überbrücken zu können.
% Mit der MATLAB-Funktion sign() kann das Ausgangssignal der PLL noch in ein Rechtecksignal umgewandelt werden, um den Abtastzeitpunkt exakt zu bestimmen:

function [synchedReal, synchedImaginary, sampledReal, sampledImaginary,clockReal,clockImaginary] = synchronization(yReal, yImaginary, fsa, alpha, k, barkerCode)

global debug_synchronization
Nsam= 8;
Tsa = 1/fsa;
Tsym = Nsam * Tsa;
fBp = 1/Tsym;
nBp = 16;
n = (0:nBp-1);

% generate Symbolclock and apply to signal after matched filter 

% calculate the |𝑠̂𝑝(𝑡)| (real and imaginary part seprated from the matched filter) 
magnitudeSignalReal = abs(yReal);
magnitudeSignalImaginary = abs(yImaginary);

% filter coefficients of bandpass filter
BandPassFilter = cos(2*pi*fBp*n*Tsa);
BandPassFilter= BandPassFilter';

% apply bandpass to the real and imaginary part of |𝑠̂𝑝(𝑡)|
bandPassedReal = conv(magnitudeSignalReal, BandPassFilter, 'same');
bandPassedImaginary = conv(magnitudeSignalImaginary,BandPassFilter, 'same'); 

if debug_synchronization
    disp(bandPassedReal);
end

% apply the pll to both real and imaginary part
synchedSignalToSampleReal = pll(bandPassedReal, Nsam, alpha, k);
synchedSignalToSampleImaginaary = pll(bandPassedImaginary, Nsam, alpha, k);

% create clk with pll output
clockReal = sign(synchedSignalToSampleReal);             % clock for real part after matched filter 
clockImaginary = sign(synchedSignalToSampleImaginaary);  % clock for imaginary part after matched filter 

plot(clockReal); hold on;
plot(yReal); hold on; 
legend('Clock', 'Signal');

% sample the signal after matched filter with the generated clock 
[sampledReal, sampledImaginary] = sampleWithClock(clockReal, clockImaginary, yReal, yImaginary); 

% Correction of the phase and Aamplitude after sampling with 
% the impulse response from channel:
% Y(f) = H(f).X(f)  <=> H(f) = Y(f)/X(f) 

% take one input (randomly chose the third one)
input = barkerCode(3); 

% take one output
outputR = sampledReal(3); 
outputI = sampledImaginary(3); 

% Calculate the factor
factorR = outputR/input; 
factorI = outputI/input, 

epsilon = 0.000001; 

if factorR < epsilon
    factorR = epsilon; 
    disp('Error in correction!'); 
    synchedReal = sampledReal;  % just to avoid the errors 
else
    factorR = 1/factorR; 
    for i = 1: length(sampledReal)
        synchedReal(i)= sampledReal(i)*factorR;
    end
end

if factorI < epsilon
    factorI = epsilon; 
    disp('Error in correction!'); 
    synchedImaginary = sampledImaginary;
else
    factorI = 1/factorI; 
    for i = 1: length(sampledReal)
        synchedImaginary(i)= sampledImaginary(i)*factorI; 
    end
end

% take the barkercode out then!
synchedReal = synchedReal(14:end); 
synchedImaginary = synchedImaginary(14:end);
sampledReal = sampledReal(14:end); 
sampledImaginary = sampledImaginary(14:end); 

end
