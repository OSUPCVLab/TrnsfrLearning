function [centroid, moment]=calculateCentroidAndMoment(heatMap)
total_mass=sum(sum(heatMap));
heatMap=heatMap/total_mass;
hpSize=size(heatMap);
centroid=zeros(1,2);
moment=zeros(1,2);

% Calculate Centroids
for i=1:hpSize(1)
    for j=1:hpSize(2)
      centroid=centroid+heatMap(i,j)*[i j]; 
    end
end

% Calculate Moments
for i=1:hpSize(1)
    for j=1:hpSize(2)
      moment=moment+heatMap(i,j)*([i j]-centroid).^2; 
    end
end

end