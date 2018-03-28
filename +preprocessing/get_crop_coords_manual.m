function crop_coords = get_crop_coords_manual(image_max, crop_coords)    
        
    % display image:
    imshow(imadjust(image_max));

    f.Visible = 'on';
            
    % use a GUI to get coordinates for cropping the image:
    mask = imfreehand;
    mask = mask.createMask;

    % close figure;
    close all;
            
    % dilate the mask:
    mask = imdilate(mask, strel('disk', 10, 8));
            
    % get bounding box:
    bounding_box = regionprops(mask, 'BoundingBox');
    bounding_box = bounding_box.BoundingBox;
            
    % get bounding box coordinates:
    crop_coords.x_start = round(bounding_box(1));
    crop_coords.x_end = round(crop_coords.x_start + bounding_box(3));
    crop_coords.y_start = round(bounding_box(2));
    crop_coords.y_end = round(crop_coords.y_start + bounding_box(4));
            
end