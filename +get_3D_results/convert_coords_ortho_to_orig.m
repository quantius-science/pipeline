function objects_conn = convert_coords_ortho_to_orig(objects_conn, job_settings_conn)

    % add field to store converted coordinates:
    [objects_conn(1:end).coordinates_converted] = deal([]);
    
    % for each conn object:
    for i = 1:numel(objects_conn)
       
        % get stack:
        num_stack = objects_conn(i).num_stack;
        
        % get new image name:
        name_new = objects_conn(i).image_name_renamed;
        
        % get old image name:
        name_old = utilities.get_structure_results_matching_string(job_settings_conn.stack_info.info_rename, 'name_new', name_new);
        name_old = name_old.name_old;
        
        % get old image number:
        num_old = str2double(name_old(end-2:end));
        
        % get path to original images and image prep info:
        path_ortho = job_settings_conn.stack_info.info_rename(num_stack).path_old;
        [path_ortho, ~, ~] = fileparts(path_ortho);
        
        % get settings used to create ortho slices:
        info_ortho = load(fullfile(path_ortho, 'info_image_prep.mat'));
        info_ortho = info_ortho.image_info;
        
        % get settings used for this stack:
        info_ortho_stack = utilities.get_structure_results_matching_number(info_ortho, 'image_number', num_old);
        
        % convert coordinates:
        objects_conn(i).coordinates_converted = get_3D_results.convert_coords_ortho_to_orig_algorithm(objects_conn(i), info_ortho_stack);

    end
    
end