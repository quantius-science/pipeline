function objects = convert_coords_pixel_to_um(objects, field, scale_x, scale_y, scale_z)

    % add field to store converted coordinates:
    [objects(1:end).coordinates_um] = deal([]);

    % for each object:
    for i = 1:numel(objects)
       
        objects(i).coordinates_um(:,1) = objects(i).(field)(:,1) * scale_x;
        objects(i).coordinates_um(:,2) = objects(i).(field)(:,2) * scale_y;
        objects(i).coordinates_um(:,3) = objects(i).(field)(:,3) * scale_z;
        
    end
    
end