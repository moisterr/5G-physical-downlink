% File: component/generateSssIndices.m

function sssIndices = generateSssIndices(ssblock_size)
    % generateSssIndices: Generates linear indices for SSS mapping within the SS/PBCH block.
    %   Args:
    %       ssblock_size (array): Size of the SS/PBCH block matrix, e.g., [240, 4].
    %   Returns:
    %       sssIndices (double array): A 127x1 column vector of linear indices.

    num_subcarriers_ssb = ssblock_size(1); % 240
    sss_length = 127; % SSS occupies 127 subcarriers

    % SSS is centered in the 240 subcarriers, same as PSS.
    % According to 3GPP TS 38.211, SSS occupies subcarriers from 56 to 182 (0-based).
    % In MATLAB (1-based), this corresponds to subcarriers 57 to 183.
    sss_subcarrier_start_0based = 56; % Same subcarrier range as PSS

    sss_subcarrier_indices_0based = sss_subcarrier_start_0based : (sss_subcarrier_start_0based + sss_length - 1);
    
    % Convert to 1-based indexing for MATLAB
    row_indices = sss_subcarrier_indices_0based + 1; % Subcarrier indices for SSS (1-based)

    % SSS is always in the second OFDM symbol (column 2)
    col_indices = 3 * ones(sss_length, 1); % All 127 symbols are in the second column

    % Use sub2ind to convert (row, column) pairs to linear indices
    % sub2ind(size_of_matrix, row_subscripts, col_subscripts)
    sssIndices = sub2ind(ssblock_size, row_indices', col_indices); % Transpose row_indices to match col_indices shape
end