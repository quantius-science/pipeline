function controller_view_averages(job_settings, input_folder_name, output_folder_name)
    
    % get step number:
    step = utilities.get_folder_number(job_settings.path_job);
    
    % get paths:
    paths = utilities.get_all_paths(job_settings.path_job, input_folder_name, output_folder_name, step);         

    % get file with averaged results:
    objects = load(fullfile(job_settings.path_job, 'objects_2_averaged.mat'));
    objects = objects.objects;
    
    % get list of image stacks:
    list_stacks = unique(extractfield(objects, 'num_stack'));

    % get number of stacks:
    num_stacks = numel(list_stacks);

    % for each stack:
    for i = 1:num_stacks

        % get objects for the stack:
        objects_stack = utilities.get_structure_results_matching_number(objects, 'num_stack', list_stacks(i));

        % load image:
        image_name = objects_stack(1).image_name_renamed;
        image = readmm(fullfile(paths{2}, [image_name '.tif']));
        image = image.imagedata;

        % get list of image slices:
        list_slices = unique(extractfield(objects_stack, 'num_slice'));

        % get number of slices:
        num_slices = numel(list_slices);
    
        % for each slice:
        for j = 1:num_slices

            % get image slice:
            image_slice = image(:,:,list_slices(j));

            % create rgb version of image to overlay results:
            image_slice = repmat(image_slice, [1 1 3]);

            % get objects for the slice:
            objects_slice = utilities.get_structure_results_matching_number(objects_stack, 'num_slice', list_slices(j));
            
            % get number of objects:
            num_objects_slice = numel(objects_slice);

            % for each object:
            for k = 1:num_objects_slice

                % add object to image:
                image_slice = utilities.add_result_to_image(job_settings.tool, image_slice, objects_slice(1,k).coordinates, objects_slice(1,k).object_averaged_color);

            end
            
            % save image with results overlaid:
            imwrite(image_slice, fullfile(paths{3}, [image_name sprintf('_s%03d.tif', list_slices(j))]));

        end

    end
    
end