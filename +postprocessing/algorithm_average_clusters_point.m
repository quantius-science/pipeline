function objects_cluster = algorithm_average_clusters_point(objects_cluster)

    % get number of objects:
    num_objects = numel(objects_cluster);
    
    % for each object:
    for i = 1:num_objects
       
        objects_cluster(i).temp_tracker = 1;
        objects_cluster(i).object_averaged_num = objects_cluster(i).object_clustered_num;
        objects_cluster(i).object_averaged_color = objects_cluster(i).object_clustered_color;
        
    end 

end