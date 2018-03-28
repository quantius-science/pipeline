function image = add_result_to_image(tool, image, coordinates, color, varargin)

    % if a line width is supplied:
    if nargin == 5
       
        % set line width:
        line_width = varargin{1};
       
    % otherwise:
    else
        
        % set line width to default (1):
        line_width = 1;
        
    end

    % format color for image's bit depth:
    if isa(color, 'char') == 0
        if isa(image, 'uint8')
            color = color * (2^8);
        elseif isa(image, 'uint16')
            color = color * (2^16);
        elseif isa(image, 'uint32')
            color = color * (2^32);
        elseif isa(image, 'uint64')
            color = color * (2^64);
        end
    end

    % if tool was crosshairs
    if strcmp(tool, 'Crosshairs')
        
        % add point:
        image = utilities.add_point_to_image(image, coordinates, color);
        
    % if tool was line or polyline:
    elseif strcmp(tool, 'Line') || strcmp(tool, 'Polyline')
        
        % add line:
        image = utilities.add_line_to_image(image, coordinates, color, line_width);
        
    % if tool was polygon or freehand:
    elseif strcmp(tool, 'Polygon') || strcmp(tool, 'Freehand')
       
        % add polygon:
        image = utilities.add_polygon_to_image(image, coordinates, color, line_width);
        
    end

end