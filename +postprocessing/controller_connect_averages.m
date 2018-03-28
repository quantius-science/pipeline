function controller_connect_averages(job_settings)  
    
    % get averaging results:
    objects = load(fullfile(job_settings.path_job, 'objects_3_averaged_cleaned.mat'));
    objects = objects.objects;
    
    % add feild to store temp object tracker:
    [objects(1:end).mask] = deal([]);
    [objects(1:end).temp_3D_num] = deal(0);

    % get list of image stacks:
    list_stacks = unique(extractfield(objects, 'num_stack'));

    % get number of stacks:
    num_stacks = numel(list_stacks);

    % for each stack:
    for i = 1:num_stacks

        % get objects for the stack:
        [objects_stack, rows_stack] = utilities.get_structure_results_matching_number(objects, 'num_stack', list_stacks(i));

        % perfom connecting:
        objects_stack = postprocessing.algorithm_connect_averages(objects_stack);
        
        % save info to  structure:
        objects(rows_stack) = objects_stack;
    
    end
    
    % clear extra variables:
    objects = rmfield(objects, 'mask');
    objects = rmfield(objects, 'temp_3D_num');
    objects = rmfield(objects, 'object_averaged_num');
    objects = rmfield(objects, 'object_averaged_color');
    
    % save:
    save(fullfile(job_settings.path_job, 'objects_4_connected.mat'), 'objects', '-v7.3');

end