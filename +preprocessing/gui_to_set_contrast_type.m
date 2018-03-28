function varargout = gui_to_set_contrast_type(image_to_crop)

%  create the figure:
f = figure('Visible', 'on', 'Units', 'pixels', 'Position', [0,0,500,550]);

% create axes for images:
handles.image = axes('Units','pixels','Position',[25,25,450,450]);

% set default type crop:
type_contrast = 1;

% create text box to store type crop:
ui_type_contrast = uicontrol(...
    'Units', 'pixels', 'Position', [25, 480, 450, 20], ...
    'Style', 'edit', 'String', num2str(type_contrast), ...
    'Visible', 'on', 'Callback', @callback_type_contrast);

% create header:
ui_text = uicontrol(...
    'Units', 'pixels', 'Position', [25, 510, 450, 40],...
    'Style', 'text', 'String', ['Do you want to adjust the contrast?' newline '0 (no), 1 (yes)'], ...
    'Visible', 'on');

% display the image
imshow(image_to_crop, 'Parent', handles.image); 

% move gui to the center of the screen:
movegui(gcf, 'center');

% make all text larger:
set(findall(gcf,'-property','FontSize'),'FontSize',16);

% make the window visible:
f.Visible = 'on';

% have the function wait:
uiwait(gcf);

% Output the parameters:
varargout{1} = type_contrast;

    % function to update type crop:
    function callback_type_contrast(hObject,eventdata) 
        
        % update crop type:
        type_contrast = str2double(get(hObject, 'string'));

    end
       
end