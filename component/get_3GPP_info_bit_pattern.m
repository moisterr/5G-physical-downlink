function info_bit_pattern = get_3GPP_info_bit_pattern(I, Q_N, rate_matching_pattern, mode)
    % Inputs:
    %   I: number of information bits
    %   Q_N: reliability sequence (indices of bit-channels in order of reliability)
    %   rate_matching_pattern: the pattern of bits to keep after rate matching
    %   mode: rate matching mode, can be 'puncturing', 'shortening', or 'repetition'
    % Output:
    %   info_bit_pattern: logical array of length N, where 1s represent positions of info bits

    N = length(Q_N);               % Code length (must be power of 2)
    n = log2(N);                   
    E = length(rate_matching_pattern); % Number of bits after rate matching

    % Error checks
    if n ~= round(n)
        error('N should be a power of 2');
    end
    if I > N
        error('polar_3gpp_matlab:UnsupportedBlockLength','I should be no greater than N.');
    end
    if I > E
        error('polar_3gpp_matlab:UnsupportedBlockLength','I should be no greater than E.');
    end
    if max(rate_matching_pattern) > N
        error('rate_matching_pattern is not compatible with N');
    end

    % Check if the mode is valid and compatible with E
    if strcmp(mode,'repetition') 
        if E < N
            error('mode is not compatible with E');
        end
    elseif strcmp(mode,'puncturing')
        if E >= N
            error('mode is not compatible with E');
        end
    elseif strcmp(mode,'shortening')
        if E >= N
            error('mode is not compatible with E');
        end
    else
        error('Unsupported mode');
    end

    % Step 1: Identify frozen bit indices
    % Bits that are not selected during rate matching (to be frozen)
    Q_Ftmp_N = setdiff(1:N, rate_matching_pattern) - 1; % Convert to 0-based indexing

    % Step 2: Add extra frozen bits if using puncturing
    if strcmp(mode,'puncturing')
        if E >= 3*N/4
            Q_Ftmp_N = [Q_Ftmp_N, 0:ceil(3*N/4 - E/2)-1];
        else
            Q_Ftmp_N = [Q_Ftmp_N, 0:ceil(9*N/16 - E/4)-1];
        end
    end

    % Step 3: Compute set of information bit indices (not frozen)
    Q_Itmp_N = setdiff(Q_N - 1, Q_Ftmp_N, 'stable');  % Remove frozen bits from reliability seq

    % Check if there are enough unfrozen bits left
    if length(Q_Itmp_N) < I
        error('polar_3gpp_matlab:UnsupportedBlockLength','Too many pre-frozen bits.');
    end    

    % Select the least reliable I indices from the remaining set
    Q_I_N = Q_Itmp_N(end-I+1:end);

    % Step 4: Create info_bit_pattern (1 where info bits are placed)
    info_bit_pattern = false(1,N);
    info_bit_pattern(Q_I_N + 1) = true;   % Convert back to 1-based indexing for MATLAB
end
