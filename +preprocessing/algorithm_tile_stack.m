function [job_settings, index] = algorithm_tile_stack(job_settings, paths, list_stacks, i, index)
    
    % get image name (with and without extension):
    name_old = list_stacks(i).name;
    name_old_no_ext = utilities.get_file_name_without_extension(name_old);

    % load image:
    image_structure = readmm(fullfile(paths{2}, name_old));
    image = image_structure.imagedata;

    % get middle slice:
    image_slice_middle = image(:,:,round(size(image, 3)/2));

    % set type of tiling to perform:
    type_tile = preprocessing.gui_to_set_tile_type(image_slice_middle);
     
    % get default crop values:
    tile_coords.crop_height = image_structure.height;
    tile_coords.crop_width = image_structure.width;    
    tile_coords.num_tiles_x = 1;
    tile_coords.num_tiles_y = 1;
    tile_coords.overlap_x = 0;
    tile_coords.overlap_y = 0;
    tile_coords.tile_start_x = 1;
    tile_coords.tile_end_x = tile_coords.crop_width;
    tile_coords.tile_start_y = 1;
    tile_coords.tile_end_y = tile_coords.crop_height;
        
    % update tile coords:
    if type_tile == 1
        
        tile_coords = preprocessing.gui_to_set_tile_parameters(image_slice_middle, tile_coords);

    end 
    
    % tile image:
    for j = 1:tile_coords.num_tiles_x

        % get x coordinates:
        temp_x_start = tile_coords.tile_start_x(j);
        temp_x_end = tile_coords.tile_end_x(j);

        % for each column:
        for k = 1:tile_coords.num_tiles_y

            % get y coordinates:
            temp_y_start = tile_coords.tile_start_y(k);
            temp_y_end = tile_coords.tile_end_y(k);

            % crop image:
            image_tile = image(temp_y_start:temp_y_end, temp_x_start:temp_x_end, :); 

            % save tile:
            name_new_no_ext = [name_old_no_ext sprintf('_r%02d_c%02d', k, j)];
            utilities.save_stack(image_tile, [name_new_no_ext '.tif'], paths{3});

            % save tile info:
            job_settings.stack_info.info_tile(index).name_new = name_new_no_ext;
            job_settings.stack_info.info_tile(index).name_old = name_old_no_ext;
            job_settings.stack_info.info_tile(index).type_tile = type_tile;
            job_settings.stack_info.info_tile(index).crop_height = tile_coords.crop_height;
            job_settings.stack_info.info_tile(index).crop_width = tile_coords.crop_width;
            job_settings.stack_info.info_tile(index).num_row = k;
            job_settings.stack_info.info_tile(index).num_column = j;
            job_settings.stack_info.info_tile(index).tile_x_start = temp_x_start;
            job_settings.stack_info.info_tile(index).tile_x_end = temp_x_end;
            job_settings.stack_info.info_tile(index).tile_y_start = temp_y_start;
            job_settings.stack_info.info_tile(index).tile_y_end = temp_y_end;
            
            % increment index:
            index = index + 1;

        end
        
    end

end