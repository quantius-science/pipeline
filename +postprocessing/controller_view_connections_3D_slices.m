function controller_view_connections_3D_slices(job_settings, input_folder_name, output_folder_name)
    
    % get step number:
    step = utilities.get_folder_number(job_settings.path_job);
    
    % get paths:
    paths = utilities.get_all_paths(job_settings.path_job, input_folder_name, output_folder_name, step);      

    % get objects:
    objects = load(fullfile(job_settings.path_job, 'objects_4_connected.mat'));
    objects = objects.objects;

    % turn off figure visability:
    set(0,'DefaultFigureVisible','off');
    
    % get list of image stacks:
    list_stacks = unique(extractfield(objects, 'num_stack'));

    % get number of stacks:
    num_stacks = numel(list_stacks);

    % for each stack:
    for i = 1:num_stacks

        % get objects for the stack:
        objects_stack = utilities.get_structure_results_matching_number(objects, 'num_stack', list_stacks(i));
        
        % get name of image to analyze:
        image_stack_name = objects_stack(1).image_name_renamed;

        % get number of objects:
        num_objects_stack = numel(objects_stack);

        % create figure:
        figure;

        % for each object:
        for j = 1:num_objects_stack

            % get points:
            points = objects_stack(j).coordinates;

            X = points(:,1);
            Y = points(:,2); 

            Z = zeros(size(X, 1),1);
            Z(:) = objects_stack(j).num_slice;

            color = objects_stack(j).object_connected_color;

            fill3(X, Y, Z, color);
            hold on;

        end

        % set options:
        OptionZ.FrameRate = 15;
        OptionZ.Duration = 10;
        OptionZ.Periodic = true; 

        % save:
        cd(paths{3});
        CaptureFigVid([-20,10;-110,10;-190,80;-290,10;-380,10], image_stack_name, OptionZ);
        cd(paths{1});
         
    end

    % turn on figure visability:
    set(0,'DefaultFigureVisible','on');
    
end