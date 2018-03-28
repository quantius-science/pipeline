function objects = erode_objects(objects)

    % create array to store eroded coordiantes:
    [objects(1:end).coordinates_erode] = deal([]);

    % for each object:
    for i = 1:numel(objects)
        
        % create mask:
        mask = zeros(objects(i).height_original, objects(i).width_original);
        
        % get coordinates:
        coords = objects(i).coordinates;
        
        % plot object:
        for j = 1:size(coords, 1)
        
            mask(coords(j,2), coords(j,1)) = 1;
        
        end
        
        % fill object:
        mask = imfill(mask, 'holes');
        
        % erode object:
        mask_eroded = imerode(mask, strel('rectangle', [1 10]));
        
        % get bondary of eroded object:
        boundary = bwboundaries(mask_eroded);
        
        % save new coordinates:
        objects(i).coordinates_erode = [boundary{1,1}(:,2) boundary{1,1}(:,1)];
        
    end

end