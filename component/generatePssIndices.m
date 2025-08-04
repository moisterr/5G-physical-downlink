function ind = generatePssIndices()
%nrPSSIndices PSS resource element indices (simplified)
%   IND = nrPSSIndices() returns a column vector of resource element (RE)
%   indices for the primary synchronization signal (PSS) as defined in TS
%   38.211 Section 7.4.3.1. The indices are returned in 1-based linear
%   indexing form for a 240-by-4 grid.

    gridsize = [240 4];     % Dimensions of the SS/PBCH block
    k = (56:182).';         % Subcarrier indices used by the PSS (127 total)
    l = 0;                  % Symbol index (PSS is in symbol 0)

    ind = k + (l * gridsize(1));  % Convert to linear index (column-major)
    ind = uint32(ind + 1);        % Convert from 0-based to MATLAB's 1-based indexing
end
