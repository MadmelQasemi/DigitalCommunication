
%%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Name: Brianna Dias, Madmel Qasemi
% Date: 22.04.2025
%
% 
%
% Input: Massage: a string of alphabetes -> our massage 
% Output: - bin: Matrix of bit values (0 or 1) MSB at index 1
% 
%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function msgAsCode = sourceCoding(msg)
msgAsCode = []; 
N = 7; 
for i = 1:length(msg)
msgAscii = double(msg); 
msgAsbin = decToBinVec(msgAscii(i),N); 
msgAsCode = [msgAsCode; msgAsbin]; 
end
end