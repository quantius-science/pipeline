function coords_orig = convert_coords_ortho_to_orig_algorithm(object, info)

    % get coordinates:
    coords_ortho = object.coordinates;

    % uncrop the coords in z:
    coords_ortho(:,3) = coords_ortho(:,3) + (info.slice_start_ortho - 1);

    % if the plane was xz:
    if strcmp(info.orthogonal_slice, 'xz')

        % unstretch the coords:
        coords_ortho(:,2) = floor((coords_ortho(:,2) - 1)/info.stretch_factor) + 1;

    elseif strcmp(info.orthogonal_slice, 'yz')

        % unstretch the coords:
        error('No code for yz slices yet!');

    end

    % if the plane was xz:
    if strcmp(info.orthogonal_slice, 'xz')

        % put coords back into original coordinate system:
        coords_orig = [coords_ortho(:,1), coords_ortho(:,3), (info.slice_end-info.slice_start+2) - coords_ortho(:,2)];

    elseif strcmp(info.orthogonal_slice, 'yz')

        % put coords back into original coordinate system:
        error('No code for yz slices yet!');

    end

end