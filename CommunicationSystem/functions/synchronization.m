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

function [sym, synchronizedSignal] = synchronization(yReal, yImaginary, fsa, alpha, k, barkerCode)

global debug_synchronization
Nsam= 8;
Tsa = 1/fsa;
Tsym = Nsam * Tsa;
fBp = 1/Tsym;
nBp = 16;
n = (0:nBp-1);

%%%%%%%%%%%%%%% generate Symbolclock and apply to signal after matched filter %%%%%%%%%%%%%%%

% signal after matched filter: 
% calculate the |𝑠̂𝑝(𝑡)| (real and imaginary part seprated) 
magnitudeSignalReal = abs(yReal);
magnitudeSignalImaginary = abs(yImaginary);

% to get the start of sampling
corr = conv(magnitudeSignalReal, flipud(barkerCode));  % correlation
[maxVal, maxIdx] = max(abs(corr));

% Starte Synchronisation nach dem Barker-Code:
startSample = maxIdx + floor(length(barkerCode)/2);

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

clockReal = sign(synchedSignalToSampleReal);             % clock for real part after matched filter 
clockImaginary = sign(synchedSignalToSampleImaginaary);  % clock for imaginary part after matched filter 


% sample the signal after matched filter with the generated clock to synchronize 
[symbolsRealSampled, symbolsImaginarySampled]= sampleWithClock(clockReal, clockImaginary, yReal, yImaginary, startSample); 
synchronizedSignal = symbolsRealSampled; 

% First, calculate and plot the magnitude of the spectrum of the complex signal after the pulse
% shape filter (Figure 5).
x = (1:length(synchronizedSignal));
% plot signal with noise
fig5 = figure('Name', 'Figure 5: After Synchronization', 'NumberTitle', 'off');  
subplot(2,1,1);
plot(x, synchronizedSignal);
title('symbols after pll');

%%%%%%%%%%%%%%% Correction of the phase and Aamplitude after sampling %%%%%%%%%%%%%%%

%Amplitude Correction 
% factorReal = barkerCode(1:end)./realSignalFiltered(1:13);
% factorImaginary = barkerCode(1:end)./imaginarySignalFiltered(1:13);
% 
% factorRealSum = sum(factorReal)/13;
% factorImaginarySum = sum(factorImaginary)/13;
% 
% % get rid of the barker code and apply factor to the recieved Signal
% 
% synchronizedSignalReal =factorRealSum .* realSignalFiltered;
% synchronizedSignalImaginary =factorImaginarySum .* imaginarySignalFiltered;
% 
% resultReal =synchronizedSignalReal(14:end);
% resultImaginary =synchronizedSignalImaginary(14:end);

%synchronizedSignal = [resultReal,resultImaginary]; 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% % decode part from matched filter (just in case we need it again)
% start = 1;
% len = length(yReal);
% 
% % value detection
% index = 1;
% sym(index,1) = yReal(start);
% sym(index,2) = yImaginary(start);
% index = index+1;
% start = 8;
% 
% for n = start:8:len
%     if n > (len-8)
%         break;
%     else
%         sym(index,1)= yReal(n);
%         sym(index,2)= yImaginary(n);
%         index = index+1;
%     end
% end
% 
% disp('values of the samples on the right positions after matched filter');
% disp(sym);
% 
% % round the values
% for i = 1:length(sym)
%     if(sym(i,1)<1.5 && sym(i,1)>0)
%         sym(i,1)=1;
%     elseif(sym(i,1)<4 && sym(i,1)>1.5)
%         sym(i,1)=3;
%     elseif(sym(i,1)>-4 && sym(i,1)<-1.5)
%         sym(i,1)=-3;
%     elseif(sym(i,1)>-1.5 && sym(i,1)<0)
%         sym(i,1)=-1;
%     end
% end
% 
% for i = 1:length(sym)
%     if(sym(i,2)<1.5 && sym(i,2)>0)
%         sym(i,2)=1;
%     elseif(sym(i,2)<4 && sym(i,2)>1.5)
%         sym(i,2)=3;
%     elseif(sym(i,2)>-4 && sym(i,2)<-1.5)
%         sym(i,2)=-3;
%     elseif(sym(i,2)>-1.5 && sym(i,2)<0)
%         sym(i,2)=-1;
%     end
% end
% 
% disp('round the values to get the symbols')
% disp(sym);
% symbolvector = sym;

 sym = zeros(); 
 % decode the real part
 for i = 1:length(symbolsRealSampled)
    if(symbolsRealSampled(i)<1.5 && symbolsRealSampled(i)>0)
        sym(i,1)=1;
    elseif(symbolsRealSampled(i)<4 && symbolsRealSampled(i)>1.5)
        sym(i,1)=3;
    elseif(symbolsRealSampled(i)>-4 && symbolsRealSampled(i)<-1.5)
        sym(i,1)=-3;
    elseif(symbolsRealSampled(i)>-1.5 && symbolsRealSampled(i)<0)
        sym(i,1)=-1;
    end
 end

 % decode imaginary part
 for i = 1:length(symbolsImaginarySampled)
    if(symbolsImaginarySampled(i)<1.5 && symbolsImaginarySampled(i)>0)
        sym(i,2)=1;
    elseif(symbolsImaginarySampled(i)<4 && symbolsImaginarySampled(i)>1.5)
        sym(i,2)=3;
    elseif(symbolsImaginarySampled(i)>-4 && symbolsImaginarySampled(i)<-1.5)
        sym(i,2)=-3;
    elseif(symbolsImaginarySampled(i)>-1.5 && symbolsImaginarySampled(i)<0)
        sym(i,2)=-1;
    end
 end

 disp('Ergebnis aus gesamplete Symbole');
 disp(sym);

end