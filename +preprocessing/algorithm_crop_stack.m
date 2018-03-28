function job_settings = algorithm_crop_stack(job_settings, paths, list_stacks, i)
    
    % get image name (with and without extension):
    name_old = list_stacks(i).name;
    name_old_no_ext = utilities.get_file_name_without_extension(name_old);

    % load image:
    image_structure = readmm(fullfile(paths{2}, name_old));
    image = image_structure.imagedata;

    % get default crop values:
    crop_coords.original_height = image_structure.height;
    crop_coords.original_width = image_structure.width;
    crop_coords.x_start = 1;
    crop_coords.x_end = crop_coords.original_width;
    crop_coords.y_start = 1;
    crop_coords.y_end = crop_coords.original_height;

    % calculate max merge:
    image_max = max(image, [], 3);

    % get type of cropping to perform:
    type_crop = preprocessing.gui_to_set_crop_type(image_max);

    % get crop coordinates:
    if type_crop == 1

        % crop automatically:
        crop_coords = preprocessing.get_crop_coords_automatic(image_max, crop_coords);

    elseif type_crop == 2

        % crop manually:
        crop_coords = preprocessing.get_crop_coords_manual(image_max, crop_coords);

    end 
    
    % crop image:
    if type_crop == 0
        
        % do nothing:
        image_crop = image;
        
    elseif (type_crop == 1) || (type_crop == 2)
        
        % crop image:
        image_crop = image(crop_coords.y_start:crop_coords.y_end, crop_coords.x_start:crop_coords.x_end, :);
        
    end

    % save cropped image:
    name_new_no_ext = [name_old_no_ext '_b001'];
    utilities.save_stack(image_crop, [name_new_no_ext '.tif'], paths{3});

    % save crop info:
    job_settings.stack_info.info_crop(i).name_new = name_new_no_ext;
    job_settings.stack_info.info_crop(i).name_old = name_old_no_ext;
    job_settings.stack_info.info_crop(i).type_crop = type_crop;
    job_settings.stack_info.info_crop(i).original_height = crop_coords.original_height;
    job_settings.stack_info.info_crop(i).original_width = crop_coords.original_width;
    job_settings.stack_info.info_crop(i).crop_x_start = crop_coords.x_start;
    job_settings.stack_info.info_crop(i).crop_x_end = crop_coords.x_end;
    job_settings.stack_info.info_crop(i).crop_y_start = crop_coords.y_start;
    job_settings.stack_info.info_crop(i).crop_y_end = crop_coords.y_end;
    
end