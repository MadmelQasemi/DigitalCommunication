
%%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Name: Brianna Dias, Madmel Qasemi
% Date: 22.04.2025
%
% 
%
% Input:  bits: Matrix of bit values (0 or 1) MSB at index 1
%  
% Output: -- Message: a string of alphabetes -> our massage
% 
%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function msgAsCode = sourceDecoding(bits)


msgAsCode = [];
[rows, columns]= size(bits);
for i= 1:rows 
dec = binVecToDec(bits(i,:));  
character = char(dec); 
msgAsCode = [msgAsCode character];
end

disp('recieved:');
disp(msgAsCode); 
end