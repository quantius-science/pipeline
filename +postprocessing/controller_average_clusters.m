function controller_average_clusters(job_settings)

    % get clustering results:
    objects = load(fullfile(job_settings.path_job, 'objects_1_clustered.mat'));
    objects = objects.objects;

    % add field for tracking:
    [objects(1:end).temp_tracker] = deal(0);

    % get list of image stacks:
    list_stacks = unique(extractfield(objects, 'num_stack'));

    % get number of stacks:
    num_stacks = numel(list_stacks);

    % for each stack:
    for i = 1:num_stacks

        % get objects for the stack:
        [objects_stack, rows_stack] = utilities.get_structure_results_matching_number(objects, 'num_stack', list_stacks(i));

        % get list of image slices:
        list_slices = unique(extractfield(objects_stack, 'num_slice'));

        % get number of slices:
        num_slices = numel(list_slices);

        % for each slice:
        for j = 1:num_slices

            % get objects for the slice:
            [objects_slice, rows_slice] = utilities.get_structure_results_matching_number(objects_stack, 'num_slice', list_slices(j));
            
            % get list of clusters:
            list_clusters = unique(extractfield(objects_slice, 'object_clustered_num'));
            
            % get number of clusters:
            num_clusters = numel(list_clusters);
            
            % for each cluster:
            for k = 1:num_clusters
                
                % get objects for the cluster:
                [objects_cluster, rows_cluster] = utilities.get_structure_results_matching_number(objects_slice, 'object_clustered_num', list_clusters(k));
                
                % perform averaging:
                objects_cluster = postprocessing.algorithm_average_clusters(job_settings.tool, objects_cluster);
                
                % save info to slice structure:
                objects_slice(rows_cluster) = objects_cluster;
                
            end
            
            % save info to stack structure:
            objects_stack(rows_slice) = objects_slice;
    
        end
        
        % save info to structure:
        objects(rows_stack) = objects_stack;

    end
    
    % remove rows where temp tracker is 0:
    rows_full = find(extractfield(objects, 'temp_tracker') == 1);
    objects = objects(:, rows_full);
    
    % remove unnecessary fields:
    objects = rmfield(objects, 'temp_tracker');
    objects = rmfield(objects, 'worker_id');
    objects = rmfield(objects, 'worker_object_num');
    objects = rmfield(objects, 'object_clustered_num');
    objects = rmfield(objects, 'object_clustered_color');
    
    % save results:
    save(fullfile(job_settings.path_job, 'objects_2_averaged.mat'), 'objects');

end