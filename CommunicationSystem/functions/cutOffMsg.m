%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Name: Brianna, Madmel 
% Date: 06.06.2025
% This function cust off the message from the long audiosignal 
% Input: the whole message which was recieved from the channel
% Output: the extracted message 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function extractedMsg = cutOffMsg(sRX,sTX)
signalWidth= length(sTX);
beginIndex = 0; i = 1;
while(sRX(i) < 0.2) % as soon as the message appears save the signal
        beginIndex = i; 
        i=i+1; 
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