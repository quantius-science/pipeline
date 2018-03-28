function [image_cropped, slice_start, slice_end] = crop_image_in_z(image)

    % get rgb version of image:
    image_rgb = prepare_images.convert_image_to_rgb(image);

    % perform z-cropping on rgb image:
    imshow3D(image_rgb);
    uiwait;

    % ask user for min and max slices:
    range = inputdlg({'Minimum Slice:', 'Maximum Slice:'}, '');

    % crop the stack in z:
    slice_start = str2double(range{1});
    slice_end = str2double(range{2});
    image_cropped = image(:, :, slice_start:slice_end, :);

end