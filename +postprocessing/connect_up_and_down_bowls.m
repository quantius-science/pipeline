function objects_with_pairs = connect_up_and_down_bowls(objects)

    % create struct to store pairs:
    objects_with_pairs = objects;

    % get list of bowls (and remove 0 from list):
    list_bowls_up = unique(extractfield(objects, 'up_partner'));
    list_bowls_up(list_bowls_up == 0) = [];

    % get number of bowls:
    num_bowls_up = numel(list_bowls_up);

    % for each "up" bowl:
    for j = 1:num_bowls_up

        % get results for that bowl:
        rows_bowl_up = find(extractfield(objects, 'up_partner') == list_bowls_up(j));
        objects_bowl_up = objects(rows_bowl_up);

        % get top slice of the bowl:
        slice_top = objects_bowl_up(end).slice_num;
        
        % get down bowls on the slice above:
        rows_bowl_down = find(extractfield(objects, 'slice_num') == (slice_top  + 1));
        objects_bowl_down = objects(rows_bowl_down);
        if size(objects_bowl_down, 2) ~= 0
            
            rows_bowl_down = find(extractfield(objects_bowl_down, 'down_partner') ~= 0);
            objects_bowl_down = objects_bowl_down(rows_bowl_down);

            % get nuber of down bowls on the slice:
            num_bowls_down = size(objects_bowl_down, 2);

            % get overlap with each down bowl:
            overlap = zeros(1, num_bowls_down);
            for k = 1:num_bowls_down

                % up bowl:
                coords_up = objects_bowl_up(end).coordinates_mask;

                % down bowl:
                coords_down = objects_bowl_down(k).coordinates_mask;

                % get overlap:
                overlap(k) = numel(intersect(coords_up, coords_down));

            end

            % get down bowl with max overlap:
            [overlap_max, overlap_max_index] = max(overlap);

            % if max overlap is non-zero:
            if overlap_max ~= 0

                % get up and down bowl numbers:
                bowl_up = list_bowls_up(j);
                bowl_down = objects_bowl_down(overlap_max_index).down_partner;

                % save:
                rows_bowl_up = find(extractfield(objects, 'up_partner') == bowl_up);
                [objects_with_pairs(rows_bowl_up).cluster_3D_num] = deal(bowl_up);
                rows_bowl_down = find(extractfield(objects, 'down_partner') == bowl_down);
                [objects_with_pairs(rows_bowl_down).cluster_3D_num] = deal(bowl_up);

            end
            
        end
        
    end
    
    % get list of all spheres:
    list_spheres = unique(extractfield(objects_with_pairs, 'cluster_3D_num'));
    
    % get number of spheres:
    num_spheres = numel(list_spheres);
    
    % get colors:
    colors = distinguishable_colors(num_spheres, {'k', 'w'});
    
    % set all colors to black:
    [objects_with_pairs.cluster_3D_color] = deal([0 0 0]);
    
    % for each sphere change color:
    for i = 1:num_spheres
       
        % get results for sphere:
        rows_sphere = find(extractfield(objects_with_pairs, 'cluster_3D_num') == list_spheres(i));
        
        % set the color of those rows:
        [objects_with_pairs(rows_sphere).cluster_3D_color] = deal(colors(i, :));
        
    end
    
end