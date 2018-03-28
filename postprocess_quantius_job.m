function postprocess_quantius_job

    % load job settings:
    job_settings = load('job_settings.mat');
    job_settings = job_settings.job_settings;
    
    % update the job path:
    job_settings.path_job = pwd;
    
    % get tool used:
    tool_list = {'Crosshairs', 'Line', 'Polyline', 'Polygon', 'Freehand'};
    [job_settings.tool, ~] = listdlg('PromptString', 'Which tool did you use for this job?', ...
        'SelectionMode', 'single', ...
        'ListString', tool_list, 'InitialValue', 5);
    job_settings.tool = tool_list{job_settings.tool};
    
    % print status:
    disp('Formatting the results...');
    
    % format results into struct:
    postprocessing.controller_format_results(job_settings);
    
    % print status:
    disp('Removing annotations that touch the image border...');
    
    % remove objects touching the image border:
    postprocessing.controller_remove_edge_results(job_settings);
    
    % print status:
    disp('Plotting results on the images submitted to Quantius...');
 
    % plot raw results:
    postprocessing.controller_view_results_all(job_settings, 'submitted', 'results_all');
    postprocessing.controller_view_results_individual(job_settings, 'submitted', 'results_individual');
    
    % print status:
    disp('Converting results back to coordinates of the original images...');
    
    % convert formatted results back to original coordiantes:
    postprocessing.controller_convert_results(job_settings);
    
    % print status:
    disp('Clustering the annotations (this may take a while)...');
    
    % cluster replicates:
    postprocessing.controller_cluster_replicates(job_settings);
    
    % print status:
    disp('Plotting clusters on the original images...');
    
    % view clusters:
    postprocessing.controller_view_clusters(job_settings, 'original', 'clusters');

    % print status:
    disp('Averaging each cluster...');
    
    % average replicates:
    postprocessing.controller_average_clusters(job_settings);
    
    % print status:
    disp('Plotting the average on the original images...');
    
    % view averages:
    postprocessing.controller_view_averages(job_settings, 'original', 'averages');

    % if the  annotations are shapes:
    if (strcmp(job_settings.tool, 'Polygon') || strcmp(job_settings.tool, 'Freehand'))
        
        % ask the user if they want to connect the shapes in 3D:
        connection_status = questdlg('Do you want to connect the shapes in 3D?', '3D Connection', 'Yes', 'No', 'No');
        
        % if you want to perform 3D connection:
        if strcmp(connection_status, 'Yes')
        
            % print status:
            disp('Cleaning up the averages (removing extra overlapping results)...');
            
            % clean up averages:
            postprocessing.controller_clean_averages(job_settings);

            % print status:
            disp('Plotting the cleaned averages on the original images...');

            % view clean averages:
            postprocessing.controller_view_averages_clean(job_settings, 'original', 'averages_clean');
            
            % print status:
            disp('Connecting the annotations in 3D...');
            
            % connect the average:
            postprocessing.controller_connect_averages(job_settings);
            
            % print status:
            disp('Plotting the connected averages on the original images...');
            
            % view the connected averages:
            postprocessing.controller_view_connections_2D_slices(job_settings, 'original', 'connections_2D_slices')
            postprocessing.controller_view_connections_3D_slices(job_settings, 'original', 'connections_3D_slices')
            postprocessing.controller_view_connections_3D_volumes(job_settings, 'original', 'connections_3D_volumes')
            
        end

    end
    
    % save job settings:
    save(fullfile(job_settings.path_job, 'job_settings.mat'), 'job_settings');

end