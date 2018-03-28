function path_input_folder = get_folder_input(path_job, string)

    % get info for folder with name containing string:
    folder = dir(fullfile(path_job, ['*' string '*']));
    
    % get folder name:
    path_input_folder = fullfile(folder.folder, folder.name);
    
end