function [ class, centroid ] = mykmeans( pixels, K )
%
% Your goal of this assignment is implementing your own K-means.
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

% % 	%[class, centroid] = kmeans(pixels, K);
         [maxRow , maxCol] = size(pixels);
    
    if maxRow <= K     
        %If no of data points are less than the number of clusters, just returning the data points center as cluster centres
        class = 1:maxRow;
        centroid = pixels;
    else 
        % Randomly initialise K cluster centres
        clusterIndices = floor(rand(1,K)*maxRow+1);
        clusterCenter = pixels(clusterIndices,:);
%         for i=1:K
%             clusterCenter(i,:) = pixels(i,:);
%         end
        
        prev = zeros(maxRow,1);
        class = zeros(maxRow,1);
%         while 1
        iter = 1;
        for iter=1:100

            % Find which point belongs to which cluster
            for i = 1:maxRow
                point = pixels(i,:);
                class(i) = findClusterIndex(point,clusterCenter);
            end
        
            if class==prev
                break;
            else
                prev = class;
            end
            
            % New cluster center = averge of all points in that cluster
            for i=1:K
                 f = find(class == i);
                 if(f)
                    clusterCenter(i,:) = findMean(class,i,maxRow, pixels);
                 end
            end
        end
       
        centroid = clusterCenter;          
       
    end
end

function[newCentre] = findMean(class, ClusterNumber, maxRow, pixels)
    count = 0;
    sumPoints = zeros(1,3);
    for k=1:maxRow
        if class(k) == ClusterNumber
            sumPoints = sumPoints + pixels(k,:);
            count = count+1;
        end
    end
   
    newCentre =  sumPoints / count;
end

function [minindex] = findClusterIndex(point, clusterCenter)
    diff = clusterCenter - repmat(point,size(clusterCenter,1),1);
    square = power(diff,2);
    cost = sum(square,2);
    [minvalue minindex] = min(cost);
end