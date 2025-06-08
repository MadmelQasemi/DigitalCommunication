%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Name: Brianna, Madmel
% Date: 17.05.2025
% This function encode the signal into symbols with appling the convolution
% to the root raised cosine to the signal again and sampling the values in
% the right time
% Input: the signal and the factor alpha of the cos
% Output: A matrix with all symbols
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [symbolvector,yReal,yImaginary] = matchedFilter(signal,alpha,fsa,Nsym, Nsam)

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