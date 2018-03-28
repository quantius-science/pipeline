function job_settings = controller_convert_to_png(job_settings, input_folder_name, output_folder_name)

    % get step number:
    step = utilities.get_folder_number(job_settings.path_job);
    
    % get paths:
    paths = utilities.get_all_paths(job_settings.path_job, input_folder_name, output_folder_name, step); 
    
    % get list of image stacks:
    list_stacks = dir(fullfile(paths{2}, 'j*.tif'));
    
    % get number of image stacks:
    num_stacks = numel(list_stacks);
    
    % for each stack:
    for i = 1:num_stacks
        
        % get old image name:
        name_old = list_stacks(i).name;
        name_old_no_ext = utilities.get_file_name_without_extension(name_old);
        
        % load image:
        image_structure = readmm(fullfile(paths{2}, name_old));
        image = image_structure.imagedata;

        % convert to png:
        imwrite(image, fullfile(paths{3}, [name_old_no_ext '.png']), 'png');
        
    end

end