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

global debug_mode
Nsam= 8;
Tsa = 1/fsa;
Tsym = Nsam * Tsa;
fBp = 1/Tsym;
nBp = 16;
n = (0:nBp-1);


magnitudeSignalReal = abs(yReal);
magnitudeSignalImaginary = abs(yImaginary);

% filter coefficients of bandpass filter
BandPassFilter = cos(2*pi*fBp*n*Tsa);
BandPassFilter= BandPassFilter';

% apply bandpass to the real and imaginary part of |𝑠̂𝑝(𝑡)|
bandPassedReal = conv(magnitudeSignalReal, BandPassFilter, 'same');

if debug_mode
    disp(bandPassedReal);
end

% apply the pll to both real and imaginary part
synchedSignalToSampleReal = pll(bandPassedReal, Nsam, alpha, k);
synchedSignalToSampleImaginaary = pll(bandPassedImaginary, Nsam, alpha, k);

% create clk with pll output



% the impulse response from channel:

% take one input (randomly chose the third one)



for i = 1: length(output)
end

% take the barkercode out then!


len = min([length(clockReal), length(synchedReal)]);
x_axis = 0:len-1;

if debug_mode


end
end
