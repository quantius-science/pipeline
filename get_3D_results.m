function get_3D_results
   
    % get 3D connection job:
    path_conn = uigetdir;
    
    % load job settings:
    job_settings_seg = load(fullfile(pwd, 'job_settings.mat'));
    job_settings_seg = job_settings_seg.job_settings;
    job_settings_conn = load(fullfile(path_conn, 'job_settings.mat'));
    job_settings_conn = job_settings_conn.job_settings;
    
    % update the job path:
    job_settings_seg.path_job = pwd;
    job_settings_conn.path_job = path_conn;
    
    % load the objects:
    objects_seg = load(fullfile(job_settings_seg.path_job, 'objects_3_averaged_cleaned.mat')); 
%     objects_seg = load(fullfile(job_settings_seg.path_job, 'objects_1_clustered.mat')); 
    objects_seg = objects_seg.objects;
    objects_conn = load(fullfile(job_settings_conn.path_job, 'objects_3_averaged_cleaned.mat'));
%     objects_conn = load(fullfile(job_settings_conn.path_job, 'objects_1_clustered.mat')); 
    objects_conn = objects_conn.objects;
    
%     % erode conn objects:
%     objects_conn = get_3D_results.erode_objects(objects_conn);
    
    % convert conn to original coordinate system:
    objects_conn = get_3D_results.convert_coords_ortho_to_orig(objects_conn, job_settings_conn);
    
    % convert coords from pixel to um:
    objects_seg = get_3D_results.convert_coords_pixel_to_um(objects_seg, 'coordinates', 0.3575, 0.3575, 1.5000);
    objects_conn = get_3D_results.convert_coords_pixel_to_um(objects_conn, 'coordinates_converted', 0.3575, 0.3575, 1.5000);

    % make 3D connection:
    objects_seg = get_3D_results.connection_make(objects_seg, objects_conn);
    
    % correct 3D connection:
    objects_seg = get_3D_results.connection_correct(objects_seg);
    
    % convert object file to 3D!

    % save results:
    objects = objects_seg;
    save(fullfile(job_settings_seg.path_job, 'objects_4_connected.mat'), 'objects', '-v7.3');
    
    % view connections:
    postprocessing.controller_view_connections_2D_slices(job_settings_seg, 'original', 'connections_2D_slices');
    postprocessing.controller_view_connections_3D_slices(job_settings_seg, 'original', 'connections_3D_slices');
%     postprocessing.controller_view_connections_3D_volumes(job_settings_seg, 'original', 'connections_3D_volumes');

    % plot seg and conn as slices:
    get_3D_results.plot_both_slices(objects_seg, objects_conn, 'coordinates_um', 'coordinates_um');

end