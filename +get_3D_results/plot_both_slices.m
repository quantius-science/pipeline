function plot_both_slices(objects_seg, objects_conn, field_seg, field_conn)

    % get list of stacks:
    list_stacks = unique(extractfield(objects_seg, 'num_stack'));
    
    % get number of stacks:
    num_stacks = numel(list_stacks);
    
    % for each stack:
    for i = 1:num_stacks
       
        % get results for the stack:
        objects_seg_stack = utilities.get_structure_results_matching_number(objects_seg, 'num_stack', list_stacks(i));
        objects_conn_stack = utilities.get_structure_results_matching_number(objects_conn, 'num_stack', list_stacks(i));
        
        % create the figure:
        figure;

        % get number of objects:
        num_objects_seg_stack = numel(objects_seg_stack);
        num_objects_conn_stack = numel(objects_conn_stack);
        
        % for each seg object:
        for j = 1:num_objects_seg_stack

            % get points:
            points = objects_seg_stack(j).(field_seg);

            % plot:
            fill3(points(:,1), points(:,2), points(:,3), [1 0 0]);
            
            hold on;

        end

        % for each conn object:
        for j = 1:num_objects_conn_stack

            % get points:
            points = objects_conn_stack(j).(field_conn);
            
            % plot:
            fill3(points(:,1), points(:,2), points(:,3), [0 0 1]);
            
            hold on;

        end   
        
        hold off;
        
    end

end