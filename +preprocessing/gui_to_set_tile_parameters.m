function varargout = gui_to_set_tile_parameters(image_to_tile, tile_coords)

    %  create the figure:
    f = figure('Visible', 'on', 'Units', 'pixels', 'Position', [0,0,500,550]);
    
    % create axes for images:
    handles.image = axes('Units','pixels','Position',[25,25,450,450]);
    
    % create text boxes to store parameters:
    ui_num_tiles_x = uicontrol(...
        'Units', 'pixels', 'Position', [10, 490, 50, 20], ...
        'Style', 'edit', 'String', num2str(tile_coords.num_tiles_x), ...
        'Visible', 'on', 'Callback', @callback_num_tiles_x);
    ui_num_tiles_y = uicontrol(...
        'Units', 'pixels', 'Position', [120, 490, 50, 20], ...
        'Style', 'edit', 'String', num2str(tile_coords.num_tiles_y), ...
        'Visible', 'on', 'Callback', @callback_num_tiles_y);
    ui_overlap_x = uicontrol(...
        'Units', 'pixels', 'Position', [230, 490, 50, 20], ...
        'Style', 'edit', 'String', num2str(tile_coords.overlap_x), ...
        'Visible', 'on', 'Callback', @callback_overlap_x);
    ui_overlap_y = uicontrol(...
        'Units', 'pixels', 'Position', [340, 490, 50, 20], ...
        'Style', 'edit', 'String', num2str(tile_coords.overlap_y), ...
        'Visible', 'on', 'Callback', @callback_overlap_y);
    
    % create headers:
    ui_text_num_tiles_x = uicontrol(...
        'Units', 'pixels', 'Position', [10, 510, 140, 30],...
        'Style', 'text', 'String', '# col', ...
        'Visible', 'on', 'HorizontalAlignment', 'center');
    ui_text_num_tiles_y = uicontrol(...
        'Units', 'pixels', 'Position', [120, 510, 140, 30],...
        'Style', 'text', 'String', '# row', ...
        'Visible', 'on', 'HorizontalAlignment', 'center');
    ui_text_overlap_x = uicontrol(...
        'Units', 'pixels', 'Position', [230, 510, 140, 30],...
        'Style', 'text', 'String', 'col overlap', ...
        'Visible', 'on', 'HorizontalAlignment', 'center');
    ui_text_overlap_y = uicontrol(...
        'Units', 'pixels', 'Position', [340, 510, 140, 30],...
        'Style', 'text', 'String', 'row overlap', ...
        'Visible', 'on', 'HorizontalAlignment', 'center');

    % align:
    align([ui_num_tiles_x ui_text_num_tiles_x], 'Center', 'none');
    align([ui_num_tiles_y ui_text_num_tiles_y], 'Center', 'none');
    align([ui_overlap_x ui_text_overlap_x], 'Center', 'none');
    align([ui_overlap_y ui_text_overlap_y], 'Center', 'none');

    
    % view the current image with tiles:
    tile_coords = view_image(image_to_tile, handles, tile_coords);
    
    % make all text larger:
    set(findall(gcf,'-property','FontSize'),'FontSize',16);
    
    % make the window visible:
    f.Visible = 'on';
    
    % move gui to the center of the screen:
    movegui(gcf, 'center');

    % have the function wait:
    uiwait(gcf);

    % output the new tile coords:
    varargout{1} = tile_coords;
    
    % function to view current image with tiles:
    function tile_coords = view_image(image_to_show, handles, tile_coords)
       
        % display the image:
        imshow(imadjust(image_to_show), 'Parent', handles.image);
        
        % update tile coords:
        tile_coords = update_tile_coords(tile_coords);
        
        % get vertical line coordinates:
        [lines_vert_start_x, lines_vert_start_y] = get_vertical_lines(tile_coords.tile_start_x, tile_coords.crop_height);
        [lines_vert_end_x, lines_vert_end_y] = get_vertical_lines(tile_coords.tile_end_x, tile_coords.crop_height);
        
        % get horizontal line coordiantes:
        [lines_horz_start_x, lines_horz_start_y] = get_horizontal_lines(tile_coords.tile_start_y, tile_coords.crop_width);
        [lines_horz_end_x, lines_horz_end_y] = get_horizontal_lines(tile_coords.tile_end_y, tile_coords.crop_width);
        
        % plot lines:
        plot_lines(lines_vert_start_x, lines_vert_start_y);
        plot_lines(lines_vert_end_x, lines_vert_end_y);
        plot_lines(lines_horz_start_x, lines_horz_start_y);
        plot_lines(lines_horz_end_x, lines_horz_end_y);
        
    end
    
    % function to update tile coordinates:
    function tile_coords = update_tile_coords(tile_coords)
        
        % determine tile size:
        tile_width = get_tile_size(tile_coords.crop_width, tile_coords.num_tiles_x, tile_coords.overlap_x);
        tile_height = get_tile_size(tile_coords.crop_height, tile_coords.num_tiles_y, tile_coords.overlap_y);

        % convert overlap to pixels:
        tile_coords.overlap_x_pixels = convert_overlap_to_pixels(tile_coords.overlap_x, tile_width);
        tile_coords.overlap_y_pixels = convert_overlap_to_pixels(tile_coords.overlap_y, tile_height);
        
        % get tile start and end positions:
        [tile_coords.tile_start_x, tile_coords.tile_end_x] = get_tile_start_end(tile_width, tile_coords.overlap_x_pixels, tile_coords.num_tiles_x, tile_coords.crop_width);
        [tile_coords.tile_start_y, tile_coords.tile_end_y] = get_tile_start_end(tile_height, tile_coords.overlap_y_pixels, tile_coords.num_tiles_y, tile_coords.crop_height);
        
    end

    % function to get tile size:
    function tile_size = get_tile_size(original_size, num_tiles, overlap)
        
