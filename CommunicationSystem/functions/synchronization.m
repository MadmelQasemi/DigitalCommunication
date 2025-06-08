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

function synchronizedSignal = synchronization(signalMatched,fsa, alpha, k)
global debug_synchronization
Nsam= 8;
Tsa = 1/fsa;
Tsym = Nsam * Tsa;
fBp = 1/Tsym;
nBp = 16;
n = (0:nBp-1);

magnitudeSignal = abs(signalMatched);

% filter coefficients of bandpass filter
BandPassFilter = cos(2*pi*fBp*n*Tsa);
BandPassFilter= BandPassFilter';
% j = 0;
%
% for i = 1:nBp:length(signalMatched)
%     j = i+15;
%     signalFiltered(i:j,1) = BandPassFilter.*magnitudeSignal(i:j,1);
%     signalFiltered(i:j,2) = BandPassFilter.*magnitudeSignal(i:j,2);
% end
signalFiltered(:,1) = conv(magnitudeSignal(:,1), BandPassFilter, 'same');
signalFiltered(:,2) = conv(magnitudeSignal(:,2), BandPassFilter, 'same');

if debug_synchronization
    disp(signalFiltered);
end

% apply the pll to both real and imaginary part
realSignalFiltered = pll(signalFiltered(:,1), Nsam, alpha, k);
imaginarySignalFiltered = pll(signalFiltered(:,2), Nsam, alpha, k);

synchronizedSignal= realSignalFiltered + 1i * imaginarySignalFiltered;

end