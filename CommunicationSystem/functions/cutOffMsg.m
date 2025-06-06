%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Name: Brianna, Madmel 
% Date: 06.06.2025
% This function cut off the message from the long audiosignal 
% Input: the whole message which was recieved recieved through channel
% Output: the extracted message 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function extractedMsg = cutOffMsg(sRX,sTX)
signalWidth= length(sTX);

for i = 1:length(sRX) % as soon as the message appears save the signal
    if sRX(i) > 0.25 % some choosen value as threshold
        beginIndex = i; 
        break; 
    end
end

for n = 1:signalWidth
    extractedMsg(n)=sRX(beginIndex); 
    beginIndex=beginIndex+1; 
end

% Optional: Plot of recieved signal that we want
% to extract the message from

figure;
plot(abs(sRX));
title('Absoluter Wert des simulierten Empfangssignals');
xlabel('Sample Index');
ylabel('|sRX|');

end