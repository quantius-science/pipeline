function objects_cluster = algorithm_average_clusters_shape(objects_cluster)

    % get number of objects:
    num_objects = numel(objects_cluster);

    % create masks:
    image_height = objects_cluster(1).height_original;
    image_width = objects_cluster(1).width_original;
    mask = uint8(zeros(image_height, image_width, num_objects));
    for k = 1:num_objects

        % get coords:
        x = objects_cluster(k).coordinates(:,1);
        y = objects_cluster(k).coordinates(:,2);
        z = objects_cluster(k).coordinates(1,3);

        % add to mask array:
        mask(:, :, k) = uint8(poly2mask(x, y, image_height, image_width));

    end

    % average cluster - step 1 - sum:
    add = uint8(sum(mask, 3));

    % average cluster - step 2 - threshold:
    threshold = add;
    threshold(threshold <= 1) = 0; 

    % average cluster - step 3 - erode and dilate:
    SE = strel('disk', 2, 8);
    erode = imerode(threshold, SE);
    dilate = imdilate(erode, SE);

    % average cluster - step 4 - threshold:
    average = dilate;
    average(average >= 1) = 1;

    % get average boundaries:
    boundary = bwboundaries(average);
    
    % if there is an object:
    if size(boundary, 1) ~= 0

        % get points (and flip the x and y columns):
        boundary_xy = fliplr(boundary{1,1});

        % get z points:
        boundary_z = zeros(size(boundary{1,1}, 1), 1);
        boundary_z(:) = z;
        boundary_temp = [boundary_xy boundary_z];

        % save to results:
        objects_cluster(1).coordinates = boundary_temp;
        objects_cluster(1).temp_tracker = 1;
        objects_cluster(1).object_averaged_num = objects_cluster(1).object_clustered_num;
        objects_cluster(1).object_averaged_color = objects_cluster(1).object_clustered_color;

    end  

end