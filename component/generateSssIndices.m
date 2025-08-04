function ind = generateSssIndices()
%nrSSSIndices SSS resource element indices (simplified)
%   IND = nrSSSIndices() returns a column vector of 1-based linear indices
%   for the secondary synchronization signal (SSS) as defined in TS 38.211
%   Section 7.4.3.1. The indices correspond to resource elements within a
%   240-by-4 SS/PBCH block.

    % SS/PBCH block grid size
    gridsize = [240 4];

    % Frequency (subcarrier) indices 56 to 182 -> total 127 REs
    k = (56:182).';

    % SSS is mapped to OFDM symbol index l = 2
    l = 2;

    % Compute linear indices
    ind = k + l * gridsize(1);  % 0-based indexing

    % Convert to 1-based indexing (MATLAB)
    ind = uint32(ind + 1);
end
