%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Name: Madmel 
% Date: 22.04.2025
%
% Input: bin: vector of bit values (0 or 1) MSB at index 1
% Output: decimal number (in the range 0...2^N-1)
% 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function dec = binVecToDec(bin)
dec = bi2de(bin, 'left-msb'); 
end