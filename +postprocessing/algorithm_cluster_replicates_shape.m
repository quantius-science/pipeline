function objects_slice = algorithm_cluster_replicates_shape(objects_slice)

    % get number of objects:
    num_objects_slice = numel(objects_slice);

    % create mask for each object:
    image_height = objects_slice(1).height_original;
    image_width = objects_slice(1).width_original;
    masks = zeros(image_height, image_width, num_objects_slice);
    for k = 1:num_objects_slice

        masks(:, :, k) = poly2mask(...
            objects_slice(k).coordinates(:, 1), ...
            objects_slice(k).coordinates(:, 2), ...
            image_height, image_width); 

    end

    % create array to store object overlaps:
    overlap = zeros(num_objects_slice);

    % calculate overlap as fraction of pixels in first object:
    for k = 1:num_objects_slice

        % get mask of first object:
        object_1 = masks(:, :, k);

        % for each object: 
        for l = 1:num_objects_slice

            % exclude object from overlapping with itself:
            if k ~= l

                % get mask of second object:
                object_2 = masks(:, :, l);

                % calculate overlap:
                overlap(k, l) = nnz(object_1 & object_2)/nnz(object_1);

            end

        end

    end

    % threshold overlap to exclude small overlaps:
    overlap(overlap < 0.6) = 0;

    % create directed graph from overlap: 
    graph = digraph(overlap);

    % cluster objects:
    clusters = num2cell(conncomp(graph))';

    % get number of clusters:
    num_clusters = max([clusters{:}]);

    % create a unique color (avoid white and black) for each cluster:
    colors = distinguishable_colors(num_clusters, {'w', 'k'});

    % save info to slice structure:
    for k = 1:num_objects_slice

        % save results to structure:
        objects_slice(k).object_clustered_num = clusters{k,1};
        objects_slice(k).object_clustered_color = colors(clusters{k, 1}, :);

    end

end