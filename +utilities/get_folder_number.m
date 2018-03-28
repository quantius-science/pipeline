function step = get_folder_number(path_job)

    % get list of folders:
    folder_list = dir(fullfile(path_job, '*_*'));
    folder_list = folder_list(cellfun(@(x) x == 1, extractfield(folder_list, 'isdir')), :);
    
    % get name of last folder:
    folder_last = folder_list(end).name;
    
    % get number of last folder:
    step = str2num(folder_last(1:2));
    
    % increment one:
    step = step + 1;

end