function objects_slice = algorithm_cluster_replicates(tool, objects_slice)

    % if the results are points:
    if strcmp(tool, 'Crosshairs')
        
        objects_slice = postprocessing.algorithm_cluster_replicates_point(objects_slice);
    
    % if the results are lines:
    elseif ((strcmp(tool, 'Line')) || (strcmp(tool, 'Polyline')))
        
        objects_slice = postprocessing.algorithm_cluster_replicates_line(objects_slice);

    % if the results are shapes:
    elseif ((strcmp(tool, 'Polygon')) || (strcmp(tool, 'Freehand')))
        
        objects_slice = postprocessing.algorithm_cluster_replicates_shape(objects_slice);
        
    end
    
end