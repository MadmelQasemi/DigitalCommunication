%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Name: Brianna, Madmel
% Date: 12.05.2025
%
% this function maps the bits from channel to defined alphabet
% that can be modulated later. This shrinks the data amount and works fast
% Input: bits from channel and the symbols
% Output: a vector with alphabets that represent the bits from channel
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function bitsAsSymbols = symbolMapping(channelBits, alphabet, method, barkerCode)
% to use the barkercode change bitsAsSymbols to resultWithBarker!

% variables for calculation and control
global LookUpTable;
len = length(alphabet);
countBitPerSymbol = log2(len);


% calculate the generator matrix
genMatrix = generatorMatrix(countBitPerSymbol);
bits = (0:len-1);
bitOrder = dec2bin(bits, countBitPerSymbol)-'0';
disp('possible bits');
disp(bitOrder);

% generate gray code of the sended bits
gray = multToGray(len, bitOrder,genMatrix);

% generate Look up table
disp('symbols with the bit commbination they represent');
LUT = genLut(len, countBitPerSymbol, alphabet, gray);
LookUpTable = LUT;

if (method == "ASK")
    % adapt the length of the bitstream (one extra bit at the beginning)
    channelBits = channelBits(2:end);
    % calculate how many rows the result matrix needs
    rowCount = (length(channelBits))/countBitPerSymbol;
    % shape the stream into a matrix with right count of bits
    % in each row for mapping
    channelBits = reshape(channelBits,2,[])';

    % start mapping the bits into the symbols
    for m = 1:rowCount
        for n = 1:len
            if(channelBits(m,:) == LUT(n,1:countBitPerSymbol))
                bitsAsSymbols(m,1) = LUT(n,countBitPerSymbol+1);
            end
        end
    end
    resultWithBarker(:,1)=[barkerCode(1:end,1);bitsAsSymbols(1:end,1)];
    disp('bits mapped int symbols via ASK method');

elseif (method == "16QAM")

    bitNum = 4; % log2(16)
    % vector to save the values of 2D symbols
    symbols = zeros(16,4);
    index = 1;
    for j = 1:4
        for r = 1:4
            symbols(index,:) = [gray(r,:) gray(j,:)];
            index = index+1;
        end
    end

    % adapt the stream for comparing
    channelBits = channelBits(2:end);
    rowCount = length(channelBits)/bitNum;
    channelBits = reshape(channelBits,4,[])';

    % mapping into compelex values
    bitsAsSymbols = zeros(16,2); % real (first col) - imaginary (second col)
    for row = 1:rowCount
        for n = 1:4
            if (channelBits(row,1:2) == LUT(n,1:2))
                bitsAsSymbols(row,1) = LUT(n,3); % real value
            end
            if (channelBits(row,3:4) == LUT(n,1:2))
                bitsAsSymbols(row,2) = LUT(n,3); % imaginary value
            end
        end
    end

    disp('bits mapped int symbols via 16QAM method [real/imaginary]');
    
    % add barkercode at the beginning of both columns
    realWithBarker(:,1)=[barkerCode(1:end,1);bitsAsSymbols(1:end,1)];
    imaginaryWithBarker(:,1)=[barkerCode(1:end,1);bitsAsSymbols(1:end,2)];
    resultWithBarker=[realWithBarker, imaginaryWithBarker];

end
disp(bitsAsSymbols);
end