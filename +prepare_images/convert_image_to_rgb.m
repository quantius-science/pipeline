function image_rgb = convert_image_to_rgb(image)

    % image dimensions:
    [num_rows, num_columns, num_slices, num_channels] = size(image);
    
    % create array for rgb version of image (with same class as image):
    image_rgb = zeros(num_rows, num_columns, num_slices, 3, 'like', image);

    % create rgb version of image:
    for j = 1:num_channels

        % set color for each channel:
        color = zeros(1, 3, 'like', image);
        if j == 1
            color(:,3) = 1; % blue               
        elseif j == 2
            color(:,1) = 1; % red                     
        elseif j == 3
            color(:,2) = 1; % green  
        elseif j == 4
            color(:,1:end) = 1; % gray
        end

        % for each rgb channel:
        for k = 1:3

            % add channel to rgb image:
            image_rgb(:,:,:,k) = image_rgb(:,:,:,k) + (image(:,:,:,j) * color(k));

        end

    end

end