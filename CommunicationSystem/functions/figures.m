%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Name: Brianna, Madmel
% Date: 27.06.2025
% This function plots all figures
% Input: symbols, signalReal, signalImaginary, yReal, yImaginary, Tsa, Tsym, Nsym, Nsam, alphas
% Output: all figures
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function figures(symbols, signalReal, signalImaginary, yReal, yImaginary, Tsa, Tsym, Nsym, Nsam, alphas, clockReal, clockImaginary, sTX, fsa, demodulatedSignal, synchedReal, synchedImaginary, method)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% figure 1: compelex symbols after mapping
scatterplot(symbols);
title('Figure 1:Constellation after Mapping');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% figure 2: impulseresponse and transferfunction with different alphas

% time axis for the plot
vectorLen= length(signalReal);
xAchis = ((0:vectorLen-1)*Tsa);
t = (0:length(symbols)-1) * Tsym* (10^-3); % time axis for the original symbols

% plot the original symbols and the Carrier signal 
alphas = [0, 0.4, 0.7, 0.9];

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
clock_axis = ((0:length(clockReal)-1)* Tsa);

% Plot of filter output after first filter
symbolTime = (0:size(symbols,1)-1) * Tsym *(10^-3);
fig3 = figure('Name', 'Figure 3: Pulseform Filter & Matched Filter, No Noise', 'NumberTitle', 'off');                                             % real part

if method == "ASK"
    subplot(3,1,1);
end
if method == "16QAM"
    subplot(3,2,1);
end
plot(xAchis, signalReal);
hold on;
stem(symbolTime,symbols(:,1));
title('Real Impulse Response after Pulse Filter');
xlabel('Time [Tsym]');
ylabel('Real {y(n)}');

% imaginary part
if method == "16QAM"
    subplot(3,2,2);
    plot(xAchis,signalImaginary);
    hold on;
    stem(symbolTime,symbols(:,2));
    title('Imaginary Impulse Response after Pulse Filter');
    xlabel('Time [Tsym]');
    ylabel('Imaginary {y(n)}');
end

% Plot of filter output after second filter
x_axis = ((0:length(yReal)-1)*Tsa);     
% real part
if method == "ASK"
    subplot(3,1,2);
end
if method == "16QAM"
    subplot(3,2,3);
end
plot(x_axis,yReal);
hold on;
stem(clock_axis, clockReal)
title('Impulse Response after Matched Filter with Symboltakt');
xlabel('Time [Tsym]');
ylabel('Real {y(n)}');
legend('Output', 'Symbol Clock');
                                                      % imaginary part
if method == "16QAM"
    subplot(3,2,4);
    plot(x_axis,yImaginary);
    hold on;
    hold on;
    stem(clock_axis, clockImaginary)
    title('Imaginary Impulse Response after Matched Filter with Symboltakt');
    xlabel('Time [Tsym]');
    ylabel('Imaginary {y(n)}');
    legend('Output', 'Symbol Clock');
end
samplePerSymbol = 2*Nsam;
eyeX = (0:samplePerSymbol-1)*Tsa*(1e6);
max = length(yReal)-samplePerSymbol;

% Eye diagram for real part
if method == "ASK"
    subplot(3,1,3);
end
if method == "16QAM"
    subplot(3,2,5);  
end

hold on;
title('Eye Diagram for Two Symbols');
xlabel('time (normed to symbol)');
ylabel('Amplitude real');

for n = 1:Nsam:max
    symbolSamples = yReal(n:n+samplePerSymbol-1);
    plot(eyeX,symbolSamples);
end

% Eye diagram for imaginary part

if method == "16QAM"
    subplot(3,2,6);  
    hold on;
    title('Eye Diagram for Two Symbols');
    xlabel('Time (normed to symbol)');
    ylabel('Amplitude imaginär');
    
    for n = 1:Nsam:max
        symbolSamples = yImaginary(n:n+samplePerSymbol-1);
        plot(eyeX,symbolSamples);
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% figure 4: compelex values after matchedfilter with channel influence

combinedMatch = yReal+ yImaginary.*1i; 
scatterplot(combinedMatch);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% optional figure to show the signal after pulseformfilter with noise

% adding white Gaussian noise to the signal
% parameters:(signal,snr)
% Figure 3+4 Plotten alle bisherigen Diagramme auf der Empfängerseite nun mit den verrauschten Signalen. (Figure 3+4)
% filtered 

% adding white Gaussian noise to the signal
noisySignalReal = awgn(signalReal,10);                    % parameters:(signal,snr)
noisySignalImaginary = awgn(signalImaginary,10);

% plot signal with noise
fig3_4 = figure('Name', 'Figure 3+4:  Pulseform Filter & Matched Filter, with Noise', 'NumberTitle', 'off');  

