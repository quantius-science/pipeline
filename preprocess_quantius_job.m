function preprocess_quantius_job
    
    % set job number: 
    job_settings.job_number = inputdlg('What is the job number?');
    job_settings.job_number = str2double(job_settings.job_number{1});
    
    % get the name of the job folder:
    job_folder_name = ['Job' num2str(job_settings.job_number, '%03d')];
    
    % make the jobs folder (done in the working directory):
    mkdir(job_folder_name);
    
    % move to the job folder:
    cd(job_folder_name);
    
    % get job folder path:
    job_settings.path_job = pwd;
    
    % set channel:
    job_settings.channel = inputdlg('What is the channel name?');
    job_settings.channel = job_settings.channel{1};
    
    % select folders with raw data:
    job_settings = preprocessing.controller_get_folders_raw_data(job_settings);

    % get and rename results:
    job_settings = preprocessing.controller_collect_and_rename_data(job_settings);

    % crop stacks:
    job_settings = preprocessing.controller_crop_stacks(job_settings, 'original', 'cropped');
    
    % adjust contrast:
    job_settings = preprocessing.controller_adjust_contrast(job_settings, 'cropped', 'adjusted');

    % tile stacks:
    job_settings = preprocessing.controller_tile_stacks(job_settings, 'adjusted', 'tiled');
    
    % convert z-stack to slices:
    job_settings = preprocessing.controller_stack_to_slices(job_settings, 'tiled', 'slices_tiled');
    
    % save as png:
    job_settings = preprocessing.controller_convert_to_png(job_settings, 'slices_tiled', 'submitted');

    % save job settings:
    save(fullfile(job_settings.path_job, 'job_settings.mat'), 'job_settings');

end