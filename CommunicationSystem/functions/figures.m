%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Name: Brianna, Madmel
% Date: 27.06.2025
% This function plots all figures
% Input: symbols, signalReal, signalImaginary, yReal, yImaginary, Tsa, Tsym, Nsym, Nsam, alphas
% Output: all figures
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function figures(symbols, signalReal, signalImaginary, yReal, yImaginary, Tsa, Tsym, Nsym, Nsam, alphas)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% figure 1: compelex symbols after mapping
scatterplot(symbols);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% figure 2: impulseresponse and transferfunction with different alphas

% time axis for the plot
vectorLen= length(signalReal);
xAchis = ((0:vectorLen-1)*Tsa);
% time axis for the original symbols
t = (0:length(symbols)-1) * Tsym* (10^-3); 

fig2 = figure('Name', 'Figure 2: Impulsantword des Filters & Übertragungsfuntion vergleich', 'NumberTitle', 'off');                                            % real part
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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% figure 3: 3 subplots
% 1.plot the real and imaginary part after pulseformfilter with symbols
% 2.plot after second filter implementation -> matched filter
% 3.plot the eyediagramm

% Plot of filter output after first filter
symbolTime = (0:size(symbols,1)-1) * Tsym *(10^-3);
fig3 = figure('Name', 'Figure 3: Pulseform Filter & Matched Filter, No Noise', 'NumberTitle', 'off');                                             % real part
subplot(3,2,1);
plot(xAchis, signalReal);
hold on;
stem(symbolTime,symbols(:,1));
title('Real Impulse Response after Pulse Filter');
xlabel('Time [Tsym]');
ylabel('Real {y(n)}');

subplot(3,2,2);                                     % imaginary part
plot(xAchis,signalImaginary);
hold on;
stem(symbolTime,symbols(:,2));
title('Imaginary Impulse Response after Pulse Filter');
xlabel('Time [Tsym]');
ylabel('Imaginary {y(n)}');

% Plot of filter output after second filter
x_axis = ((0:length(yReal)-1)*Tsa);                   % real part
symbolTime_1 = (0:size(symbols,1)-1) * Tsym *(10^-3);
subplot(3,2,3);  
plot(x_axis,yReal);
hold on;
%stem(symbolTime_1,decodedAfterSynch(:,1));
title('Real Impulse Response after Matched Filter');
xlabel('Time [Tsym]');
ylabel('Real {y(n)}');
                                                      % imaginary part
subplot(3,2,4);  
plot(x_axis,yImaginary);
hold on;
% stem(symbolTime_1,decodedAfterSynch(:,2));
title('Imaginary Impulse Response after Matched Filter');
xlabel('Time [Tsym]');
ylabel('Imaginary {y(n)}');

samplePerSymbol = 2*Nsam;
eyeX = (0:samplePerSymbol-1)*Tsa*(1e6);
max = length(yReal)-samplePerSymbol;

% Eye diagram for real part
subplot(3,2,5);  
hold on;
title('Eye Diagram for Two Symbols');
xlabel('time (normed to symbol)');
ylabel('Amplitude real');

for n = 1:Nsam:max
    symbolSamples = yReal(n:n+samplePerSymbol-1);
    plot(eyeX,symbolSamples);
end

% Eye diagram for imaginary part
subplot(3,2,6);  
hold on;
title('Eye Diagram for Two Symbols');
xlabel('Time (normed to symbol)');
ylabel('Amplitude imaginär');

for n = 1:Nsam:max
    symbolSamples = yImaginary(n:n+samplePerSymbol-1);
    plot(eyeX,symbolSamples);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% figure 4: compelex values after matchedfilter with channel influence

combinedMatch = yReal+ yImaginary.*1i; 
scatterplot(combinedMatch);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% optional figure to show the signal after pulseformfilter with noise

% adding white Gaussian noise to the signal
% parameters:(signal,snr)
noisySignalReal = awgn(signalReal,10);                   
noisySignalImaginary = awgn(signalImaginary,10);

% plot signal with noise
fig5 = figure('Name', 'Figure 5: pulseformfilter signal with noise', 'NumberTitle', 'off');  
subplot(2,1,1);
plot(xAchis, noisySignalReal);
title('signal representing the real values + noise');

subplot(2,1,2);
plot(xAchis, noisySignalImaginary);
title('signal representing the imaginary values + noise');

% Plot of filter output after first filter
symbolTime = (0:size(symbols,1)-1) * Tsym *(10^-3);
fig3 = figure('Name', 'Figure 3: Pulseform Filter & Matched Filter, with Noise', 'NumberTitle', 'off');                                             % real part
subplot(3,2,1);
plot(xAchis, noisySignalReal);
hold on;
stem(symbolTime,symbols(:,1));
title('Real Impulse Response after Pulse Filter');
xlabel('Time [Tsym]');
ylabel('Real {y(n)}');

subplot(3,2,2);                                     
plot(xAchis,signalImaginary);
hold on;
stem(symbolTime,symbols(:,2));
title('Imaginary Impulse Response after Pulse Filter');
xlabel('Time [Tsym]');
ylabel('Imaginary {y(n)}');

% Plot of filter output after second filter
x_axis = ((0:length(yReal)-1)*Tsa);                   % real part
symbolTime_1 = (0:size(symbols,1)-1) * Tsym *(10^-3);
subplot(3,2,3);  
plot(x_axis,yReal);
hold on;
%stem(symbolTime_1,decodedAfterSynch(:,1));
title('Real Impulse Response after Matched Filter');
xlabel('Time [Tsym]');
ylabel('Real {y(n)}');
                                                      % imaginary part
subplot(3,2,4);  
plot(x_axis,yImaginary);
hold on;
% stem(symbolTime_1,decodedAfterSynch(:,2));
title('Imaginary Impulse Response after Matched Filter');
xlabel('Time [Tsym]');
ylabel('Imaginary {y(n)}');

samplePerSymbol = 2*Nsam;
eyeX = (0:samplePerSymbol-1)*Tsa*(1e6);
max = length(yReal)-samplePerSymbol;

% Eye diagram for real part
subplot(3,2,5);  
hold on;
title('Eye Diagram for Two Symbols');
xlabel('time (normed to symbol)');
ylabel('Amplitude real');

for n = 1:Nsam:max
    symbolSamples = yReal(n:n+samplePerSymbol-1);
    plot(eyeX,symbolSamples);
end

% Eye diagram for imaginary part
subplot(3,2,6);  
hold on;
title('Eye Diagram for Two Symbols');
xlabel('Time (normed to symbol)');
ylabel('Amplitude imaginär');

for n = 1:Nsam:max
    symbolSamples = yImaginary(n:n+samplePerSymbol-1);
    plot(eyeX,symbolSamples);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end