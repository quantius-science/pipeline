function objects_cluster = algorithm_average_clusters(tool, objects_cluster)

    % if the results are points:
    if strcmp(tool, 'Crosshairs')
        
        objects_cluster = postprocessing.algorithm_average_clusters_point(objects_cluster);
    
    % if the results are lines:
    elseif ((strcmp(tool, 'Line')) || (strcmp(tool, 'Polyline')))
        
        objects_cluster = postprocessing.algorithm_average_clusters_line(objects_cluster);

    % if the results are shapes:
    elseif ((strcmp(tool, 'Polygon')) || (strcmp(tool, 'Freehand')))
        
        objects_cluster = postprocessing.algorithm_average_clusters_shape(objects_cluster);
        
    end
    
end