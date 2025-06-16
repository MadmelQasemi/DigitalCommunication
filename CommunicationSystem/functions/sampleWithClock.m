%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Single Carrier Communication
% Name: Brianna, Madmel
% Datum: 22.04.2025
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [symbolsReal,symbolsImaginary] = sampleWithClock(clockReal, clockImaginary, realSignal, imaginarySignal, startindex)
    
    indexReal = 1;
    indexImaginary = 1;
    symbolsReal(indexReal) = realSignal(startindex);
    symbolsImaginary(indexImaginary) = imaginarySignal(startindex);

    LEN = length(realSignal);
    for n = 2 : LEN-startindex
        % sampling real signal 
        if (clockReal(n)== 1 && clockReal(n-1) == -1)
            indexReal = indexReal+1;
            symbolsReal(indexReal) = realSignal(startindex + n); 
        end
        % sampling imaginary signal 
        if (clockImaginary(n)== 1 && clockImaginary(n-1) == -1)
            indexImaginary = indexImaginary +1; 
            symbolsImaginary(indexImaginary) = imaginarySignal(n + startindex); 
        end
    end

end