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

function [synchedReal, synchedImaginary, sampledReal, sampledImaginary] = synchronization(yReal, yImaginary, fsa, alpha, k, barkerCode)

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

% take the input
input = fft(barkerCode); 

% take the output
outputReal = fft(sampledReal(1:13));
outputImaginary = fft(sampledImaginary(1:13));

% Calculate the Impulseresponse of the channel in frequency spectrum 
hfReal = outputReal./input;
hfImaginary = outputImaginary./input;
epsilon = 0.000001; 

% reciprocal of the impulsereponses
for n = 1:length(hfReal)
    % we do not want to divide by zero ;)
    if (hfReal(n)<epsilon)
        hfReal(n) =epsilon; 
    end
    if (hfImaginary(n)<epsilon)
        hfImaginary(n)= epsilon; 
    end
    % we want to take away the influence of the channel so the division
    realHfinverted(n) = 1/hfReal(n); 
    imaginaryHfinverted(n) = 1/hfImaginary(n); 
end

% bring it in time domain for convolution
 % did not work -> huge values
%zeroFilterReal = ifft(realHfinverted);   
%zeroFilterImaginary = ifft(imaginaryHfinverted); 

% chat gpt suggestion: %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

zeroFilterReal = ifft(realHfinverted, 'symmetric');  % nur wenn das Signal reell ist
zeroFilterImaginary = ifft(imaginaryHfinverted, 'symmetric'); 

zeroFilterReal = zeroFilterReal / norm(zeroFilterReal); 
zeroFilterImaginary = zeroFilterImaginary / norm(zeroFilterImaginary); 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

synchedReal = conv(sampledReal, zeroFilterReal,'same');
synchedImaginary = conv(sampledImaginary, zeroFilterImaginary,'same'); 

synchedReal = synchedReal(14:end); 
synchedImaginary = synchedImaginary(14:end);
sampledReal = sampledReal(14:end); 
sampledImaginary = sampledImaginary(14:end); 

end
