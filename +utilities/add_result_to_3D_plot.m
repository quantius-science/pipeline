function figure_handle = add_result_to_3D_plot(coords, color)

    % convert to um:
    pixel_size = 0.216; %um
    x = pixel_size * coords(:,1);
    y = pixel_size * coords(:,2);
    z = coords(:,3);
            
    % get number of slices in the object:
    num_slices = numel(unique(coords(:,3)));

    % if the object is more than one slice:
    if num_slices > 1

        % get convex hull:
        hull = convhull(x, y, z, 'Simplify', true);

        % plot convex hull:
        object_graphics = patch('Faces', hull, 'Vertices', [x, y, z]);
        object_graphics.FaceColor = color;
        object_graphics.EdgeColor = 'none';

    % if the object is only one slice:
    elseif num_slices == 1

        % plot plane:
        object_graphics = fill3(x, y, z, color, 'EdgeColor', 'none');

    end

    % add object to existing figure:
    figure_handle = ancestor(object_graphics, 'figure');

end