%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Single Carrier Communication
% Name: Brianna, Madmel 
% Datum: 22.04.2025
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc
clear
close all
addpath('functions\');
fsa = 48000;

dac = audioDeviceWriter(fsa,"Device",'Lautsprecher (2- USB Audio CODEC )');
microphoneID = audiodevinfo(1,'Mikrofon (USB Audio CODEC )');
adc = audiorecorder(fsa,16,1,microphoneID);


% variables
global LookUpTable;
% symbols for mapping
alphabet = [-3,-1,1,3];

% message to send and recieve
msg = 'In the quantum field all possibilities are real, until reality chooses one';

% code it first 
bits = sourceCoding(msg);  
disp('message after transfering into bits:');
disp(bits); 
disp('Start')
pause(2)

% add redundancy for the later verification (2D-Parity) 
bitsForChannel = channelCoding(bits); 

% choose your pain
% method = "ASK"; 
method = "16QAM"; 

% mapping the bits into symbols
symbols = symbolMapping(bitsForChannel, alphabet, method);

% choose your alpha
alpha = 0.9; 
% alpha = 0.5;

% pulseshape filter for sending 
[signal, signalReal, signalImaginary] = pulseformFilter(symbols,alpha, method); 

% modulation
s_TX = modulation(signalReal, signalImaginary);

% we send it into the channel with the help of the soundcard
adc.record();
disp('Start')
pause(2)

dac.play([zeros(10000,1); s_TX'; zeros(10000,1)]);
pause(2)

disp('Stop')
adc.stop();
s_RX = adc.getaudiodata()';

% we have to cut arounf (3.4 to 3.6) theshold over 0.5 

% demodulation
demodulatedSignal = demodulation(s_RX);

% matched filter
decodedSymbols = matchedFilter(demodulatedSignal,alpha); 

% get the channel coded stream back
stream = symbolDemapping(decodedSymbols, alphabet, method); 

% verify the code and extract the original bits
rawBits = channelDecoding(stream); 

% translate for non-binary speaking folks
message = sourceDecoding(rawBits);


