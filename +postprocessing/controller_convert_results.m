function controller_convert_results(job_settings)
    
    % get cleaned results:
    results = load(fullfile(job_settings.path_job, 'results_3_formatted_cleaned.mat'));
    results = results.results;

    % get number of results:
    num_results = size(results, 2);

    % for each result:
    for i = 1:num_results

        % get result:
        results_single = results(:,i);

        % get coordinates:
        temp_coords = results_single.coordinates;

        % determine tile info to use:
        row_tiling = strcmp(results_single.image_name_tiled, extractfield(job_settings.stack_info.info_tile, 'name_new'));
        info_tile_single = job_settings.stack_info.info_tile(row_tiling);
    
        % convert coordinates to cropped:
        x_temp = temp_coords(:,1);
        y_temp = temp_coords(:,2);
        x_temp = x_temp + (info_tile_single.tile_x_start - 1);
        y_temp = y_temp + (info_tile_single.tile_y_start - 1);

        % save crop image sizes:
        results(i).height_crop = info_tile_single.crop_height;
        results(i).width_crop = info_tile_single.crop_width;

        % determine crop info to use:
        row_cropping = strcmp(results_single.image_name_cropped, extractfield(job_settings.stack_info.info_crop, 'name_new'));
        info_crop_single = job_settings.stack_info.info_crop(row_cropping);

        % convert coordinates to original:
        x_temp = x_temp + (info_crop_single.crop_x_start - 1);
        y_temp = y_temp + (info_crop_single.crop_y_start - 1);

        % save tile image sizes:
        results(i).height_original = info_crop_single.original_height;
        results(i).width_original = info_crop_single.original_width;

        % save converted results:
        results(i).coordinates(:,1) = x_temp;
        results(i).coordinates(:,2) = y_temp;
    
    end

    % remove fields that are no longer needed:
    results = rmfield(results, 'image_name_submitted');
    results = rmfield(results, 'image_name_tiled');
    results = rmfield(results, 'image_name_cropped');
    results = rmfield(results, 'num_tile_row');
    results = rmfield(results, 'num_tile_column');
    results = rmfield(results, 'height_crop');
    results = rmfield(results, 'height_tile');
    results = rmfield(results, 'width_crop');
    results = rmfield(results, 'width_tile');
    
    % save results:
    save(fullfile(job_settings.path_job, 'results_4_converted.mat'), 'results');

end