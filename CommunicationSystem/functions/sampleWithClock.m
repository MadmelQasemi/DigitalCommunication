%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Single Carrier Communication
% Name: Brianna, Madmel
% Datum: 22.04.2025
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [symbolsReal,symbolsImaginary] = sampleWithClock(clockReal, clockImaginary, realSignal, imaginarySignal)
    
    indexReal = 1;
    indexImaginary = 1;

    LEN = length(realSignal);
    for n = 1 : LEN-1
        % sampling real signal 
        if (clockReal(n)== -1 && clockReal(n+1) == 1)
            symbolsReal(indexReal) = realSignal(n);
            indexReal = indexReal+1;
        end
        % sampling imaginary signal 
        if (clockImaginary(n)== -1 && clockImaginary(n+1) == 1)
            symbolsImaginary(indexImaginary) = imaginarySignal(n);
            indexImaginary = indexImaginary +1; 
        end
    end

end