% transfer the source matrix to a binary matrix
%
% if source(i,j) > thress, mask(i,j) = 1
% else mask(i,j) = 0

function mask = im2bw(source, thres)

[row, col] = size(source);
mask = zeros(row, col);
for i  =  1 : row
    for j =  1 : col
        if source(i, j) > thres
            mask(i, j) = 1;
        end
    end
end