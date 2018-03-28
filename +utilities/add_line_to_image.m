function image = add_line_to_image(image, coords, color, line_width)

    % format coords:
    coords_formatted = utilities.format_coords_for_plotting(coords);

    % add line to image:
    image = insertShape(image, 'Line', coords_formatted, 'Color', color, 'LineWidth', line_width);

end