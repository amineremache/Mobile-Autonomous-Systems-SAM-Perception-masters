function D = blockMatching(Ig, Id, blocSize, dispMax, seuilContraste, simfunc)
D = zeros(size(Ig), 'single');
disparityRange = dispMax;
% Define the size of the blocks for block matching.
BlocSize2 = fix(blocSize/2);
blockSize = 2 * BlocSize2 + 1;
% Get the image dimensions.
[imgHeight, imgWidth] = size(Ig);

% For each row 'm' of pixels in the image...
for (m = 1 : imgHeight)
    	
	% Set min/max row bounds for the template and blocks.
	% e.g., for the first row, minr = 1 and maxr = 4
    minr = max(1, m - BlocSize2);
    maxr = min(imgHeight, m + BlocSize2);
	
    % For each column 'n' of pixels in the image...
    for (n = 1 : imgWidth)
        
		% Set the min/max column bounds for the template.
		% e.g., for the first column, minc = 1 and maxc = 4
		minc = max(1, n - BlocSize2);
        maxc = min(imgWidth, n + BlocSize2);
        
		% Define the search boundaries as offsets from the template location.
		% Limit the search so that we don't go outside of the image. 
		% 'mind' is the the maximum number of pixels we can search to the left.
		% 'maxd' is the maximum number of pixels we can search to the right.
		%
		% In the "Cones" dataset, we only need to search to the right, so mind
		% is 0.
		%
		% For other images which require searching in both directions, set mind
		% as follows:
        %   mind = max(-disparityRange, 1 - minc);
		mind = 0; 
        maxd = min(disparityRange, imgWidth - maxc);

		% Select the block from the right image to use as the template.
        template = Id(minr:maxr, minc:maxc);
		
		% Get the number of blocks in this search.
		numBlocks = maxd - mind + 1;
		
		% Create a vector to hold the block differences.
		blockDiffs = zeros(numBlocks, 1);
		
		% Calculate the difference between the template and each of the blocks.
		for (i = mind : maxd)
		
			% Select the block from the left image at the distance 'i'.
			block = Ig(minr:maxr, (minc + i):(maxc + i));
		
			% Compute the 1-based index of this block into the 'blockDiffs' vector.
			blockIndex = i - mind + 1;
            
            if strcmp(simfunc,'SAD')
			% Take the sum of absolute differences (SAD) between the template
			% and the block and store the resulting value.
			blockDiffs(blockIndex, 1) = sum(sum(abs(template - block)));
            elseif strcmp(simfunc,'SSD')
			% Take the sum of squared differences (SSD) between the template
			% and the block and store the resulting value.
			blockDiffs(blockIndex, 1) = sum(sum((template - block).^2));
            elseif strcmp(simfunc,'NCC')
			% Take the normalized cross correlation (NCC) between the template
			% and the block and store the resulting value.
			blockDiffs(blockIndex, 1) = sum(sum((template.*block)))/sqrt(sum(sum((template.^2)))*sum(sum((block.^2))));
            end
		end
		
		% Sort the SAD values to find the closest match (smallest difference).
		% Discard the sorted vector (the "~" notation), we just want the list
		% of indices.
		[temp, sortedIndeces] = sort(blockDiffs);
		
		% Get the 1-based index of the closest-matching block.
		bestMatchIndex = sortedIndeces(1, 1);
		
		% Convert the 1-based index of this block back into an offset.
		% This is the final disparity value produced by basic block matching.
		d = bestMatchIndex + mind - 1;
			
		% Calculate a sub-pixel estimate of the disparity by interpolating.
		% Sub-pixel estimation requires a block to the left and right, so we 
		% skip it if the best matching block is at either edge of the search
		% window.
		if ((bestMatchIndex == 1) || (bestMatchIndex == numBlocks))
			% Skip sub-pixel estimation and store the initial disparity value.
			D(m, n) = d;
		else
			% Grab the SAD values at the closest matching block (C2) and it's 
			% immediate neighbors (C1 and C3).
			C1 = blockDiffs(bestMatchIndex - 1);
			C2 = blockDiffs(bestMatchIndex);
			C3 = blockDiffs(bestMatchIndex + 1);
			
			% Adjust the disparity by some fraction.
			% We're estimating the subpixel location of the true best match.
			D(m, n) = d - (0.5 * (C3 - C1) / (C1 - (2*C2) + C3));
		end
    end
end
end
