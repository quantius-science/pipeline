function objects_seg = connection_correct(objects_seg)

    % get list of stacks:
    list_stacks = unique(extractfield(objects_seg, 'num_stack'));
    
    % for each stack:
    for i = 1:numel(list_stacks)
       
        % get results for the stack:
        [objects_seg_stack, rows_stack] = utilities.get_structure_results_matching_number(objects_seg, 'num_stack', list_stacks(i));
        
        % start tracker for group number:
        group = 1;
        
        % start list of used indices:
        objects_used = double.empty(0,2);
        
        % for each results in the stack:
        for j = 1:numel(objects_seg_stack)
            
            % get list of object numbers:
            list_objects = objects_seg_stack(j).cluster_3D_num;
            
            % get objects in common with previously used numbers:
            common = intersect(list_objects, objects_used(:,2));
            
            % if none of the object numbers have previously been used:
            if isempty(common)
                
                % assign result to new group:
                objects_seg_stack(j).object_connected_num = group;
                
                % update list of used indices and numbers:
                for k = 1:numel(list_objects)
                   objects_used(end+1, 1) = group;
                   objects_used(end, 2) = list_objects(k);
                end
                
                % increment group number:
                group = group + 1;
                
            % if any of the object numbers have previously been used:
            else
                
                % get the group number of first object number in common:
                row = find(objects_used(:,2) == common(1));
                
                % save group:
                objects_seg_stack(j).object_connected_num = objects_used(row(1), 1);
                
                % update the list of used indices and numbers:
                for k = 1:numel(list_objects)
                   
                    % if the object number is already on the list:
                    if ismember(list_objects(k), objects_used(:,2))
                    
                        % do nothing
                        
                    % if the object number is not already on the list:
                    else
                        
                        % add to the list:
                        objects_used(end+1, 1) = group;
                        objects_used(end, 2) = list_objects(k);
                        
                    end
                    
                end
                
            end
            
        end
        
        % save:
        objects_seg(rows_stack) = objects_seg_stack;
        
    end

    % get list of 3D objects:
    list_objects = unique(extractfield(objects_seg, 'object_connected_num'));
    
    % get number of objects:
    num_objects = numel(list_objects);
    
    % get colors for each object:
    colors = distinguishable_colors(num_objects, {'k', 'w'});
    
    % for each seg:
    for i = 1:numel(objects_seg)
       
        index = objects_seg(i).object_connected_num;
        objects_seg(i).object_connected_color = colors(index, :);
        
    end
    
end