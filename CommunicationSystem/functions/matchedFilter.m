%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Name: Brianna, Madmel
% Date: 17.05.2025
% This function encode the signal into symbols with appling the convolution
% to the root raised cosine to the signal again and sampling the values in
% the right time
% Input: the signal and the factor alpha of the cos
% Output: A matrix with all symbols
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [yReal, yImaginary] = matchedFilter(signal, alpha, fsa, Nsym, Nsam)

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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% We have to sample this signal after synchronization and decode there!
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

end