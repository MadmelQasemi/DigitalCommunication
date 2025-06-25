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


% sample the signal after matched filter with the generated clock 
[sampledReal, sampledImaginary] = sampleWithClock(clockReal, clockImaginary, yReal, yImaginary); 

% Correction of the phase and Aamplitude after sampling with 
% the impulse response from channel:
% Y(f) = H(f).X(f)  <=> H(f) = Y(f)/X(f) 

% take one input (randomly chose the third one)
input = barkerCode(3); 

% complex signal 
sampledImaginary = sampledImaginary.*1i; 
output = sampledReal + sampledImaginary; 

factor = (barkerCode(3)+barkerCode(3)*1i)/output(3); 

for i = 1: length(output)
    output(i)= output(i)*factor; 
end

% take the barkercode out then!
signal = output(14:end); 
clockReal = clockReal(14:end); 
clockImaginary = clockImaginary(14:end); 

synchedReal = real(signal); 
synchedImaginary =imag(signal); 

len = min([length(clockReal), length(synchedReal)]);
x_axis = 0:len-1;

subplot(2,1,1); 
plot(x_axis, clockReal(1:len)); hold on;
plot(x_axis, synchedReal(1:len));

subplot(2,1,2); 
plot(x_axis, clockImaginary(1:len)); hold on;
plot(x_axis, synchedImaginary(1:len));

legend('Clock', 'Signal');



end
