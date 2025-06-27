function symbols = decodeTheSymbols(real, imaginary)
global debug_mode

real = real'; 
imaginary = imaginary'; 

rows = length(real); 
columns = 2; 

symbols = zeros(rows,columns); 
 % decode the real part
 for i = 1:rows
    if(real(i)<1.5 && real(i)>0)
        symbols(i,1)=1;
    elseif(real(i)>1.5)
        symbols(i,1)=3;
    elseif(real(i)<-1.5)
        symbols(i,1)=-3;
    elseif(real(i)>-1.5 && real(i)<0)
        symbols(i,1)=-1;
    end
 end

 % decode imaginary part
 for i = 1:rows
    if(imaginary(i)<1.5 && imaginary(i)>0)
        symbols(i,2)=1;
    elseif(imaginary(i)>1.5)
        symbols(i,2)=3;
    elseif(imaginary(i)<-1.5)
        symbols(i,2)=-3;
    elseif(imaginary(i)>-1.5 && imaginary(i)<0)
        symbols(i,2)=-1;
    end
 end

if debug_mode
 disp('Ergebnis aus gesamplete Symbole');
 disp(symbols);
end
 
end