%         tile_size = ceil((original_size)/(num_tiles + overlap - overlap*num_tiles));

        % calculate necessary tile size from num tiles and overlap:
        tile_size = (original_size)/(num_tiles - ((num_tiles - 1)*(overlap)));
        
        % round up to nearest integer:
        tile_size = ceil(tile_size);
                
    end

    % function to convert overlap to pixels:
    function overlap_new = convert_overlap_to_pixels(overlap, tile_size)
       
%         overlap_new = floor(overlap * tile_size); 

        % convert overlap to pixels (using new tile size):
        overlap_new = overlap * tile_size; 
        
        % round up to nearest integer:
        overlap_new = ceil(overlap_new);
        
    end
    
    % function to determine tile start and end positions:
    function [tile_start, tile_end] = get_tile_start_end(tile_size, overlap_pixels, num_tiles, image_size)
        
%         tile_start = 1:(tile_size - overlap_pixels):(((num_tiles - 1)*(tile_size))-((num_tiles - 2)*(overlap_pixels)));
%         tile_end = tile_start + tile_size - 1;
%         tile_end(num_tiles) = image_size;
        
        % create arrays to store tile start and end coordinates:
        tile_start = zeros(num_tiles, 1);
        tile_end = zeros(num_tiles, 1);
        
        % get size of non-overlapping tile:
        tile_size_no_overlap = tile_size - overlap_pixels;
        
        % for each tile:
        for i = 1:num_tiles
           
            % get starting index of tile:
            tile_start(i) = (tile_size_no_overlap) * i - (tile_size_no_overlap - 1);
            
            % get ending index of tile:
            tile_end(i) = tile_start(i) + tile_size - 1;
            
        end
        
        % set end point of last tile to image size: 
        % (in case tiles don't fit evenly in image)
        tile_end(end) = image_size;
        
    end

    % function to get vertical lines:
    function [lines_x, lines_y] = get_vertical_lines(x_locations, image_height)
        
        % get number of x lines:
        num_lines = numel(x_locations);
        
        % create cell to store lines:
        lines_x = cell(num_lines, 1);
        lines_y = cell(num_lines, 1);
        
        % for each line:
        for k = 1:num_lines
            
            % create y coords:
            lines_y{k} = 1:image_height;
            
            % create x coords:
            lines_x{k} = lines_y{k};
            lines_x{k}(:) = deal(x_locations(k));
            
        end
    
    end

    % function to get horizontal lines:
    function [lines_x, lines_y] = get_horizontal_lines(y_locations, image_width)
        
        % get number of y lines:
        num_lines = numel(y_locations);
        
        % create cell to store lines:
        lines_x = cell(num_lines, 1);
        lines_y = cell(num_lines, 1);
        
        % for each line:
        for k = 1:num_lines
            
            % create x coords:
            lines_x{k} = 1:image_width;
            
            % create y coords:
            lines_y{k} = lines_x{k};
            lines_y{k}(:) = deal(y_locations(k));
            
        end
    
    end
    
    % function to plot lines:
    function plot_lines(x, y)
        
        hold on
        
        % get number of lines:
        num_lines = size(x, 1);
        
        % for each line:
        for k = 1:num_lines
           
            plot(x{k}, y{k}, '-y');
            
        end
        
        hold off
        
    end

    % function to update num tiles x:
    function callback_num_tiles_x(hObject,eventdata) 
        
        % update tile type:
        tile_coords.num_tiles_x = str2double(get(hObject, 'string'));
        
        % update the images displayed:
        tile_coords = view_image(image_to_tile, handles, tile_coords);

    end

    % function to update num tiles y:
    function callback_num_tiles_y(hObject,eventdata) 
        
        % update tile type:
        tile_coords.num_tiles_y = str2double(get(hObject, 'string'));
        
        % update the images displayed:
        tile_coords = view_image(image_to_tile, handles, tile_coords);

    end

    % function to update overlap x:
    function callback_overlap_x(hObject,eventdata) 
        
        % update tile type:
        tile_coords.overlap_x = str2double(get(hObject, 'string'));
        
        % update the images displayed:
        tile_coords = view_image(image_to_tile, handles, tile_coords);

    end

    % function to update overlap y:
    function callback_overlap_y(hObject,eventdata) 
        
        % update tile type:
        tile_coords.overlap_y = str2double(get(hObject, 'string'));
        
        % update the images displayed:
        tile_coords = view_image(image_to_tile, handles, tile_coords);

    end

end