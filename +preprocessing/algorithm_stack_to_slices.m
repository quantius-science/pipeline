function job_settings = algorithm_stack_to_slices(job_settings, paths, list_stacks, i)    

    % get image name (with and without extension):
    name_old = list_stacks(i).name;
    name_old_no_ext = utilities.get_file_name_without_extension(name_old);

    % load image:
    image_structure = readmm(fullfile(paths{2}, name_old));
    image = image_structure.imagedata;
    
    % get number of slices:
    num_slices = size(image, 3);
    
    % determine if you want to use every slice:
    every_slice_status = questdlg('Do you want to submit every slice?', ...
        'Slice Selection', 'Yes', 'No', 'Yes');
    
    % if you do not want to use every slice:
    if strcmp(every_slice_status, 'No')
       
        % determine slice frequency:
        slice_frequency = inputdlg('How frequent do you want the slices to be?', ...
            'Slice Frequency');
        slice_frequency = str2double(slice_frequency{1});
        
    else 
        
        % set slice frequency to every slice:
        slice_frequency = 1;
        
    end
    
    % for each slice:
    for j = 1:num_slices
       
        % if this slice should be saved:
        if mod(j, slice_frequency) == 0
        
            % get slice name:
            name_new_no_ext = sprintf('%s_s%03d', name_old_no_ext, j);
            name_new = [name_new_no_ext '.tif'];

            % save image:
            imwrite(image(:, :, j), fullfile(paths{3}, name_new));
            
        end
        
    end

end