function controller_clean_averages(job_settings)
    
    % get averaging results:
    objects = load(fullfile(job_settings.path_job, 'objects_2_averaged.mat'));
    objects = objects.objects;

    % create array to store rows to remove:
    rows_remove = [];
    
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
            
            % perform average cleaning:
            rows_remove_slice = postprocessing.algorithm_clean_averages(objects_slice);
            
            % convert rows to remove to stack indices:
            rows_remove_stack = rows_slice(rows_remove_slice);
            
            % convert rows to remove to overall indices:
            rows_remove_all = rows_stack(rows_remove_stack);
            
            % add to list of rows to remove:
            rows_remove = [rows_remove rows_remove_all];
            
        end
    
    end

    % remove rows corresponding to objects to be deleted:
    objects(rows_remove) = [];

    % save: 
    save(fullfile(job_settings.path_job, 'objects_3_averaged_cleaned.mat'), 'objects');

end