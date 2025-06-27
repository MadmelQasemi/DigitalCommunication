%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Name: Brianna, Madmel 
% Date: 12.05.2025
% This function maps the order of the bits to the symbols
%
% Input: length of the symbols and number of cols (log2 of the symbol nums)
% the alphabet vector and matrix of possible bits 
% Output: Matrix which contains both bitorder and the symbol
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function LUT = genLut(rowNum,colNum,alphabet,bitOrder)
global debug_mode
% make a look up table
LUT = zeros(rowNum,colNum+1);

% copy bitOrder
LUT(:,1:colNum) = bitOrder; 

% fill the last column with matching alphabet
LUT(:,end)= alphabet(:);

% show the table 
if debug_mode
    disp(LUT); 
end
end