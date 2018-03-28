function prepare_images_for_Quantius

    % get path to images:
    path_images = uigetdir;
    
    % get list of all images:
    list_images = dir(fullfile(path_images, 'pos*.lsm'));
    
    % get number of images:
    num_images = numel(list_images);
    
    % determine if you want to get orthogonal slices:
    ortho_decision = questdlg('Do you want to make orthogonal slices?', '', 'Yes', 'No', 'Yes');
    
    % make folders to store prepared images:
    path_images_xy = fullfile(path_images, 'images_xy');
    mkdir(path_images_xy);
    if strcmp(ortho_decision, 'Yes')
       path_images_ortho = fullfile(path_images, 'images_ortho');
       mkdir(path_images_ortho); 
    end
    
    % create struct to save image prep info:
    image_info = struct;
    [image_info(1:num_images).image_name_original] = deal('');
    [image_info(1:num_images).image_number] = deal(0);
    [image_info(1:num_images).slice_start] = deal(0);
    [image_info(1:num_images).slice_end] = deal(0);
    [image_info(1:num_images).orthogonal_slice] = deal('none');
    [image_info(1:num_images).slice_start_ortho] = deal(0);
    [image_info(1:num_images).slice_end_ortho] = deal(0);
    [image_info(1:num_images).stretch_factor] = deal(0);
    
    % for each image:
    for i = 1:num_images
        
        % read the image:
        image = lsmread(fullfile(path_images, list_images(i).name));
                
        % eliminate time dimension of stack:
        image = squeeze(image);

        % re-arrange slice dimensions  to [rows cols slices channels]:
        image = permute(image, [3 4 2 1]);
        
        % get number of channels:
        num_channels = size(image, 4);
        
        % get name of each channel:
        channel_names = prepare_images.get_channel_names(image);
        
        % crop image in z:
        [image_cropped, slice_start, slice_end] = prepare_images.crop_image_in_z(image);
        
        % save individual channels (as grayscale):
        for j = 1:num_channels
           
            % get name of image:
            image_name = sprintf('prepped_%s%03d.tif', channel_names{j}, i);
            
            % save:
            utilities.save_stack(squeeze(image_cropped(:,:,:,j)), image_name, path_images_xy);
            
            % if the channel is dapi:
            if strcmp(channel_names{j}, 'dapi')
                
                % if you want orthogonal slices:
                if strcmp(ortho_decision, 'Yes')
                    
                    % set plane to use:
                    plane = 'xz';
                    
                    % get orthogonal slices:
                    image_cropped_ortho = ...
                        utilities.get_orthogonal_slices(...
                        squeeze(image_cropped(:,:,:,j)), plane);
                    
                    % save orthogonal slices:
                    image_3_ortho = image_cropped_ortho;
                    
                    % determine how much to stretch slices using middle slice:
                    middle = round(size(image_cropped_ortho, 3) / 2);
                    factor = prepare_images.gui_to_set_stretch_factor(image_cropped_ortho(:,:,middle));
                    
                    % get image size:
                    [num_rows, num_columns, num_slices] = size(image_cropped_ortho);

                    % resize slices:
                    image_cropped_ortho = imresize3(image_cropped_ortho, ...
                        [(factor*num_rows) num_columns num_slices]);
                    
                    % save stretched slices:
                    image_2_stretched = image_cropped_ortho;
                    
                    % crop image in z:
                    [image_cropped_ortho, slice_start_ortho, slice_end_ortho] = prepare_images.crop_image_in_z(image_cropped_ortho);
                    
                    % save croped slices:
                    image_1_cropped = image_cropped_ortho;
                    
                    % save:
                    utilities.save_stack(image_cropped_ortho, image_name, path_images_ortho);
                    utilities.save_stack(image_3_ortho, 'ortho_3.tif', path_images_ortho);
                    utilities.save_stack(image_2_stretched, 'stretched_2.tif', path_images_ortho);
                    utilities.save_stack(image_1_cropped, 'cropped_1.tif', path_images_ortho);
                    
                end
                
            end
            
        end
        
        % save:
        image_info(i).image_name_original = list_images(i).name;
        image_info(i).image_number = i;
        image_info(i).slice_start = slice_start;
        image_info(i).slice_end = slice_end;
        image_info(i).orthogonal_slice = plane;
        image_info(i).slice_start_ortho = slice_start_ortho;
        image_info(i).slice_end_ortho = slice_end_ortho;
        image_info(i).stretch_factor = factor;
     
    end
    
    % save info about image prep:
    save(fullfile(path_images, 'info_image_prep.mat'), 'image_info');

end