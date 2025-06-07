%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Name: Brianna, Madmel 
% Date: 12.05.2025
%
% Input: dimension of the Matrix 
% Output: generator matrix with given dimension for gray coding
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function genMatrix = generatorMatrix(dimension)
global debug_generatorMatrix
% make a matrix in the right dimension
genMatrix = zeros(dimension,dimension);

% go over all values and set the main diagonal line 
% and the one next to it to 1
for i = 1 : dimension 
    for j = 1: dimension
        if(i==j)
        genMatrix(i,j)= 1;
        elseif(j==i+1)
        genMatrix(i,j)= 1;   
        end
    end    
end

% show the result
if debug_generatorMatrix
    disp('generator matrix'); 
    disp(genMatrix);
end
end 
 