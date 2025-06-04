%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Name: Madmel 
% Date: 22.04.2025
%
% decToBinVec: converts decimal number to binary vector
%
% Input: - dec: decimal number (in the range 0...2^N-1)
% - N: length of the output vector (number of bits)
% Output: - bin: vector of bit values (0 or 1) MSB at index 1
% Example: decToBinVec(12,7) yields: [0 0 0 1 1 0 0]
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function bin = decToBinVec(dec,N)
bin = zeros(1,N); % prepare output vector with zeros
% for loop to calculate each bit
for i = 1:N
% calculate each single bit
bin(i) = bitand(dec,2^(N-i))>0;
end


