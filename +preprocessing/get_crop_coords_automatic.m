function crop_coords = get_crop_coords_automatic(image_max, crop_coords)    

    % calculate threshold level on the max merge using Otsu's:
    threshold = graythresh(image_max);

    % threshold the stack:
    image_threshold = im2double(image_max) > threshold;

    % dilate the image:
    image_threshold = imdilate(image_threshold, strel('disk', 40, 8));

    % get area and bounding box of threshold:
    area = regionprops(image_threshold, 'Area');
    bounding_box = regionprops(image_threshold, 'BoundingBox');

    % determine object with the largest area:
    [~, index] = max([area.Area]);

    % get bounding box coordinates: 
    bounding_box = bounding_box(index).BoundingBox;

    % dilate bounding box (decrease starting postion and increase width, height):
    dilate_factor = 50; % in number of pixels
    crop_coords.x_start = max(floor(bounding_box(1)) - dilate_factor, 1);
    crop_coords.y_start = max(floor(bounding_box(2)) - dilate_factor, 1);
    crop_coords.x_end = min(crop_coords.x_start + ceil(bounding_box(3)) + 2*dilate_factor, crop_coords.original_width);
    crop_coords.y_end = min(crop_coords.y_start + ceil(bounding_box(4)) + 2*dilate_factor, crop_coords.original_height);

end