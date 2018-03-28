function save_stack(image_stack, image_name, folder_path)

    % get number of slices:
    num_slices = size(image_stack, 3);

    % get full path to file:
    image_name_and_path = fullfile(folder_path, image_name);
    
    % save first slice:
    imwrite(image_stack(:, :, 1), image_name_and_path)
    
    % save all other slices:
    for i = 2:num_slices

        imwrite(image_stack(:, :, i), image_name_and_path, 'writemode', 'append');
        
    end

end