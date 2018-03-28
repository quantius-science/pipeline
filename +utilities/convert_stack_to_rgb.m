function rgb = convert_stack_to_rgb(stack, color)
    
    % re-arrange so color is 3rd dimension and slice is 4th dimension:
    stack = permute(stack, [1 2 4 3]);
    
    % add rgb channels:
    stack = repmat(stack, 1, 1, 3, 1);
    
    % create array to store rgb image:
    rgb = zeros(size(stack), 'like', stack);
    
    % for each rgb channel:
    for i = 1:3
        
        rgb(:,:,i,:) = rgb(:,:,i,:) + stack(:,:,i,:) * color(i);
        
    end

end