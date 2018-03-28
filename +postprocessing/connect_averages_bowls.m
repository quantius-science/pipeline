function connect_averages_bowls 
    %% Get averaging results:

    % get file with cleaned averaged results:
    objects = load('objects_3_cleaned.mat');
    objects = objects.results;

    %% Add fields to structure to store results:

    % add fields:
    [objects.coordinates_mask] = deal([]);
    [objects.cluster_3D_num] = deal(0);
    [objects.cluster_3D_color] = deal([]);
    [objects.up_partner] = deal(0);
    [objects.down_partner] = deal(0);
    
    %% Get mask coordinates for each object:
    
    % get number of objects:
    num_objects = size(objects, 2);
    
    % for each object:
    for i = 1:num_objects
       
        % get coordinates:
        temp_coordinates = objects(i).coordinates;
        
        % get mask:
        temp_mask = poly2mask(...
            temp_coordinates(:,1), temp_coordinates(:,2), ...
            objects(i).image_height, objects(i).image_width);
        
        % get mask coordinates:
        objects(i).coordinates_mask = find(temp_mask == 1);
        
    end

    %% Connect bowls going up:

    % get image stack names:
    image_stack_list = unique(extractfield(objects, 'stack_num'));

    % get number of image stacks:
    num_stacks = length(image_stack_list);

    % for each image stack:
    for i = 1:num_stacks

        % get name of image to analyze:
        image_stack = image_stack_list(i);

        % get relevant results:
        rows_stack = find(extractfield(objects, 'stack_num') == image_stack);
        objects_stack = objects(1, rows_stack);

        % get number of objects in the stack:
        num_objects_stack = size(objects_stack, 2);

        % get maximum slice number:
        slice_max = max([objects_stack.slice_num]);
        
        % start group number:
        group_number = 1;
        
        % for each object in the stack:
        for j = 1:num_objects_stack
            
            % get object to use:
            object_to_use = j;
            
            % if object has no partner:
            if objects_stack(j).up_partner == 0
                
                % set continue status:
                continue_status = 'yes';
                
                while strcmp(continue_status, 'yes')
                    
                    % look for connecting object above:
                    [continue_status, object_paired, objects_stack] = ...
                        postprocessing.look_for_connection_on_upper_slice(object_to_use, objects_stack, slice_max, group_number);
                    
                    % increment object to use:
                    object_to_use = object_paired;
                    
                end
                
            end
            
            % increment group number:
            group_number = group_number + 1;
            
        end
        
        % save info to structure:
        for j = 1:num_objects_stack

            % get index to use in large structure:
            index = rows_stack(j);

            % save results:
            objects(index).up_partner = objects_stack(j).up_partner;

        end
        
    end
    
  %% Connect bowls going down:

    % for each image stack:
    for i = 1:num_stacks

        % get name of image to analyze:
        image_stack = image_stack_list(i);

        % get relevant results:
        rows_stack = find(extractfield(objects, 'stack_num') == image_stack);
        objects_stack = objects(1, rows_stack);

        % get number of objects in the stack:
        num_objects_stack = size(objects_stack, 2);

        % get minimum slice number:
        slice_min = min([objects_stack.slice_num]);
        
        % start group number:
        group_number = 1;
        
        % for each object in the stack:
        for j = 1:num_objects_stack
            
            % get object to use:
            object_to_use = j;
            
            % if object has no partner:
            if objects_stack(j).up_partner == 0
                
                % set continue status:
                continue_status = 'yes';
                
                while strcmp(continue_status, 'yes')
                    
                    % look for connecting object below:
                    [continue_status, object_paired, objects_stack] = ...
                        postprocessing.look_for_connection_on_lower_slice(object_to_use, objects_stack, slice_min, group_number);
                    
                    % increment object to use:
                    object_to_use = object_paired;
                    
                end
                
            end
            
            % increment group number:
            group_number = group_number + 1;
            
        end
        
        % save info to structure:
        for j = 1:num_objects_stack

            % get index to use in large structure:
            index = rows_stack(j);

            % save results:
            objects(index).down_partner = objects_stack(j).down_partner;

        end
        
    end
    
    %% Connect up and down bowls:
    
    % for each image stack:
    for i = 1:num_stacks

        % get name of image to analyze:
        image_stack = image_stack_list(i);

        % get relevant results:
        rows_stack = find(extractfield(objects, 'stack_num') == image_stack);
        objects_stack = objects(1, rows_stack);
        
        % connect bowls:
        objects_stack_with_pairs = postprocessing.connect_up_and_down_bowls(objects_stack);
        
        % save:
        [objects(rows_stack)] = deal(objects_stack_with_pairs);  
        
    end

    %% Save results:
    
    % rename and remove fields:
    results = objects;
    results = rmfield(results, 'coordinates_mask');
    results = rmfield(results, 'up_partner');
    results = rmfield(results, 'down_partner');

    save('objects_4_connected.mat', 'results', '-v7.3');

end