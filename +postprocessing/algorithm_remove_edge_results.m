function results = algorithm_remove_edge_results(results)

    % add field to store edge status:
    [results.edge_status] = deal('yes');
    
    % determine which objects are on the border:
    
    % for each object:
    for i = 1:size(results, 2)
        
        % get coordinates of object boundary:
        coords = results(i).coordinates;
        
        % convert coordinates to mask:
        mask = poly2mask(coords(:,1), coords(:,2), results(i).height_tile, results(i).width_tile);

        % clear border objects:
        mask_cleared = imclearborder(mask);
        
        % if mask and mask with border cleared are the same:
        if isequal(mask, mask_cleared)
            
            % set edge status to no:
            results(i).edge_status = 'no';
            
        end   
        
    end

    % remove objects that touch the border:
    rows_keep = strcmp(extractfield(results, 'edge_status'), 'no');
    results = results(:, rows_keep);
    
    % remove edge status field:
    results = rmfield(results, 'edge_status');

end