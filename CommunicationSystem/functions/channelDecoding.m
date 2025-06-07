%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Name: Brianna, Madmel
% Date: 22.04.2025
%
% Input:  Bitstream with parities
% Output: Matrix of Bits (bitstream) +
% Number of failiures? Is it corrected?
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function rawBits = channelDecoding(bitstreamParity)
bitstreamAsMatrix = []; % here we save the stream again in a matrix
rawBits = []; % the decoded values of the message

% to fix the one more bit that does not belong to data and make sure
% the matrix has 8 colums:
vectorLen = length(bitstreamParity);

if mod(vectorLen,8) > 0
    vectorLen = vectorLen-1;
    bitstreamParity = bitstreamParity(2:end);
end

% calculate number of the matrices in the stream with parities
matrixNum = (vectorLen)/64;
rowsCount = vectorLen/8;

% variables to control the loop and copy values
% from the stream into a matrix

line = 1; col = 1; i = 1;
for numbMatrix = 1:matrixNum
    for n = line:line+7
        for col = col:8
            bitstreamAsMatrix(line,col) = bitstreamParity(i);
            i = i+1;
        end
        col = 1;
        line = line + 1;
    end
end



% to count the incorrect BIts
incorrectBitsNumb = 0;

% set incorrect bits manuelly
%bitstreamAsMatrix(18,3)= 1;
%bitstreamAsMatrix(3,2)= 0;
%bitstreamAsMatrix(2,5)= 1;

%  Back into a matrix (8x8) and examine the parities:

% to save the position of an incorrect bit-> use in case of a single failure
rowError = 0; colError = 0;

% for summinng up the bits
tempRow = 0; tempCol = 0;

% to control the loop
col = 1; row = 1; iRow = 1;

% to end a matrix check and skip the parity line by examining the next
endLine = 8;

totalFailure = 0;

% to control the number of iterations over the matrices
matrices = 1; maxLine = 1; currentLine = 1;

for matrices = 1:matrixNum
    for row = row: row+6
        for col = col:7
            tempRow = tempRow + bitstreamAsMatrix(row,col); % sum of the row
            rawBits(iRow,col)= bitstreamAsMatrix(row,col);
        end
        col = 1; % set it back to 1 for the next line
        iRow = iRow+1;
        % check if the parity is set correct
        if mod(tempRow,2) == 0 && bitstreamAsMatrix(row,8) == 0 || mod(tempRow,2) == 1 && bitstreamAsMatrix(row,8) == 1
            disp ( 'correct');
        else
            % display the error
            disp(row); disp('error');
            incorrectBitsNumb = incorrectBitsNumb+1;
            rowError = row; % will be overwritten by more than one failure
        end
        tempRow = 0;
    end
    currentLine = row-6;
    % correction only if one failure:
    if incorrectBitsNumb == 1
        maxLine = matrices * 8;
        for findTheFailedCol = 1:7
            for currentLine = currentLine:maxLine-1
                tempCol = tempCol + bitstreamAsMatrix(currentLine,findTheFailedCol);
            end
            if mod(tempCol,2) == 0 && bitstreamAsMatrix(maxLine,findTheFailedCol) == 0 || mod(tempCol,2) == 1 && bitstreamAsMatrix(maxLine,findTheFailedCol) == 1
                % alright
            else
                disp('incorrect column');
                disp(findTheFailedCol);
                colError = findTheFailedCol;
                rawBits(rowError,colError) = ~rawBits(rowError,colError);
                disp('correction  compelete');
            end
            currentLine = currentLine - 6;
            tempCol = 0;
        end
    end
    col = 1;
    row = row + 2;
    totalFailure = totalFailure + incorrectBitsNumb;
    incorrectBitsNumb = 0;
end

disp('Number of failures');
disp(totalFailure);
disp('original bits');
disp(rawBits);
end

