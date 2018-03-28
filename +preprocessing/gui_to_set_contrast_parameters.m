function varargout = gui_to_set_contrast_parameters(image_stack)

%  create to figure:
f = figure('Visible', 'on', 'Units', 'pixels', 'Position', [0,0,1000,500]);

% create axes for images:
handles.image{1} = axes('Units','pixels','Position',[25,25,300,400]);
handles.image{2} = axes('Units','pixels','Position',[350,25,300,400]);
handles.image{3} = axes('Units','pixels','Position',[675,25,300,400]);

% create button for viewing more random images:
ui_slice_random = uicontrol('Style', 'pushbutton', ...
             'String', 'Show More Images', ...
             'Units', 'pixels', 'Position', [25, 400, 300, 50],...
             'Callback', @callback_random_slice);
         
% create panel for imadjust:
ui_imadjust = uipanel('Title', 'imadjust', ...
    'Units', 'pixels', 'Position', [350, 400, 300, 75]);
    
% create button for imadjust filter:  
ui_imadjust_button_group = uibuttongroup(ui_imadjust, ...
    'Visible', 'on', 'BorderType', 'none', ...
    'Units', 'pixels', 'Position', [5, 5, 60, 50]);
ui_imadjust_off = uicontrol(ui_imadjust_button_group, ...
    'Units', 'pixels', 'Position', [0, 25, 50, 25], ...
    'Style', 'radiobutton', 'String', 'off', ...
    'Visible', 'on', 'Callback', @callback_imadjust_off);
ui_imadjust_on = uicontrol(ui_imadjust_button_group, ...
    'Units', 'pixels', 'Position', [0, 0, 50, 25], ...
    'Style', 'radiobutton', 'String', 'on', ...
    'Visible', 'on', 'Callback', @callback_imadjust_on);

% create text boxes for imadjust filter:
ui_imadjust_min = uicontrol(ui_imadjust, ...
    'Units', 'pixels', 'Position', [70, 5, 50, 20], ...
    'Style', 'edit', 'String', '1', ...
    'Visible', 'on', 'Callback', @callback_imadjust_min);
ui_imadjust_min_text = uicontrol(ui_imadjust, ...
    'Units', 'pixels', 'Position', [70, 30, 70, 25],...
    'Style', 'text', 'String', 'min', ...
    'Visible', 'on');
ui_imadjust_max = uicontrol(ui_imadjust, ...
    'Units', 'pixels', 'Position', [140, 5, 50, 20], ...
    'Style', 'edit', 'String', '99', ...
    'Visible', 'on', 'Callback', @callback_imadjust_max);
ui_imadjust_max_text = uicontrol(ui_imadjust, ...
    'Units', 'pixels', 'Position', [140, 30, 70, 25],...
    'Style', 'text', 'String', 'max', ...
    'Visible', 'on');
ui_imadjust_gamma = uicontrol(ui_imadjust, ...
    'Units', 'pixels', 'Position', [210, 5, 50, 20], ...
    'Style', 'edit', 'String', '1', ...
    'Visible', 'on', 'Callback', @callback_imadjust_gamma);
ui_imadjust_gamma_text = uicontrol(ui_imadjust, ...
    'Units', 'pixels', 'Position', [210, 30, 70, 25],...
    'Style', 'text', 'String', 'gamma', ...
    'Visible', 'on');

% align:
align([ui_imadjust_min ui_imadjust_min_text], 'Center', 'none');
align([ui_imadjust_max ui_imadjust_max_text], 'Center', 'none');
align([ui_imadjust_gamma ui_imadjust_gamma_text], 'Center', 'none');

% create panel for imsharpen:
ui_imsharpen = uipanel('Title', 'imsharpen', ...
    'Units', 'pixels', 'Position', [675, 400, 300, 75]);

% create button for imsharpen filter:  
ui_imsharpen_button_group = uibuttongroup(ui_imsharpen, ...
    'Visible', 'on', 'BorderType', 'none', ...
    'Units', 'pixels', 'Position', [5, 5, 60, 50]);
ui_imsharpen_off = uicontrol(ui_imsharpen_button_group, ...
    'Units', 'pixels', 'Position', [0, 25, 50, 25], ...
    'Style', 'radiobutton', 'String', 'off', ...
    'Visible', 'on', 'Callback', @callback_imsharpen_off);
