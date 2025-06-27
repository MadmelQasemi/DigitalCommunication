%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Name: Brianna, Madmel
% Date: 17.05.2025
% This function apply the pulseshape filter to the symbols for a
% high qualitative transfer of the signal
%
% Input: the symbols and a factor for the gradient of the signal
% Output: signal after convolution with root raised cosine
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [signalReal, signalImaginary] = pulseformFilter(symbols, alpha, method,fsa, Nsym, Nsam)
global debug_mode;  % global variable for debugging
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

% amplify the signal to hear it better later
realSymbolsVector = Nsam * upsample(realSymbolsVector,Nsam);
imaginarySymbolVector = Nsam * upsample(imaginarySymbolVector,Nsam);

if debug_mode
    % plot after seprating the real and imaginary parts
    disp('real symbol vector after the amplification and upsampling');
    disp(realSymbolsVector);
    disp('imaginary symbol vector after the amplification and upsampling');
    disp(imaginarySymbolVector);
end

% the root raised cos coefficients are given by the following function
h = rcosdesign(alpha,Nsym,Nsam,'sqrt');

% normalisation
scale = sum(h);
rootRaisedCos = h/scale;

% pulseshape filter is applied separately (first convolution with root raised cos before modulation)
signalReal = conv(realSymbolsVector,rootRaisedCos,'same');
signalImaginary = conv(imaginarySymbolVector,rootRaisedCos,'same');


% puting the new representation of the signal into one matrix for later
for i = 1:length(signalReal)
    signal(i,1)= signalReal(i);
    signal(i,2)= signalImaginary(i);
end

end