function job_settings = controller_adjust_contrast(job_settings, input_folder_name, output_folder_name)
    
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
        
        % adjust contrast:
        job_settings = preprocessing.algorithm_adjust_contrast(job_settings, paths, list_stacks, i);
        
    end

end