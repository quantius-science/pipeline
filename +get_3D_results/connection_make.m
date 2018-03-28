function objects_seg = connection_make(objects_seg, objects_conn)

    % add field to store temporary connection info:
    [objects_seg(1:end).cluster_3D_num] = deal([]);

    % for each conn object:
    for i = 1:numel(objects_conn)
       
        % get conn coords:
        coords_conn = objects_conn(i).coordinates_um;
        
        % get seg objects for the stack:
        [objects_seg_stack, rows_seg_stack] = utilities.get_structure_results_matching_number(objects_seg, 'num_stack', objects_conn(i).num_stack);
        
        % for each seg object:
        for j = 1:numel(objects_seg_stack)
            
            % get seg coords:
            coords_seg = objects_seg_stack(j).coordinates_um;
            
            % get intersection:
            overlap = intersectionHull('vert', coords_conn, 'vert', coords_seg);
            
            % if there is any overlap:
            if ~isempty(overlap.vert)
               
                % assign that seg to the 3D object:
                objects_seg_stack(j).cluster_3D_num(end+1) = i;
                
            end
            
        end
        
        % save:
        objects_seg(rows_seg_stack) = objects_seg_stack;
        
    end

end