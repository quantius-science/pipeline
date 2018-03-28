function rows_remove = algorithm_clean_averages(objects_slice)        

    % get number of clusters:
    num_objects = length(unique(extractfield(objects_slice, 'object_averaged_num')));

    % convert boundaries into masks:
    image_height = objects_slice(1).height_original;
    image_width = objects_slice(1).width_original;
    masks = uint8(zeros(image_height, image_width, num_objects));
    for j = 1:num_objects

        x = objects_slice(j).coordinates(:,1);
        y = objects_slice(j).coordinates(:,2);

        masks(:, :, j) = poly2mask(x, y, image_height, image_width);

    end

    % create array to store overlap:
    overlap = zeros(num_objects);

    % for each averaged object:
    for j = 1:num_objects

        % get mask of first object:
        object_1 = masks(:,:,j);

        % for each averaged object:
        for k = 1:num_objects

            % exclude objects from overlapping with themselves:
            if k ~= j

                % set second object:
                object_2 = masks(:,:,k);

                % calculate overlap:
                overlap(j, k) = nnz(object_1 & object_2)/nnz(object_1);

            end

        end

    end

    % determine objects that are under overlap threshold:
    threshold = 0.5;
    rows_remove = find(any(overlap > threshold, 2));
        
end