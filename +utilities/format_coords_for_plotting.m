function coords_formatted = format_coords_for_plotting(coords)

    % get number of coordinates:
    num_coords = size(coords, 1);
    
    % create array to store formatted coordinates:
    coords_formatted = zeros(1, 2 * num_coords);
    
    % format coordinates (for insertShape):
    for i = 1:num_coords
        
        % format x coord:
        coords_formatted(1, 2 * i - 1) = coords(i,1);
        
        % format y coord:
        coords_formatted(1, 2 * i) = coords(i,2);
        
    end
    
end