function objects_stack = algorithm_connect_averages(objects_stack)

    % get number of objects in the stack:
    num_objects_stack = numel(objects_stack);

    % get maximum slice number:
    slice_max = max(unique(extractfield(objects_stack, 'num_slice')));

    % for each object in the stack:
    image_height = objects_stack(1).height_original;
    image_width = objects_stack(1).width_original;
    for j = 1:num_objects_stack

        % get coords:
        x = objects_stack(j).coordinates(:, 1);
        y = objects_stack(j).coordinates(:, 2);

        % add mask to results:
        objects_stack(j).mask = poly2mask(x, y, image_height, image_width); 

        % add object number:
        objects_stack(j).temp_3D_num = j;

    end

    % create array to store connections:
    connection = zeros(num_objects_stack);

    % for each object in stack:
    for j = 1:num_objects_stack

        % get mask for first object:
        object_1 = objects_stack(j).mask;

        % get object number for first object:
        object_1_num = objects_stack(j).temp_3D_num;

        % get slice number of first object:
        slice = objects_stack(j).num_slice;

        % determine the slice below:
        slice_below = slice - 1;

        % if the slice below exists:
        if slice_below > 0

            % get num objects on the slice below:
            objects_below = utilities.get_structure_results_matching_number(objects_stack, 'num_slice', slice_below);

            % get number of objects:
            num_objects_below = numel(objects_below);

            % for each object:
            for k = 1:num_objects_below

                % get mask for second object:
                object_2 = objects_below(k).mask;

                % get object number for second object:
                object_2_num = objects_below(k).temp_3D_num;

                % get overlap:
                connection(object_1_num, object_2_num) = nnz(object_1 & object_2)/nnz(object_1);

            end

        end

        % determine the slice above:
        slice_above = slice + 1;

        % if the slice above exists:
        if slice_above <= slice_max

            % get num objects on the slice above:
            objects_above = utilities.get_structure_results_matching_number(objects_stack, 'num_slice', slice_above);

            % get number of objects:
            num_objects_above = numel(objects_above);

            % for each object:
            for k = 1:num_objects_above

                % get mask for second object:
                object_2 = objects_above(k).mask;

                % get object number for second object:
                object_2_num = objects_above(k).temp_3D_num;

                % get overlap:
                connection(object_1_num, object_2_num) = nnz(object_1 & object_2)/nnz(object_1);

            end

        end

    end

    % threshold overlap:
    connection(connection < 0.5) = 0;

    % convert overlap to adjacency matrix:
    adjacency = connection;

    % convert adjacency matrix to directed graph:
    graph = digraph(adjacency);

    % cluster objects:
    clusters = num2cell(conncomp(graph))';

    % get number of clusters:
    num_clusters = max([clusters{:}]);

    % create color assignments for each cluster:
    colors = distinguishable_colors(num_clusters, {'w', 'k'});
    
    % save info to slice structure:
    for k = 1:num_objects_stack

        % save results to structure:
        objects_stack(k).object_connected_num = clusters{k,1};
        objects_stack(k).object_connected_color = colors(clusters{k, 1}, :);

    end

end