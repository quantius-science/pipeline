function image = add_polygon_to_image(image, coords, color, line_width)

    % format coords:
    coords_formatted = utilities.format_coords_for_plotting(coords);
    
    if numel(coords_formatted) >= 6
    
        % add polygon to image:
        image = insertShape(image, 'Polygon', coords_formatted, 'Color', color, 'LineWidth', line_width);

    elseif numel(coords_formatted) == 4
    
        % add line to image:
        image = insertShape(image, 'Line', coords_formatted, 'Color', color, 'LineWidth', line_width);

    end
    
end