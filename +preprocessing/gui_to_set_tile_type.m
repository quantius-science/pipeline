function varargout = gui_to_set_tile_type(image_to_tile)

%  create the figure:
f = figure('Visible', 'on', 'Units', 'pixels', 'Position', [0,0,500,550]);

% create axes for images:
handles.image = axes('Units','pixels','Position',[25,25,450,450]);

% set default type tile:
type_tile = 0;

% create text box to store type tile:
ui_type_tile = uicontrol(...
    'Units', 'pixels', 'Position', [25, 480, 450, 20], ...
    'Style', 'edit', 'String', num2str(type_tile), ...
    'Visible', 'on', 'Callback', @callback_type_tile);

% create header:
ui_text = uicontrol(...
    'Units', 'pixels', 'Position', [25, 510, 450, 40],...
    'Style', 'text', 'String', ['What type of tiling do you want to do?' newline '0 (none), 1 (manual)'], ...
    'Visible', 'on');

% display the image
imshow(imadjust(image_to_tile), 'Parent', handles.image); 

% move gui to the center of the screen:
movegui(gcf, 'center');

% make all text larger:
set(findall(gcf,'-property','FontSize'),'FontSize',16);

% make the window visible:
f.Visible = 'on';

% have the function wait:
uiwait(gcf);

% Output the parameters:
varargout{1} = type_tile;

    % function to update type tile:
    function callback_type_tile(hObject,eventdata) 
        
        % update tile type:
        type_tile = str2double(get(hObject, 'string'));

    end
       
end