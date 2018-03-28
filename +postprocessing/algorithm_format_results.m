function [results_formatted, index] = algorithm_format_results(tool, results_formatted, results_for_job, image_info, index)

    % if the results are points:
    if strcmp(tool, 'Crosshairs')
        
        % format the results:
        [results_formatted, index] = postprocessing.algorithm_format_results_point(results_formatted, results_for_job, image_info, index);
    
    % if the results are lines or shapes:
    else 
        
        % format the results:
        [results_formatted, index] = postprocessing.algorithm_format_results_line_shape(results_formatted, results_for_job, image_info, index);
        
    end
    
end