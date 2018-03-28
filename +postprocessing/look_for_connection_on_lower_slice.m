function [continue_status, object_paired, objects_stack] = look_for_connection_on_lower_slice(object_to_use, objects_stack, slice_min, group_number)

    % get coordinates:
    coords_1 = objects_stack(object_to_use).coordinates_mask;
    
    % get slice:
    slice = objects_stack(object_to_use).slice_num;
    
    % get slice below:
    slice_below = slice - 1;
    
    % if slice below is in stack:
    if slice_below >= slice_min
       
        % get results for slice above:
        rows_below = find(extractfield(objects_stack, 'slice_num') == slice_below);
        objects_below = objects_stack(rows_below);
        
        % get number of objects on slice above:
        num_objects_below = size(objects_below, 2);
        
        % create array to store overlap:
        overlap = zeros(1, num_objects_below);
        
        % get overlap between object and objects above:
        for i = 1:num_objects_below
           
            % get coordinates:
            coords_2 = objects_below(i).coordinates_mask;
            
            % get overlap:
            overlap(i) = numel(intersect(coords_1, coords_2));
            
        end
        
        % get max overlap:
        [overlap_max, overlap_max_index] = max(overlap);
        
        % if overlap is non-zero:
        if overlap_max ~= 0
            
            % if paired object is larger:
            if (0.8 * numel(coords_1)) < numel(objects_below(overlap_max_index).coordinates_mask)
                
                % convert index to stack:
                overlap_max_index_stack = rows_below(overlap_max_index);
                
                % set paired objects group number:
                objects_stack(object_to_use).down_partner = group_number;
                objects_stack(overlap_max_index_stack).down_partner = group_number;
                
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