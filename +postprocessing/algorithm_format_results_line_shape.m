function [results_formatted, index] = algorithm_format_results_line_shape(results_formatted, results_for_job, image_info, index)

    % get number of objects:
    num_objects = size(results_for_job.raw_data, 2);

    % for each object:
    for j = 1:num_objects

        % get object number:
        worker_object_num = j;

        % get result for object:
        results_for_object = results_for_job.raw_data{1,j};

        % get number of points in the object:
        num_points = size(results_for_object, 2);

        % create array to store coordinates:
        coordinates = zeros(num_points, 3);

        % for each point:
        for k = 1:num_points

            % get result:
            results_for_point = results_for_object{1,k};

            % get coordinates:
            coord_x = results_for_point.x;
            coord_y = results_for_point.y;

            % flip the y-coordinate:
            coord_y = image_info.height_tile - coord_y;

            % save coordinates:
            coordinates(k, :) = [coord_x coord_y image_info.num_slice];

        end

        % add to structure:
        results_formatted(index).image_name_submitted = image_info.image_name_submitted;
        results_formatted(index).image_name_tiled = image_info.image_name_tiled;
        results_formatted(index).image_name_cropped = image_info.image_name_cropped;
        results_formatted(index).image_name_renamed = image_info.image_name_renamed;
        results_formatted(index).num_slice = image_info.num_slice;
        results_formatted(index).num_tile_row = image_info.num_tile_row;
        results_formatted(index).num_tile_column = image_info.num_tile_column;
        results_formatted(index).num_stack = image_info.num_stack;
        results_formatted(index).height_original = 0;
        results_formatted(index).height_crop = 0;
        results_formatted(index).height_tile = image_info.height_tile;
        results_formatted(index).width_original = 0;
        results_formatted(index).width_crop = 0;
        results_formatted(index).width_tile = image_info.width_tile;
        results_formatted(index).depth_original = image_info.depth_original;
        results_formatted(index).worker_id = image_info.worker_id;
        results_formatted(index).worker_object_num = worker_object_num;
        results_formatted(index).coordinates = coordinates;
        results_formatted(index).object_clustered_num = 0;
        results_formatted(index).object_clustered_color = [];
        results_formatted(index).object_averaged_num = 0;
        results_formatted(index).object_averaged_color = [];
        results_formatted(index).object_connected_num = 0;
        results_formatted(index).object_connected_color = [];
        
        % increment index:
        index = index + 1;

    end 

end