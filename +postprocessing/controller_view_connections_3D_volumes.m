function controller_view_connections_3D_volumes(job_settings, input_folder_name, output_folder_name)
    
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

        % get number of clusters:
        num_clusters = numel(unique(extractfield(objects_stack, 'object_connected_num')));

        % create figure:
        figure;

        % for each 3D cluster:
        for j = 1:num_clusters

            % get relevant results:
            objects_cluster = utilities.get_structure_results_matching_number(objects_stack, 'object_connected_num', j);

            % get number of objects in the cluster:
            num_slices = numel(objects_cluster);

            if num_slices >= 2

                % get all points that make up the cluster:
                points = vertcat(objects_cluster.coordinates);

                % plot 3D shape:
                K = convhulln(points);

                % get color of cluster:
                color = objects_cluster(1).object_connected_color;

                % plot:
                trisurf(K, points(:,1), points(:, 2), points(:, 3), 'FaceColor', color, 'EdgeColor', 'none');
                
                hold on;

            end

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