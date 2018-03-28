function paths = get_all_paths(path_job, input_folder_name, output_folder_name, step)

    % set path of job folder:
    paths{1} = path_job; 
    
    % set path of input folder:
    paths{2} = utilities.get_folder_input(path_job, input_folder_name);
    
    % set path of output folder:
    paths{3} = utilities.get_folder_output(path_job, output_folder_name, step); 

end