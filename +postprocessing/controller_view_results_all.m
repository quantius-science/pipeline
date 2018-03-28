function controller_view_results_all(job_settings, input_folder_name, output_folder_name)  
  
    % get step number:
    step = utilities.get_folder_number(job_settings.path_job);
    
    % get paths:
    paths = utilities.get_all_paths(job_settings.path_job, input_folder_name, output_folder_name, step);  
    
    % get formatted results for the images that were submitted:
    results = load(fullfile(job_settings.path_job, 'results_3_formatted_cleaned.mat'), 'results');
    results = results.results;

    % get list of images:
    list_images = unique(extractfield(results, 'image_name_submitted'));

    % get number of images:
    num_images = numel(list_images);

    % for each image:
    for i = 1:num_images

        % load image:
        image_name = list_images{i};
        image = imread(fullfile(paths{2}, [image_name '.png']));

        % create rgb version of image to overlay results:
        image = repmat(image, [1 1 3]);

        % get results for the image:
        results_image = utilities.get_structure_results_matching_string(results, 'image_name_submitted', image_name);

        % get list of worker:
        list_workers = unique(extractfield(results_image, 'worker_id'));

        % get number of workers:
        num_workers = numel(list_workers);

        % get colors for workers:
        colormap = distinguishable_colors(num_workers, {'w', 'k'});

        % for each worker:
        for j = 1:num_workers

            % get results for the worker:
            results_worker = utilities.get_structure_results_matching_string(results_image, 'worker_id', list_workers{j});

            % get number of objects:
            num_objects = numel(results_worker);

            % for each object:
            for k = 1:num_objects

                % add object to image:
                image = utilities.add_result_to_image(job_settings.tool, image, results_worker(1,k).coordinates, colormap(j, :));

                % save image with results overlaid:
                imwrite(image, fullfile(paths{3}, [image_name '.tif']));

            end

        end

    end
    
end