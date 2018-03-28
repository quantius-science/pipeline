function [continue_status, object_paired, objects_stack] = look_for_connection_on_upper_slice(object_to_use, objects_stack, slice_max, group_number)

    % get coordinates:
    coords_1 = objects_stack(object_to_use).coordinates_mask;
    
    % get slice:
    slice = objects_stack(object_to_use).slice_num;
    
    % get slice above:
    slice_above = slice + 1;
    
    % if slice above is in stack:
    if slice_above <= slice_max
       
        % get results for slice above:
        rows_above = find(extractfield(objects_stack, 'slice_num') == slice_above);
        objects_above = objects_stack(rows_above);
        
        % get number of objects on slice above:
        num_objects_above = size(objects_above, 2);
        
        % create array to store overlap:
        overlap = zeros(1, num_objects_above);
        
        % get overlap between object and objects above:
        for i = 1:num_objects_above
           
            % get coordinates:
            coords_2 = objects_above(i).coordinates_mask;
            
            % get overlap:
            overlap(i) = numel(intersect(coords_1, coords_2));
            
        end
        
        % get max overlap:
        [overlap_max, overlap_max_index] = max(overlap);
        
        % if overlap is non-zero:
        if overlap_max ~= 0
            
            % if paired object is larger:
            if (0.8 * numel(coords_1)) < numel(objects_above(overlap_max_index).coordinates_mask)
                
                % convert index to stack:
                overlap_max_index_stack = rows_above(overlap_max_index);
                
                % set paired objects group number:
                objects_stack(object_to_use).up_partner = group_number;
                objects_stack(overlap_max_index_stack).up_partner = group_number;
                
                % update status:
                continue_status = 'yes';
                object_paired = overlap_max_index_stack;
                
            else
                
                % update status and pair:
                continue_status = 'no';
                object_paired = 'none';
                
            end
            
        % if overlap is zero:
        else
            
            % update status and pair:
            continue_status = 'no';
            object_paired = 'none';
            
        end
        
    else
        
        % update status and pair:
        continue_status = 'no';
        object_paired = 'none';
        
    end

end