% Plot of filter output after first filter
symbolTime = (0:size(symbols,1)-1) * Tsym *(10^-3);
if method == "ASK"
    subplot(3,1,1);
end
if method == "16QAM"
    subplot(3,2,1);
end
plot(xAchis, noisySignalReal);
hold on;
stem(symbolTime,symbols(:,1));
title('Noisey Real Impulse Response after Pulse Filter');
xlabel('Time [Tsym]');
ylabel('Real {y(n)}');

                                    % imaginary part
if method == "16QAM"
    subplot(3,2,2); 
    plot(xAchis,noisySignalImaginary);
    hold on;
    stem(symbolTime,symbols(:,2));
    title('Noisey Imaginary Impulse Response after Pulse Filter');
    xlabel('Time [Tsym]');
    ylabel('Imaginary {y(n)}');
end
% Plot of filter output after second filter
x_axis = ((0:length(yReal)-1)*Tsa);                   % real part

if method == "ASK"
    subplot(3,1,2);
end
if method == "16QAM"
    subplot(3,2,3);
end
plot(x_axis,yReal);
hold on;
%stem(symbolTime_1,decodedAfterSynch(:,1));
title('Real Impulse Response after Matched Filter with Noise');
xlabel('Time [Tsym]');
ylabel('Real {y(n)}');
                                                      % imaginary part
 
if method == "16QAM"
    subplot(3,2,4); 
    plot(x_axis,yImaginary);
    hold on;
    title('Imaginary Impulse Response after Matched Filter with Noise');
    xlabel('Time [Tsym]');
    ylabel('Imaginary {y(n)}');
end
samplePerSymbol = 2*Nsam;
eyeX = (0:samplePerSymbol-1)*Tsa*(1e6);
max = length(yReal)-samplePerSymbol;

% Eye diagram for real part
if method == "ASK"
    subplot(3,1,3);
end
if method == "16QAM"
    subplot(3,2,5);  
end
hold on;
title('Noise added Eye Diagram for Two Symbols');
xlabel('time (normed to symbol)');
ylabel('Amplitude real');

for n = 1:Nsam:max
    symbolSamples = yReal(n:n+samplePerSymbol-1);
    plot(eyeX,symbolSamples);
end

% Eye diagram for imaginary part
 
if method == "16QAM"
    subplot(3,2,6); 
    hold on;
    title('Noise added Eye Diagram for Two Symbols');
    xlabel('Time (normed to symbol)');
    ylabel('Amplitude imaginär');
    
    for n = 1:Nsam:max
        symbolSamples = yImaginary(n:n+samplePerSymbol-1);
        plot(eyeX,symbolSamples);
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% modulation
% Berechnen und plotten Sie zunächst den Betrag des Spektrums des komplexen Signals nach
% dem Pulsformfilter (Figure 5)
% demodulation
% Plotten Sie das Betragsspektrum |𝑺𝑻𝑿(𝒇)| des Sendesignals (in einen zweiten Subplot von
% Figure 5).

s_TX = abs(fftshift(fft(sTX)));
freqAxis = ((-length(s_TX)/2):(length(s_TX)/2)-1)/(length(s_TX)*fsa);

fig5 = figure('Name', 'Figure 5: Modulation & Demodulation ', 'NumberTitle', 'off');  
subplot(2,1,1); 
plot(freqAxis, s_TX);
xlabel('Normalized Frequency [Hz]');
ylabel('|\it{S}_{TX}(f)|');
title('Betragsspektrum |\it{S}_{TX}(f)| des nach dem Pulsformfilter');

complexSignal_RX = demodulatedSignal(:,1) + 1i * demodulatedSignal(:,2);
s_RX = abs(fftshift(fft(complexSignal_RX)));
freqAxis = ((-length(s_RX)/2):(length(s_RX)/2)-1)/(length(s_RX)*fsa);

subplot(2,1,2); 
plot(freqAxis, s_RX);
xlabel('Normalized Frequency [Hz]');
ylabel('|\it{S}_{RX}(f)|');
legend();
title('Betragsspektrum |\it{S}_{RX}(f)| des Sendesignals nach demodulation');

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Um die Kanalverzerrung zu visualisieren, plotten Sie wie schon auf der Senderseite hier
% nochmal das Konstellationsdiagramm (Realteil der Symbole auf der x-Achse, Imaginärteil
% der Symbole auf der y-Achse) (Figure 6).
%scatterplot(complexSignal_RX); % The last argument specifies the axes handle
combinedSynchronizedSignal = synchedReal + synchedImaginary.*1i;

scatterplot(complexSignal_RX);
title('Figure 6a:Constellation before Synchronization');

scatterplot(combinedSynchronizedSignal);
title('Figure 6b:Constellation after Synchronization');
end