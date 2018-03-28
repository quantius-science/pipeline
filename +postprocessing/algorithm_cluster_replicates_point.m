function objects_slice = algorithm_cluster_replicates_point(objects_slice)

    % get number of objects:
    num_objects_slice = numel(objects_slice);
    
    % get all coordinates:
    coordinates_all = zeros(num_objects_slice, 3);
    for i = 1:num_objects_slice       
        coordinates_all(i, :) = objects_slice(i).coordinates;
    end

    % cluster the coordinates:
    coordinates_clustered = subclust(coordinates_all, 0.1);

    % get number of clusters:
    num_clusters = size(coordinates_clustered, 1);

    % create a unique color (avoid white and black) for each cluster:
    colors = distinguishable_colors(num_clusters, {'w', 'k'});

    % save info to slice structure:
    for k = 1:num_clusters

        % save results to structure:
        objects_slice(k).coordinates = coordinates_clustered(k, :);
        objects_slice(k).object_clustered_num = k;
        objects_slice(k).object_clustered_color = colors(k, :);

    end

end