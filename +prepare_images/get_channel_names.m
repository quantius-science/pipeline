function channel_names = get_channel_names(image)

    % image dimensions:
    [num_rows, num_columns, ~, num_channels] = size(image);

    % create array to store max merge (for each channel):
    image_max = zeros(num_rows, num_columns, 1, num_channels, 'like', image);
    
    % for each channel:
    for j = 1:num_channels

        % get max merge:
        image_max(:,:,:,j) = max(image(:,:,:,j), [], 3);

    end

    % create figure:
    f = figure;
    
    % display each max merge as montage:
    montage(image_max);
    
    % ask user for name of each channel:
    prompt = cell(num_channels, 1);
    for j = 1:num_channels
       prompt{j} = sprintf('What is the name of channel #%d?', j); 
    end
    channel_names = inputdlg(prompt);
    
    % close the montage:
    close(f);

end