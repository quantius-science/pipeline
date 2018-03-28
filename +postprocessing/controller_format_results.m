function controller_format_results(job_settings)
    
    % load results:
    results = loadjson(fullfile(job_settings.path_job, 'results_1_raw.json'));
    
    % if the tool use was Crosshairs:
    if strcmp(job_settings.tool, 'Crosshairs')
        
        % get the number of annotations:
        num_annotations = sum(cellfun(@(x) cellfun(@(x) size(x, 2), x.raw_data), results));
        
    % for all other tools:
    else
        
        % get the number of annotations:
        num_annotations = sum(cellfun(@(x) size(x.raw_data, 2), results));
        
    end
    
    % get number of jobs:
    num_jobs = size(results, 2);
    
    % make structure to store per-object results:
    [results_formatted(1:num_annotations).image_name_submitted] = deal('temp');
    [results_formatted(1:num_annotations).image_name_tiled] = deal('temp');
    [results_formatted(1:num_annotations).image_name_cropped] = deal('temp');
    [results_formatted(1:num_annotations).image_name_renamed] = deal('temp');
    [results_formatted(1:num_annotations).num_slice] = deal(0);
    [results_formatted(1:num_annotations).num_tile_row] = deal(0);
    [results_formatted(1:num_annotations).num_tile_column] = deal(0);
    [results_formatted(1:num_annotations).num_stack] = deal(0);
    [results_formatted(1:num_annotations).height_original] = deal(0);
    [results_formatted(1:num_annotations).height_crop] = deal(0);
    [results_formatted(1:num_annotations).height_tile] = deal(0);
    [results_formatted(1:num_annotations).width_original] = deal(0);
    [results_formatted(1:num_annotations).width_crop] = deal(0);
    [results_formatted(1:num_annotations).width_tile] = deal(0);
    [results_formatted(1:num_annotations).depth_original] = deal(0);
    [results_formatted(1:num_annotations).worker_id] = deal('temp');
    [results_formatted(1:num_annotations).worker_object_num] = deal(0);
    [results_formatted(1:num_annotations).coordinates] = deal(0);
    [results_formatted(1:num_annotations).object_clustered_num] = deal(0);
    [results_formatted(1:num_annotations).object_clustered_color] = deal([]);
    [results_formatted(1:num_annotations).object_averaged_num] = deal(0);
    [results_formatted(1:num_annotations).object_averaged_color] = deal([]);
    [results_formatted(1:num_annotations).object_connected_num] = deal(0);
    [results_formatted(1:num_annotations).object_connected_color] = deal([]);
    
    % start index to track annotation number:
    index = 1;

    % for each job:
    for i = 1:num_jobs
       
        % get result:
        results_for_job = results{1,i};

        % get image info:
        image_info = utilities.get_image_info(results_for_job, job_settings);
        
        % if worker found any objects:
        if size(results_for_job.raw_data, 1) ~= 0
            
            % format results:
            [results_formatted, index] = postprocessing.algorithm_format_results(job_settings.tool, results_formatted, results_for_job, image_info, index);
            
        end
        
    end

    % remove empty rows:
    % occurs when worker finds no objects in an image
    [~, rows_empty] = utilities.get_structure_results_matching_number(results_formatted, 'worker_object_num', 0);
    results_formatted(rows_empty) = [];
    
    % sort formatted results alphabetically:
    fields = fieldnames(results_formatted);
    results_formatted_cell = struct2cell(results_formatted);
    size_cell = size(results_formatted_cell);
    results_formatted_cell = reshape(results_formatted_cell, size_cell(1), []); 
    results_formatted_cell = results_formatted_cell';
    results_formatted_cell = sortrows(results_formatted_cell, 1); % sort by 1st field
    results_formatted_cell = reshape(results_formatted_cell', size_cell);
    results_formatted = cell2struct(results_formatted_cell, fields, 1);
    
    % save: 
    save(fullfile(job_settings.path_job, 'results_2_formatted.mat'), 'results_formatted');

end