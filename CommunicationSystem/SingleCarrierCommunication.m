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
global debug_mode

debug_mode = false;
sound_card = false;

% variables
global LookUpTable;
fsa = 48000;              % sample frequency
Nsym = 6;                 % number of the symbols for each convolution step
Nsam = 8;                 % number of the samples for one symbol
Tsym = 1 / Nsym;          % time for one symbol  
Tsa = 1 / fsa;            % periode of sampling  
alphabet = [-3,-1,1,3];   % symbols for mapping
barkerCode = [1 1 1 1 1 -1 -1 1 1 -1 1 -1 1]; % barkercode to define frames
barkerCode = barkerCode'; 
alphas = [0, 0.4, 0.7, 0.9];

if sound_card
    dac = audioDeviceWriter(fsa,"Device",'Lautsprecher (3- USB Audio CODEC )'); %output
    microphoneID = audiodevinfo(1,'Mikrofon (2- USB Audio CODEC )');
    adc = audiorecorder(fsa,16,1,microphoneID); %input
end

% message to send and recieve
msg = 'In the quantum field all possibilities are real, until reality chooses one';

% code it first 
bits = sourceCoding(msg);

if debug_mode
    disp('message after transfering into bits:');
    disp(bits); 
end

% add redundancy for the later verification (2D-Parity) 
bitsForChannel = channelCoding(bits); 

% choose your pain
% method = "ASK"; 
method = "16QAM"; 

if method == "16QAM" 
    barkerCode = 3 .* barkerCode;
end

% mapping the bits into symbols
symbols = symbolMapping(bitsForChannel, alphabet, method, barkerCode);

% choose your alpha
alpha = 0.99; 
k = 10; 

% pulseshape filter for sending 
[signalReal, signalImaginary] = pulseformFilter(symbols, alpha, method, fsa, Nsym, Nsam); 

% modulation
sTX = modulation(signalReal, signalImaginary);

if sound_card
    sTX = 0.2.*sTX; % attenuate the amplitude

    adc.record();
    disp('Start')
    pause(2)

    dac.play([zeros(10000,1); sTX'; zeros(10000,1)]); 
    pause(2)

    disp('Stop')
    adc.stop();
    sRX = adc.getaudiodata()';
    
    extractedMsg = cutOffMsg(sRX,sTX); % cheating by using sTX
    demodulatedSignal = demodulation(extractedMsg);
end

% demodulation
if ~sound_card
    demodulatedSignal = demodulation(sTX);
end

% matched filter
[yReal, yImaginary] = matchedFilter(demodulatedSignal, alpha, fsa, Nsym, Nsam); 

% Synchronization ( we have to decode here! ) 
[synchedReal, synchedImaginary, sampledR, sampledI,clockReal,clockImaginary ] = synchronization(yReal, yImaginary, fsa, alpha, k, barkerCode);

% decode after synchronisation
decodedAfterSynch = decodeTheSymbols(synchedReal, synchedImaginary); 

% get the channel coded stream back
stream = symbolDemapping(decodedAfterSynch, alphabet, method); 

% verify the code and extract the original bits
rawBits = channelDecoding(stream); 

% translate for non-binary speaking folks
message = sourceDecoding(rawBits);
disp("Received Message: ");
disp(message)

% all plots in one function
figures(symbols, signalReal, signalImaginary, yReal, yImaginary, Tsa, Tsym, Nsym, Nsam, alphas, clockReal, clockImaginary, sTX, fsa, demodulatedSignal, synchedReal, synchedImaginary, method); 