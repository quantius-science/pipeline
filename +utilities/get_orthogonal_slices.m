function image_ortho = get_orthogonal_slices(image, plane)

    % define coordinate system using normal slicing
    % define x-axis as moving left to right
    % define y-axis as moving up to down 
    % define z-axis as moving from bottom slice to top slice
    
    % if you want the xz plane:
    if strcmp(plane, 'xz')
       
        % get orthogonal image:
        image_ortho = permute(image, [2 3 1]);
        
        % rotate image 90 degrees counterclockwise:
        image_ortho = rot90(image_ortho);
        
    % if you want the yz plane:
    elseif strcmp(plane, 'yz')
        
        % get orthogonal image:
        image_ortho = permute(image, [1 3 2]);
        
    end

end