ui_imsharpen_on = uicontrol(ui_imsharpen_button_group, ...
    'Units', 'pixels', 'Position', [0, 0, 50, 25], ...
    'Style', 'radiobutton', 'String', 'on', ...
    'Visible', 'on', 'Callback', @callback_imsharpen_on);

% create text boxes for imsharpen filter:
ui_imsharpen_radius = uicontrol(ui_imsharpen, ...
    'Units', 'pixels', 'Position', [70, 5, 50, 20], ...
    'Style', 'edit', 'String', '1', ...
    'Visible', 'on', 'Callback', @callback_imsharpen_radius);
ui_imsharpen_radius_text = uicontrol(ui_imsharpen, ...
    'Units', 'pixels', 'Position', [70, 30, 70, 25],...
    'Style', 'text', 'String', 'radius', ...
    'Visible', 'on');
ui_imsharpen_amount = uicontrol(ui_imsharpen, ...
    'Units', 'pixels', 'Position', [140, 5, 50, 20], ...
    'Style', 'edit', 'String', '1.2', ...
    'Visible', 'on', 'Callback', @callback_imsharpen_amount);
ui_imsharpen_amount_text = uicontrol(ui_imsharpen, ...
    'Units', 'pixels', 'Position', [140, 30, 70, 25],...
    'Style', 'text', 'String', 'amount', ...
    'Visible', 'on');
ui_imsharpen_threshold = uicontrol(ui_imsharpen, ...
    'Units', 'pixels', 'Position', [210, 5, 50, 20], ...
    'Style', 'edit', 'String', '1', ...
    'Visible', 'on', 'Callback', @callback_imsharpen_threshold);
ui_imsharpen_threshold_text = uicontrol(ui_imsharpen, ...
    'Units', 'pixels', 'Position', [210, 30, 70, 25],...
    'Style', 'text', 'String', 'threshold', ...
    'Visible', 'on');

% align:
align([ui_imsharpen_radius ui_imsharpen_radius_text], 'Center', 'none');
align([ui_imsharpen_amount ui_imsharpen_amount_text], 'Center', 'none');
align([ui_imsharpen_threshold ui_imsharpen_threshold_text], 'Center', 'none');

% Set number of images to display at once:
num_displays = 3;

% Get indices of images to display:
current_indices = get_random_indices(image_stack, num_displays);

% Load the current images:
current_images = load_images(image_stack, current_indices);

% set default parameters:
parameters.imadjust = 0;
parameters.imsharpen = 0;
parameters.radius = 1;
parameters.amount = 1.2;
parameters.threshold = 0;
parameters.min = 1;
parameters.max = 99;
parameters.gamma = 1;

% View the current images:
view_images(current_images, handles, parameters);

% make all text larger:
set(findall(gcf,'-property','FontSize'),'FontSize',16);

% Make the window visible:
f.Visible = 'on';

% move gui to the center of the screen:
movegui(gcf, 'center');

% Have the function wait:
uiwait(gcf);

