function objects_cluster = algorithm_average_clusters_line(objects_cluster)

    % get number of objects:
    num_objects = numel(objects_cluster);
    
    % create array to store start and end points of each line:
    line_starts = zeros(num_objects, 3);
    line_ends = zeros(num_objects, 3);
    
    % use first line to define which side is start and which side is end:
    line_starts(1,:) = objects_cluster(1).coordinates(1,:);
    line_ends(1,:) = objects_cluster(1).coordinates(end,:);
    
    % add all other objects in the cluster to the start and end arrays:
    for i = 2:num_objects
       
        % get line coords:
        temp_coords = objects_cluster(i).coordinates;
        
        % determine dist between each coord and the first "start" coord:
        distance = pdist2(line_starts(1,:), temp_coords, 'euclidean');
        
        % get index of "start" coord:
        [~, index_start] = min(distance);
        
        % get index of "end" coord:
        [~, index_end] = max(distance);
        
        % save:
        line_starts(i,:) = temp_coords(index_start, :);
        line_ends(i,:) = temp_coords(index_end, :);
        
    end
    
    % get average start and end positions:
    average_start = mean(line_starts, 1);
    average_end = mean(line_ends, 1);

    % save to results:
    objects_cluster(1).coordinates = [average_start; average_end];
    objects_cluster(1).temp_tracker = 1;
    objects_cluster(1).object_averaged_num = objects_cluster(1).object_clustered_num;
    objects_cluster(1).object_averaged_color = objects_cluster(1).object_clustered_color;

end