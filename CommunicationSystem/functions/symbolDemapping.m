%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Name: Brianna, Madmel 
% Date: 12.05.2025
%
% this function returns the bits behind the symbols
% Input: 
% Output: stream vector
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function stream = symbolDemapping(symbolvector, alphabet, method)
global LookUpTable;
global debug_mode; 

if (method == "ASK")
    lenStream = size(symbolvector,1);
    index = 1; 
    for i = 1:lenStream
        for j = 1:length(alphabet)
            if (symbolvector(i)==LookUpTable(j,3))
                stream(1,index)=LookUpTable(j,1);
                index = index+1; 
                stream(1,index)=LookUpTable(j,2); 
                index = index+1;
            end
        end
    end
    if debug_mode
    disp('demaped values');
    disp(stream); 
    end
  
elseif(method == "16QAM")
    lenStream = size(symbolvector,1); % returns the number of the rows
    index = 1; 
    for i = 1:lenStream
        for j = 1:2 
            for n = 1:4
                if(symbolvector(i,j)==LookUpTable(n,3))
                    stream(1,index)= LookUpTable(n,1);
                    index = index+1;
                    stream(1,index)= LookUpTable(n,2);
                    index = index+1;
                end
            end
        end
    end

if debug_mode
    disp('demaped values');
    disp(stream);  
end       

end
end