% Output the parameters:
varargout{1} = parameters;

    % function to get random indices for images:
    function indices = get_random_indices(image_stack, num_images_to_display)
        
        % get total number of images in the folder:
        num_images_total = size(image_stack, 3);
        
        % get indices:
        indices = randperm(num_images_total, num_images_to_display);
        
    end

    % function to load images:
    function images = load_images(image_stack, index)

        % get number of images:
        num_images_to_get = numel(index);

        % create cell to store images:
        images = cell(1,num_images_to_get);

        for j = 1:num_images_to_get

            % get an index:
            index_to_use = index(j);

            % load the images:
            images{j} = image_stack(:,:,index_to_use);

        end

    end

    % function to view images:
    function view_images(images, handles, parameters)
       
        % get adjusted images:
        images_adjusted = adjust_images(images, parameters);
        
        % get number of images:
        num_images_to_view = size(images_adjusted, 2);
        
        for k = 1:num_images_to_view
           
            % display the image
           imshow(images_adjusted{k}, 'Parent', handles.image{k}); 
            
        end
        
    end

    % function to create adjusted images:
    function images_adjusted = adjust_images(images, parameters)
       
        % create cell to store adjusted images:
        images_adjusted = images;
        
        % apply sharpening:
        if parameters.imsharpen == 1
            images_adjusted = apply_imsharpen(images_adjusted);
        end
        
        % apply imadjust:
        if parameters.imadjust == 1
            images_adjusted = apply_imadjust(images_adjusted);
        end
        
    end

    % function to apply imadjust:
    function images_imadjust = apply_imadjust(images)
        
        % create cell to store images after imadjust:
        images_imadjust = images;
        
        % apply imadjust:
        for i = 1:num_displays
           images_imadjust{i} = imadjust(images_imadjust{i}, ...
               [parameters.min/100, parameters.max/100], [0 1], parameters.gamma); 
        end
          
    end 

    % function to apply imshapren:
    function images_imsharpen = apply_imsharpen(images)
        
        % create cell to store images after imadjust:
        images_imsharpen = images;
        
        % apply imadjust:
        for i = 1:num_displays
           images_imsharpen{i} = imsharpen(images_imsharpen{i}, ...
               'Radius', parameters.radius, ...
               'Amount', parameters.amount, ...
               'Threshold', parameters.threshold); 
        end
          
    end 

    % function for random slice button:
    function callback_random_slice(hObject, eventdata) 
    
        % Get indices of images to display:
        current_indices = get_random_indices(image_stack, num_displays);

        % Load the current images:
        current_images = load_images(image_stack, current_indices);

        % View the current images:
        view_images(current_images, handles, parameters);
        
    end

    % function to toggle imadjust button on:
    function callback_imadjust_on(hObject,eventdata) 
        
        % update the parameters:
        parameters.imadjust = 1;
        
        % update the images displayed:
        view_images(current_images, handles, parameters);

    end

    % function to toggle imadjust button off:
    function callback_imadjust_off(hObject,eventdata) 
        
        % update the parameters:
        parameters.imadjust = 0;
        
        % update the images displayed:
        view_images(current_images, handles, parameters);

    end

    % function to toggle imadjust min:
    function callback_imadjust_min(hObject,eventdata) 
        
        % update the parameters:
        parameters.min = str2double(get(hObject, 'string'));
        
        % update the images displayed:
        view_images(current_images, handles, parameters);

    end

    % function to toggle imadjust max:
    function callback_imadjust_max(hObject,eventdata) 
        
        % update the parameters:
        parameters.max = str2double(get(hObject, 'string'));
        
        % update the images displayed:
        view_images(current_images, handles, parameters);

    end

    % function to toggle imadjust gamma:
    function callback_imadjust_gamma(hObject,eventdata) 
        
        % update the parameters:
        parameters.gamma = str2double(get(hObject, 'string'));
        
        % update the images displayed:
        view_images(current_images, handles, parameters);

    end

    % function to toggle imsharpen button on:
    function callback_imsharpen_on(hObject,eventdata) 
        
        % update the parameters:
        parameters.imsharpen = 1;
        
        % update the images displayed:
        view_images(current_images, handles, parameters);

    end

    % function to toggle imsharpen button off:
    function callback_imsharpen_off(hObject,eventdata) 
        
        % update the parameters:
        parameters.imsharpen = 0;
        
        % update the images displayed:
        view_images(current_images, handles, parameters);

    end

    % function to toggle imadjust radius:
    function callback_imsharpen_radius(hObject,eventdata) 
        
        % update the parameters:
        parameters.radius = str2double(get(hObject, 'string'));
        
        % update the images displayed:
        view_images(current_images, handles, parameters);

    end

    % function to toggle imadjust amount:
    function callback_imsharpen_amount(hObject,eventdata) 
        
        % update the parameters:
        parameters.amount = str2double(get(hObject, 'string'));
        
        % update the images displayed:
        view_images(current_images, handles, parameters);

    end

    % function to toggle imadjust threshold:
    function callback_imsharpen_threshold(hObject,eventdata) 
        
        % update the parameters:
        parameters.threshold = str2double(get(hObject, 'string'));
        
        % update the images displayed:
        view_images(current_images, handles, parameters);

    end

end