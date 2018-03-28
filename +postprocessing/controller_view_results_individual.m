function controller_view_results_individual(job_settings, input_folder_name, output_folder_name)  
    
    % get formatted results for the images that were submitted:
    results = load(fullfile(job_settings.path_job, 'results_3_formatted_cleaned.mat'), 'results');
    results = results.results;
    
    % get step number:
    step = utilities.get_folder_number(job_settings.path_job);
    
    % get paths:
    paths = utilities.get_all_paths(job_settings.path_job, input_folder_name, output_folder_name, step); 

    % get all worker ids:
    list_worker_ids = unique(extractfield(results, 'worker_id'));
    
    % get number of workers:
    num_workers = numel(list_worker_ids);
    
    % create array to store paths to worker folders:
    paths_worker = cell(num_workers, 1);
    
    % for each worker:
    for i = 1:num_workers
                 
        % get worker id:
        worker = list_worker_ids{i};
        
        % make folder:
        mkdir(fullfile(paths{3}, worker));
        
        % get path to worker folder:
        paths_worker{i} = fullfile(paths{3}, worker);

        % get results for the worker:
        results_worker = utilities.get_structure_results_matching_string(results, 'worker_id', worker);

        % get images done by the worker:
        list_images = unique(extractfield(results_worker, 'image_name_submitted'));
        
        % get number of images done by the worker:
        num_images = numel(list_images);

        % for each image:
        for j = 1:num_images

            % load image:
            image_name = list_images{j};
            image = imread(fullfile(paths{2}, [image_name '.png']));

            % create rgb version of image to overlay results:
            image = repmat(image, [1 1 3]);

            % get results for the image:
            results_image = utilities.get_structure_results_matching_string(results_worker, 'image_name_submitted', image_name);

            % get number of objects:
            num_objects = numel(results_image);

            % for each object:
            for k = 1:num_objects

                % add object to image:
                image = utilities.add_result_to_image(job_settings.tool, image, results_image(1,k).coordinates, 'red');

                % save image with results overlaid:
                imwrite(image, fullfile(paths_worker{i}, [image_name '.tif']));

            end

        end
        
    end
    
end