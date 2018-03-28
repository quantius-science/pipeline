function varargout = gui_to_set_stretch_factor(image)

%  create the figure:
f = figure('Visible', 'on', 'Units', 'pixels', 'Position', [0,0,500,550]);

% create axes for images:
handles.image = axes('Units','pixels','Position',[25,25,450,450]);

% set default type tile:
factor = 1;

% create text box to store type tile:
ui_factor = uicontrol(...
    'Units', 'pixels', 'Position', [25, 480, 450, 20], ...
    'Style', 'edit', 'String', num2str(factor), ...
    'Visible', 'on', 'Callback', @callback_factor);

% create header:
ui_text = uicontrol(...
    'Units', 'pixels', 'Position', [25, 510, 450, 40],...
    'Style', 'text', 'String', 'What stretch factor do you want to use?', ...
    'Visible', 'on');

% display the image:
view_image;

% move gui to the center of the screen:
movegui(gcf, 'center');

% make all text larger:
set(findall(gcf,'-property','FontSize'),'FontSize',16);

% make the window visible:
f.Visible = 'on';

% have the function wait:
uiwait(gcf);

% Output the parameters:
varargout{1} = factor;

    % function to show image:
    function view_image
        
        % get image size:
        [num_rows, num_columns] = size(image);

        % resize slices:
        image_resized = imresize(image, ...
            [(factor*num_rows) num_columns]);
        
        % display image:
        imshow(imadjust(image_resized), 'Parent', handles.image); 

    end

    % callback to update type tile:
    function callback_factor(hObject,eventdata) 
        
        % update tile type:
        factor = str2double(get(hObject, 'string'));
        
        % display the image:
        view_image;

    end
       
end