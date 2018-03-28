function image_info = get_image_info(results_for_job, job_settings)

    % get image name submitted:
    image_info.image_name_submitted = utilities.get_file_name_without_extension(results_for_job.image_filename);

    % get slice number:
    index_slice = strfind(image_info.image_name_submitted, 's');
    image_info.num_slice = str2num(image_info.image_name_submitted((index_slice + 1):(index_slice+3))); 

    % get image name tiled:
    image_info.image_name_tiled = image_info.image_name_submitted(1:(index_slice-2));

    % get tile numbers:
    index_tile_row = strfind(image_info.image_name_tiled, 'r');        
    image_info.num_tile_row = str2num(image_info.image_name_tiled((index_tile_row + 1):(index_tile_row + 2)));
    index_tile_column = strfind(image_info.image_name_tiled, 'c');
    image_info.num_tile_column = str2num(image_info.image_name_tiled((index_tile_column + 1):(index_tile_column + 2)));

    % get image name cropped:
    image_info.image_name_cropped = image_info.image_name_tiled(1:(index_tile_row-2));

    % get image name renamed:
    image_info.image_name_renamed = image_info.image_name_cropped(1:9);

    % get stack number:
    image_info.num_stack = str2num(image_info.image_name_renamed(7:9));

    % get image size:
    image_info.height_tile = results_for_job.height;
    image_info.width_tile = results_for_job.width;
    
    % get image depth:
    [~, row] = utilities.get_structure_results_matching_string(job_settings.stack_info.info_rename, 'name_new', image_info.image_name_renamed);
    image_info.depth_original = job_settings.stack_info.info_rename(row).depth_original;

    % get worker ID:
    image_info.worker_id = results_for_job.worker_id;

end