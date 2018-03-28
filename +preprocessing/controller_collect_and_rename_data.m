function job_settings = controller_collect_and_rename_data(job_settings)

    % get output path:
    path_output = utilities.get_folder_output(job_settings.path_job, 'original', 1);

    % get number of folders:
    num_folders = size(job_settings.path_data, 2);
    
    % count number of images in all the folders:
    job_settings.num_stacks = sum(cellfun(@(x) numel(dir(fullfile(x, [job_settings.channel '*.tif']))), job_settings.path_data));
    
    % create structure to store data info:
    job_settings.stack_info = struct;
    temp_rename_struct = struct('name_new', 'temp', 'name_old', 'temp', 'path_new', 'temp', 'path_old', 'temp');
    [job_settings.stack_info.info_rename(1:job_settings.num_stacks)] = deal(temp_rename_struct);
    
    % set index:
    index = 1;
    
    % for each folder:
    for i = 1:num_folders
        
        % get list of image stacks in the folder:
        files = dir(fullfile(job_settings.path_data{i}, [job_settings.channel '*.tif']));
        
        % for each image stack in the folder:
        for j = 1:length(files)
            
            % get image stack name:
            name_old = files(j).name;
            name_old_no_ext = utilities.get_file_name_without_extension(name_old);
            
            % get name image stack name:
            name_new_no_ext = sprintf('j%03d_i%03d', job_settings.job_number, index);
            name_new = [name_new_no_ext '.tif'];

            % rename and move image stack:
            input_name = fullfile(job_settings.path_data{i}, name_old); 
            output_name = fullfile(path_output, name_new);
            copyfile(input_name, output_name); 
            
            % load stack:
            stack = readmm(fullfile(job_settings.path_data{i}, name_old));
            
            % get stack size:
            num_slices = stack.numplanes;
            
            % save renaming info:
            job_settings.stack_info.info_rename(index).name_new = name_new_no_ext;
            job_settings.stack_info.info_rename(index).name_old = name_old_no_ext;
            job_settings.stack_info.info_rename(index).path_new = path_output;
            job_settings.stack_info.info_rename(index).path_old = job_settings.path_data{i};
            job_settings.stack_info.info_rename(index).depth_original = num_slices;

            % increment index:
            index = index + 1;
           
        end
        
    end
   
end