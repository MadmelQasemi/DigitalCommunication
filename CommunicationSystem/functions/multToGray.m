%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Name: Brianna, Madmel 
% Date: 12.05.2025
% The gray coding via multiplication with the Generator Matrix takes 
% place here
% Input: dimension of the Matrix 
% Output: generator matrix with given dimension for gray coding
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function gray = multToGray(numRows,bits,matrix)
global debug_mode

% multiply each row to the genMatrix and save
for n = 1:numRows
    % save the lines 
    row = bits(n,:); 
    % mod function to avoid "2" after multiplication
    temp = mod(row*matrix,2);  
    % write in the result matrix
    gray(n,:)= temp; 
end

if debug_mode
    disp('bits after the Hamming distance is applied');
    disp(gray)
end
end