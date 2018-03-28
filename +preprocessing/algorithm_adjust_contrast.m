function job_settings = algorithm_adjust_contrast(job_settings, paths, list_stacks, i)
    
    % get image name (with and without extension):
    name_old = list_stacks(i).name;
    name_old_no_ext = utilities.get_file_name_without_extension(name_old);

    % load image:
    image_structure = readmm(fullfile(paths{2}, name_old));
    image = image_structure.imagedata;
    
    % get middle slice:
    image_slice_middle = image(:,:,round(size(image, 3)/2));
    
    % determine if you want to perform contrast adjustment:
    type_contrast = preprocessing.gui_to_set_contrast_type(image_slice_middle);
    
    % make array to store processed image:
    image_adjusted = image;
    
    % set default contrast parameters:
    contrast_parameters.imadjust = 0;
    contrast_parameters.min = 0;
    contrast_parameters.max = 0;
    contrast_parameters.gamma = 0;
    contrast_parameters.imsharpen = 0;
    contrast_parameters.radius = 0;
    contrast_parameters.amount = 0;
    contrast_parameters.threshold = 0;
    
    % if you want to contrast adjust the images:
    if type_contrast == 0
        
        % do nothing
        
    elseif type_contrast == 1
        
        % set contrast adjustment parameters:
        contrast_parameters = preprocessing.gui_to_set_contrast_parameters(image);

        % get number of slices:
        num_slices = size(image_adjusted, 3);

        % for each slice:
        for j = 1:num_slices

            % if sharpening used:
            if contrast_parameters.imsharpen == 1

                % apply imsharpen:
                image_adjusted(:,:,j) = imsharpen(image_adjusted(:,:,j), ...
                'Radius', contrast_parameters.radius, ...
                'Amount', contrast_parameters.amount, ...
                'Threshold', contrast_parameters.threshold); 

            end

            % if imadjust used
            if contrast_parameters.imadjust == 1

                % apply imadjust:
                image_adjusted(:,:,j) = imadjust(image_adjusted(:,:,j), ...
                    [contrast_parameters.min/100 contrast_parameters.max/100], ...
                    [0 1], contrast_parameters.gamma);

            end

        end
        
    end
    
    % save image:
    utilities.save_stack(image_adjusted, [name_old_no_ext '.tif'], paths{3});
    
    % save parameters:
    job_settings.stack_info.info_contrast(i).name = name_old_no_ext;
    job_settings.stack_info.info_contrast(i).type_contrast = type_contrast;
    job_settings.stack_info.info_contrast(i).imadjust = contrast_parameters.imadjust;
    job_settings.stack_info.info_contrast(i).min = contrast_parameters.min;
    job_settings.stack_info.info_contrast(i).max = contrast_parameters.max;
    job_settings.stack_info.info_contrast(i).gamma = contrast_parameters.gamma;
    job_settings.stack_info.info_contrast(i).imsharpen = contrast_parameters.imsharpen;
    job_settings.stack_info.info_contrast(i).radius = contrast_parameters.radius;
    job_settings.stack_info.info_contrast(i).amount = contrast_parameters.amount;
    job_settings.stack_info.info_contrast(i).threshold = contrast_parameters.threshold;

end