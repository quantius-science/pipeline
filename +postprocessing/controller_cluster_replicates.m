function controller_cluster_replicates(job_settings) 

    % get results:
    objects = load(fullfile(job_settings.path_job, 'results_4_converted.mat'));
    objects = objects.results;

    % get number of objects:
    num_objects_total = numel(objects);

    % create structure:
    objects(num_objects_total).object_clustered_num = 0;
    objects(num_objects_total).object_clustered_color = [];

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

            % perform clustering:
            objects_slice = postprocessing.algorithm_cluster_replicates(job_settings.tool, objects_slice);

            % save info to stack structure:
            objects_stack(rows_slice) = objects_slice;

        end

        % save info to  structure:
        objects(rows_stack) = objects_stack;

    end
    
    % remove rows where no cluster color (necessary since clustering points
    % also averages them):
    rows_keep = find(extractfield(objects, 'object_clustered_num') ~= 0);
    objects = objects(:, rows_keep);

    % save results:
    save(fullfile(job_settings.path_job, 'objects_1_clustered.mat'), 'objects');
    
end