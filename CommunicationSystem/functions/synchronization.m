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

function synchronizedSignal = synchronization(signalMatched,fsa, alpha, k,barkerCode, yReal)
global debug_synchronization
Nsam= 8;
Tsa = 1/fsa;
Tsym = Nsam * Tsa;
fBp = 1/Tsym;
nBp = 16;
n = (0:nBp-1);

magnitudeSignal = abs(fft(yReal));

% filter coefficients of bandpass filter
BandPassFilter = cos(2*pi*fBp*n*Tsa);
BandPassFilter= BandPassFilter';

fSym = conv(magnitudeSignal(:,1), BandPassFilter, 'same');
% signalFiltered(:,2) = conv(magnitudeSignal(:,2), BandPassFilter, 'same');


if debug_synchronization
    disp(signalFiltered);
end

% apply the pll to both real and imaginary part
realSignalFiltered = pll(yReal, Nsam, alpha, k);
%imaginarySignalFiltered = pll(signalFiltered(:,2), Nsam, alpha, k);

% Amplitude Correction 
factorReal = barkerCode(1:end)./realSignalFiltered(1:13);
factorImaginary = barkerCode(1:end)./imaginarySignalFiltered(1:13);

factorRealSum = sum(factorReal)/13;
factorImaginarySum = sum(factorImaginary)/13;

% get rid of the barker code and apply factor to the recieved Signal

synchronizedSignalReal =factorRealSum .* realSignalFiltered;
synchronizedSignalImaginary =factorImaginarySum .* imaginarySignalFiltered;

resultReal =synchronizedSignalReal(14:end);
resultImaginary =synchronizedSignalImaginary(14:end);

synchronizedSignal = [resultReal,resultImaginary]; 
end