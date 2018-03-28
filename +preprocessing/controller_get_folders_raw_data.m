function job_settings = controller_get_folders_raw_data(job_settings)

    % create cell to store paths to raw images:
    job_settings.path_data = cell(0);
    
    % initialize variable to track folders added to list:
    path_temp = 1;
    while path_temp ~= 0
       
        % get folder containing data:
        path_temp = uigetdir;
        
        % if folder is chosen:
        if path_temp ~= 0
        
            % save folder to cell:
            job_settings.path_data{end+1} = path_temp;
        
        end
        
    end

end