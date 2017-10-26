function [ class, centroid ] = mykmedoids( pixels, K )
%
% Your goal of this assignment is implementing your own K-medoids.
% Please refer to the instructions carefully, and we encourage you to
% consult with other resources about this algorithm on the web.
%
% Input:
%     pixels: data set. Each row contains one data point. For image
%     dataset, it contains 3 columns, each column corresponding to Red,
%     Green, and Blue component.
%
%     K: the number of desired clusters. Too high value of K may result in
%     empty cluster error. Then, you need to reduce it.
%
% Output:
%     class: the class assignment of each data point in pixels. The
%     assignment should be 1, 2, 3, etc. For K = 5, for example, each cell
%     of class should be either 1, 2, 3, 4, or 5. The output should be a
%     column vector with size(pixels, 1) elements.
%
%     centroid: the location of K centroids in your result. With images,
%     each centroid corresponds to the representative color of each
%     cluster. The output should be a matrix with size(pixels, 1) rows and
%     3 columns. The range of values should be [0, 255].
%
%
% You may run the following line, then you can see what should be done.
% For submission, you need to code your own implementation without using
% the kmeans matlab function directly. That is, you need to comment it out.


%    [class, centroid] = kmedoids(pixels, K);

	 % Randomly initialise K cluster centres
     [maxRow , maxCol] = size(pixels);
     clusterIndices = floor(rand(1,K)*maxRow+1);
     clusterCenter = pixels(clusterIndices,:);

     % Take first k points as initial cluster centers
%     for i=1:K
%         clusterCenter(i,:) = pixels(i,:);
%     end
    
	class = zeros(maxRow,1);
	
%  	while 1
    iter = 1;
    for iter=1:12
		oldClusterCenter = clusterCenter;
		
        % Find which point belongs to which cluster
		for i = 1:maxRow
			point = pixels(i,:);
			class(i) = findClusterIndexManhattan(point,clusterCenter);
		end
		
		% Try swapping medoids with non-medoids in each cluster and if cost
		% reduces, make the new point as medoid of that cluster
		
        for i = 1:K
			clusterPoints = pixels(find(class==i),:);
			
			initialCost = findTotalCostManhattan(clusterPoints,clusterCenter(i,:));
            
            clusterPoints = unique(clusterPoints,'rows');
			for j = 1:size(clusterPoints,1)
				newCost = findTotalCostManhattan(clusterPoints, clusterPoints(j,:));
				
				if newCost < initialCost
					initialCost = newCost;
					clusterCenter(i,:) = clusterPoints(j,:);
				end
			end
        end

		if oldClusterCenter == clusterCenter
			break;
		end	
    end
    
    centroid = clusterCenter;
end

%Euclidian distance
function [minindex] = findClusterIndexEuclidian(point, clusterCenter)
    [maxRow , maxCol] = size(clusterCenter);
    cost = zeros(maxRow,1);
    
    for i=1:maxRow
        diff = clusterCenter(i,:) - point;
        square = power(diff,2);
        cost(i) = sum(square);
    end
    
    [minvalue minindex] = min(cost);
end

function [totalCost] = findTotalCostEuclidian(points,medoid)
    
      diff = points - repmat(medoid,size(points,1),1);
      square = power(diff,2);
      totalCost = sum(sum(square));
end

%manhattan distance
function [minindex] = findClusterIndexManhattan(point, clusterCenter)
    diff = clusterCenter - repmat(point,size(clusterCenter,1),1);
    absolute = abs(diff);
    cost = sum(absolute,2);
    [minvalue minindex] = min(cost);
end

function [totalCost] = findTotalCostManhattan(points,medoid)
    
    diff = points - repmat(medoid,size(points,1),1);
    absolute = abs(diff);
    totalCost = sum(sum(absolute));
%       totalCost = sum(pdist2(points,medoid,'minkowski',1));
end

%chessboard distance 
function [minindex] = findClusterIndexChessBoard(point, clusterCenter)
    [maxRow , maxCol] = size(clusterCenter);
    cost = zeros(maxRow,1);
    
    for i=1:maxRow
        diff = clusterCenter(i,:) - point;
        absolute = abs(diff);
        cost(i) = max(absolute);
    end
    
    [minvalue minindex] = min(cost);
end

function [totalCost] = findTotalCostChessBoard(points,medoid)
    [maxRow , maxCol] = size(points);
    totalCost = 0;
    
    for i=1:maxRow
        diff = points(i,:) - medoid;
        absolute = abs(diff);
        totalCost = totalCost + max(absolute);
    end   
end