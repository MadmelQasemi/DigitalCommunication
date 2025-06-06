%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Name: Brianna, Madmel
% Date: 17.05.2025
% This function apply the pulseshape filter to the symbols for a
% high qualitative transfer of the signal
%
% Input: the symbols and a factor for the gradient of the signal
% Output: signal after convolution with root raised cosine
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [signal,signalReal, signalImaginary] = pulseformFilter(symbols, alpha, method,fsa, Nsym, Nsam)

% variables needed
Tsym = 1 / Nsym;  % time per symbol
Tsa = 1/fsa;      % sample time
index = 1;        % variable for loop control


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

% save the old values to plot later - *** To Do: would remove. have original signal 
% real = realSymbolsVector;
% imaginary = imaginarySymbolVector;

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

% pulseshape filter is applied separately (first convolution with root raised cos before modulation)
signalReal = conv(realSymbolsVector,rootRaisedCos,'same');
signalImaginary = conv(imaginarySymbolVector,rootRaisedCos,'same');

% define the outputs immediately *** To Do: I would remove this. We can
% just redefine the noisey signals
% signalReal = signalReal;
% signalImaginary = signalImaginary; 

% time axis for the plot
vectorLen= length(signalReal);
xAchis = ((0:vectorLen-1)*Tsa);
t = (0:length(symbols)-1) * Tsym* (10^-3); % time axis for the original symbols

% plot the original symbols and the Carrier signal 
% Plot the filter's impulse response and transfer function for different values of alpha in one figure and two subplots for comparison. (Figure 2
alphas = [0, 0.4, 0.7, 0.9];

figure                                             % real part
subplot(2,1,1);
hold on;
for a = 1:length(alphas)
    alpha_t = alphas(a);
    h = rcosdesign(alpha_t,Nsym,Nsam,'sqrt');
    scale = sum(h);
    normalized_hrc = h/scale;
    t = (0:length(h)-1); % time axis for the original symbols
    plot(t,normalized_hrc,'DisplayName', sprintf('\\alpha = %.2f', alpha_t));
end
title('Impulse Response of the Filter with different Alphas');
xlabel('Time [Tsym]');
ylabel('h(t)');
legend;
grid on;

subplot(2,1,2);
f = linspace(-0.5, 0.5, 1024);   % Normalized frequency
hold on;
for a = 1:length(alphas)
    alpha_t = alphas(a);
    h = rcosdesign(alpha_t,Nsym,Nsam,'sqrt');
    scale = sum(h);
    normalized_hrc = h/scale;
    transfer_function = fftshift(abs(fft(normalized_hrc, 1024))); % fft n = 1024 may need to be increased if not fine enough
    plot(f,transfer_function,'DisplayName', sprintf('\\alpha = %.2f', alpha_t));
end
title('Transfer Function with different Alphas');
xlabel('Frequency [1/Tsym]');
ylabel('|H(f)|');
legend;
grid on;

% Plot the filter output and the input symbols. (Figure 3)
% plot the original soymbols and the signal that suppose to transfer them
symbolTime = (0:size(symbols,1)-1) * Tsym *(10^-3);
figure;                                             % real part
subplot(2,1,1);
plot(xAchis, signalReal);
hold on;
stem(symbolTime,symbols(:,1));
title('Real Impulse Response after Pulse Filter');
xlabel('Time [Tsym]');
ylabel('Real {y(n)}');

subplot(2,1,2);                                     % imaginary part
plot(xAchis,signalImaginary);
hold on;
stem(symbolTime,symbols(:,2));
title('Imaginary Impulse Response after  Pulse Filter');
xlabel('Time [Tsym]');
ylabel('Imaginary {y(n)}');

% adding white Gaussian noise to the signal
%signalReal = awgn(signalReal,10);                    % parameters:(signal,snr)
%signalImaginary = awgn(signalImaginary,10);

% plot signal with noise
% figure;
% subplot(2,1,1);
% plot(xAchis, signalReal);
% title('signal representing the real values + noise');

subplot(2,1,2);
plot(xAchis, signalImaginary);
title('signal representing the imaginary values + noise');


% puting the new representation of the signal into one matrix for later
for i = 1:vectorLen
    signal(i,1)= signalReal(i);
    signal(i,2)= signalImaginary(i);
end

end