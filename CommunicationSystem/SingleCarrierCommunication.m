%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Single Carrier Communication
% Name: Brianna, Madmel 
% Datum: 22.04.2025
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Going through code and added " *** To Do: " to places I think should be
% removed or changed
% add a figure at the end of matchedfilter instead of demodulation

clc
clear
close all
addpath('functions\');

% debug modes true = show disp(), false = disable disp()
global debug_channelCoding
global debug_channelDecoding
global debug_modulation
global debug_demodulation
global debug_sourceCoding
global debug_generatorMatrix
global debug_synchronization
global debug_symbolMapping

debug_sourceCoding = true;
debug_channelCoding = true;
debug_generatorMatrix = true;
debug_synchronization = true;
sound_card = false;
debug_symbolMapping = true;
debug_channelDecoding = true;

if sound_card
    dac = audioDeviceWriter(fsa,"Device",'Lautsprecher (2- USB Audio CODEC)'); %output
    microphoneID = audiodevinfo(1,'Mikrofon (USB Audio CODEC )');
    adc = audiorecorder(fsa,16,1,microphoneID); %input
end

% variables
global LookUpTable;
fsa = 48000;              % sample frequency
Nsym = 6;                 % number of the symbols for each convolution step
Nsam = 8;                 % number of the samples for one symbol
Tsym = 1 / Nsym;          % time for one symbol  
Tsa = 1 / fsa;            % periode of sampling  
alphabet = [-3,-1,1,3];   % symbols for mapping
barkerCode = 3 * [1 1 1 1 1 -1 -1 1 1 -1 1 -1 1]; % barkercode to define frames
barkerCode = barkerCode'; 

% message to send and recieve
msg = 'In the quantum field all possibilities are real, until reality chooses one';

% code it first 
bits = sourceCoding(msg);

if debug_sourceCoding
    disp('message after transfering into bits:');
    disp(bits); 
end

% add redundancy for the later verification (2D-Parity) 
bitsForChannel = channelCoding(bits); 

% choose your pain
% method = "ASK"; 
method = "16QAM"; 

% mapping the bits into symbols
symbols = symbolMapping(bitsForChannel, alphabet, method, barkerCode);

% choose your alpha
alpha = 0.99; 
k = 10; 
% alpha = 0.5;

% pulseshape filter for sending 
[signal, signalReal, signalImaginary] = pulseformFilter(symbols, alpha, method, fsa, Nsym, Nsam); 

% modulation
sTX = modulation(signalReal, signalImaginary);

if sound_card
% we send it into the channel with the help of the soundcard
    adc.record();
    disp('Start')
    pause(2)

    dac.play([zeros(10000,1); sTX'; zeros(10000,1)]); 
    pause(2)

    disp('Stop')
    adc.stop();
    sRX = adc.getaudiodata()';
end

% simulate sRX to test if the extraction is correct
%sRX = [zeros(10000,1); sTX'; zeros(10000,1)];

%extractedMsg = cutOffMsg(sRX,sTX); % cheating by using sTX

% we have to cut around (3.4 to 3.6) theshold over 0.5 

% demodulation
demodulatedSignal = demodulation(sTX);

% matched filter
[yReal, yImaginary] = matchedFilter(demodulatedSignal, alpha, fsa, Nsym, Nsam); 

% Synchronization ( we have to decode here! ) 
[synchedReal, synchedImaginary, sampledR, sampledI ] = synchronization(yReal, yImaginary, fsa, alpha, k, barkerCode);

% decode after synchronisation
decodedAfterSynch = decodeTheSymbols(synchedReal, synchedImaginary); 

% get the channel coded stream back
stream = symbolDemapping(decodedAfterSynch, alphabet, method); 

%verify the code and extract the original bits
rawBits = channelDecoding(stream); 

%translate for non-binary speaking folks
message = sourceDecoding(rawBits);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% figures and diagrams

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% figure 1: Mapping - Plotten Sie die komplexen Symbole als Konstellationsdiagramm
scatterplot(symbols);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plotten Sie in eine Figure und zwei Subplots die Impulsantwort des Filters und die 
% Übertragungsfunktion zum Vergleich jeweils für unterschiedliche Werte von alpha. (Figure 2)
% time axis for the plot
% Plot the filter's impulse response and transfer function for different values of
% alpha in one figure and two subplots for comparison. (Figure 2)

vectorLen= length(signalReal);
xAchis = ((0:vectorLen-1)*Tsa);
t = (0:length(symbols)-1) * Tsym* (10^-3); % time axis for the original symbols

% plot the original symbols and the Carrier signal 
alphas = [0, 0.4, 0.7, 0.9];

fig2 = figure('Name', 'Figure 2: Pulseform Filter', 'NumberTitle', 'off');                                            % real part
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
% Plotten Sie den Ausgang des Filters und die eingegebenen Symbole. (Figure 3)
% Wenden Sie das Filter ein zweites Mal an und plotten Sie den Filterausgang. (Figure 3, Subplots)
% Plotten Sie außerdem das Augendiagramm. (Figure 3)
% Plot the filter output and the input symbols. (Figure 3)
% Apply the filter a second time and plot the filter output. (Figure 3, subplots)
% Also plot the eye diagram. (Figure 3)

% Plot of filter output after first filter
symbolTime = (0:size(symbols,1)-1) * Tsym *(10^-3);
fig3 = figure('Name', 'Figure 3: Pulseform Filter', 'NumberTitle', 'off');                                             % real part
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
ylabel('y(n)');
                                                      % imaginary part
subplot(3,2,4);  
plot(x_axis,yImaginary);
hold on;
% stem(symbolTime_1,decodedAfterSynch(:,2));
% title('Imaginary Impulse Response after Matched Filter');
% xlabel('Time [Tsym]');
% ylabel('y(n)');

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

% scatterplot
scatterplot(decodedAfterSynch);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Figure 4 Plotten alle bisherigen Diagramme auf der Empfängerseite nun mit den verrauschten Signalen. (Figure 3+4)
% filtered 
noisySignalReal = signalReal;
noisySignalImaginary = signalImaginary; 

% adding white Gaussian noise to the signal
noisySignalReal = awgn(noisySignalReal,10);                    % parameters:(signal,snr)
noisySignalImaginary = awgn(noisySignalImaginary,10);

% plot signal with noise
fig4 = figure('Name', 'Figure 4: Matched Filter', 'NumberTitle', 'off');  
subplot(2,1,1);
plot(xAchis, noisySignalReal);
title('signal representing the real values + noise');

subplot(2,1,2);
plot(xAchis, noisySignalImaginary);
title('signal representing the imaginary values + noise');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
