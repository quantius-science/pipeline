function controller_remove_edge_results(job_settings)
   
    % get formatted results:
    results = load(fullfile(job_settings.path_job, 'results_2_formatted.mat'), 'results_formatted');
    results = results.results_formatted;
    
    % if the results are shapes (not points or lines):
    if (strcmp(job_settings.tool, 'Polygon') || strcmp(job_settings.tool, 'Freehand'))
        
        % remove objects touching the border of the image:
        results = postprocessing.algorithm_remove_edge_results(results);
        
    end
    
    % save results:
    save(fullfile(job_settings.path_job, 'results_3_formatted_cleaned.mat'), 'results');
    
end