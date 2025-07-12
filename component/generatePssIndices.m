function pssIndices = generatePssIndices(ssblock_size)
    % generatePssIndices: Generates linear indices for PSS mapping within the SS/PBCH block.
    %   Args:
    %       ssblock_size (array): Size of the SS/PBCH block matrix, e.g., [240, 4].
    %   Returns:
    %       pssIndices (double array): A 127x1 column vector of linear indices.

    num_subcarriers_ssb = ssblock_size(1); % 240
    num_ofdm_symbols_ssb = ssblock_size(2); % 4

    pss_length = 127; % PSS occupies 127 subcarriers

    % PSS is centered in the 240 subcarriers.
    % Subcarrier indices for PSS (0-based) are from 56 to 182.
    % In MATLAB (1-based), this is from 57 to 183.
    pss_subcarrier_start_0based = 56; % 56.5, so 56
    pss_subcarrier_indices_0based = pss_subcarrier_start_0based : (pss_subcarrier_start_0based + pss_length - 1);

    % Convert to 1-based indexing for MATLAB
    row_indices = pss_subcarrier_indices_0based + 1; % Subcarrier indices for PSS (1-based)

    % PSS is always in the first OFDM symbol (column 1)
    col_indices = ones(pss_length, 1); % All 127 symbols are in the first column

    % Use sub2ind to convert (row, column) pairs to linear indices
    % sub2ind(size_of_matrix, row_subscripts, col_subscripts)
    pssIndices = sub2ind(ssblock_size, row_indices', col_indices); % Transpose row_indices to match col_indices shape
end