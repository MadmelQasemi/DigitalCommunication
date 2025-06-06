%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Name: Brianna, Madmel 
% Date: 17.05.2025
% This function encode the signal into symbols with appling the convolution
% to the root raised cosine to the signal again and sampling the values in
% the right time
% Input: the signal and the factor alpha of the cos
% Output: A matrix with all symbols
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function symbolvector = matchedFilter(signal,alpha,fsa,Nsym, Nsam)

% variables needed
Tsym = 1 / Nsym;
Tsa = 1/fsa;

% sepreate the real and imaginary part
rows = size(signal,1); 
for i = 1 : rows
    yReal(i)= signal(i,1);
    yImaginary(i)= signal(i,2);
end

% cosinus
h = rcosdesign(alpha, Nsym, Nsam,'sqrt');

% normalisation
scale = sum(h); 
rootRaisedCos = h/scale;

% matchedfilter and the second convolution
yReal = conv(yReal, rootRaisedCos,'same'); 
yImaginary = conv(yImaginary, rootRaisedCos,'same');

% plot the eyediagram manuely
% calssical eyediagram needs two symbols instead of 1

vectorLen = length(yReal);
xAchis = ((0:vectorLen-1)*Tsa); 

samplePerSymbol = 2*Nsam; 
eyeX = (0:samplePerSymbol-1)*Tsa*(1e6); 
%eye_x = linspace(-1, 1, 2*Nsam); % normed
max = vectorLen-samplePerSymbol;

% real plot
figure; 
hold on; 
title('eyediagram for two symbols'); 
xlabel('time (normed to symbol)');
ylabel('Amplitude real');

for n = 1:Nsam:max
    symbolSamples = yReal(n:n+samplePerSymbol-1);
    plot(eyeX,symbolSamples);
end

% imaginary plot
figure; 
hold on; 
title('eyediagram for two symbols'); 
xlabel('time (normed to symbol)');
ylabel('Amplitude imaginär');

for n = 1:Nsam:max
    symbolSamples = yImaginary(n:n+samplePerSymbol-1);
    plot(eyeX,symbolSamples);
end

% to compare
%eyediagram(yReal,Nsam);
%eyediagram(yImaginary,Nsam); 

% plots after matched filter 
figure;
subplot(2,1,1);
plot(xAchis, yReal);
title('Real Impulse Response after matched filter');

subplot(2,1,2);
plot(xAchis,yImaginary); 
title('Imaginary Impulse Response after matched filter');

% decode 
start = 1;
len = length(yReal); 

% value detection
index = 1; 
sym(index,1) = yReal(start);
sym(index,2) = yImaginary(start);
index = index+1; 
start = 8;

for n = start:8:len
    if n > (len-8)
        break; 
    else
    sym(index,1)= yReal(n); 
    sym(index,2)= yImaginary(n); 
    index = index+1; 
    end
end

disp('values of the samples on the right positions after matched filter');
disp(sym);

% round the values
for i = 1:length(sym)
   if(sym(i,1)<1.5 && sym(i,1)>0)
       sym(i,1)=1;
   elseif(sym(i,1)<4 && sym(i,1)>1.5)
       sym(i,1)=3;
   elseif(sym(i,1)>-4 && sym(i,1)<-1.5)
       sym(i,1)=-3; 
   elseif(sym(i,1)>-1.5 && sym(i,1)<0)
       sym(i,1)=-1; 
   end
end 

for i = 1:length(sym)
   if(sym(i,2)<1.5 && sym(i,2)>0)
       sym(i,2)=1;
   elseif(sym(i,2)<4 && sym(i,2)>1.5)
       sym(i,2)=3;
   elseif(sym(i,2)>-4 && sym(i,2)<-1.5)
       sym(i,2)=-3; 
   elseif(sym(i,2)>-1.5 && sym(i,2)<0)
       sym(i,2)=-1; 
   end
end 

disp('round the values to get the symbols')
disp(sym);
symbolvector = sym;

end