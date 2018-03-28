function path_output_folder = get_folder_output(path_job, string, step)

    % create folder name:
    folder_name = sprintf('%02d_%s', step, string);
    
    % get path to output folder:
    path_output_folder = fullfile(path_job, folder_name);
    
    % make output folder:
    mkdir(path_output_folder);

end