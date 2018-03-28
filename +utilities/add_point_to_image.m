function image = add_point_to_image(image, coords, color)
    
    % add point to image:
    image = insertMarker(image, coords(1:2), 'Color', color);

end