function objects_slice = algorithm_cluster_replicates_line(objects_slice)

    % get number of objects:
    num_objects_slice = numel(objects_slice);
    
    % create field to store line centroid:
    [objects_slice(1:end).centroid] = deal([]);
    
    % for each object:
    for i = 1:num_objects_slice
       
        % get centroid as median of line endpoints:
        objects_slice(i).centroid = median(objects_slice(i).coordinates, 1);
        
    end
    
    % get all coordinates:
    coordinates_all = zeros(num_objects_slice, 3);
    for i = 1:num_objects_slice       
        coordinates_all(i, :) = objects_slice(i).centroid;
    end

    % cluster the coordinates:
    coordinates_clustered = subclust(coordinates_all, 0.03);

    % get number of clusters:
    num_clusters = size(coordinates_clustered, 1);

    % create a unique color (avoid white and black) for each cluster:
    colors = distinguishable_colors(num_clusters, {'w', 'k'});

    % save info to slice structure:
    for i = 1:num_objects_slice
        
        % get euclidean distance between line centroid and all clusters:
        distance = zeros(num_clusters, 1);
        for j = 1:num_clusters
           
            distance(j) = pdist([objects_slice(i).centroid; coordinates_clustered(j, :)]);
            
        end
        
        % get cluster with minimum distance: 
        [~, index] = min(distance);

        % save results to structure:
        objects_slice(i).object_clustered_num = index;
        objects_slice(i).object_clustered_color = colors(index, :);

    end

    % remove field with line centroid:
    objects_slice = rmfield(objects_slice, 'centroid');
    
end