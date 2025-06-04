%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Name: Brianna, Madmel 
% Date: 22.04.2025
%
% Input: Matrix of the bits (each row -> one character) 
% Output: A vector (Bitstream) which already includes the bits and the
% parities
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function vecOfParities = channelCoding(bits)

[numberOfRows, numberOfCols]= size(bits); % get the dimensions of the message

start = 1; 
N = numberOfCols; 
parityMatrix = zeros(8,8); % this Matrix will be overwritten each time 
vecOfParities = zeros();   % to save the information in one stream
missingRows = mod(numberOfRows,7); 
star = [0 1 0 1 0 1 0]; % to fill the matrix if the dimension is too small

% optimizing the dimension of bits matrix 
if missingRows > 0 
% extend bits with '*'-> 0101010 for the optimal dimension
endOfMatrix = numberOfRows+ (7 - missingRows); 
for i = (numberOfRows+1):endOfMatrix
   bits(i,1:N)= star; 
end
numberOfRows = endOfMatrix;
end

while mod(numberOfRows,7) == 0 && numberOfRows > 0
 
parityMatrix(1:N,1:N) = bits(start:(start+6),1:N);
start = start+7; 
numberOfRows = numberOfRows-7;

% Parity Column for the rows of the matrix
row = 0; 
for i = 1:7
    for j = 1:7
        row = row +parityMatrix(i,j); 
    end
    row = mod(row,2); 
    parityMatrix(i,8) = row;
    row = 0; 
end   

% Parity row for the columns of the matrix
col = 0; 
for c = 1:8
    for r = 1:7
        col = col + parityMatrix(r,c); 
    end
    col = mod(col,2); 
    parityMatrix(8,c)= col; 
    col = 0; 
end

disp('matricies after channel coding with parities');
disp(parityMatrix); 
parityMatrix = parityMatrix.'; % transpose the matrix
vecOfParities = [vecOfParities, parityMatrix(:).']; % make a vector out of the colums and transpose it then 

end 
disp('matrix turned into vector');
disp(vecOfParities); 

end

