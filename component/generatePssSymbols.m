% 5G NR PSS Sequence Generation in MATLAB
% This script generates the 127 BPSK symbols for the 5G NR Primary Synchronization Signal (PSS)
% based on the 3GPP TS 38.211 standard.

function pssSymbols = generatePssSymbols(ncellid)
    % generatePssSymbols: Generates the 127 BPSK symbols for the 5G NR PSS.
    %
    %   Args:
    %       ncellid (int): The Physical Cell ID (0-1007).
    %
    %   Returns:% File: component/generatePssSymbols.m

function pssSymbols = generatePssSymbols(ncellid)
    % generatePssSymbols: Generates the 127 BPSK symbols for the 5G NR PSS.
    %   Args:
    %       ncellid (int): The Physical Cell ID (0-1007).
    %   Returns:
    %       pssSymbols (double array): A 127x1 column vector of PSS symbols (-1 or 1).

    % Determine u from NID(2)
    % NID(2) = ncellid mod 3
    u = mod(ncellid, 3);

    % PSS m-sequence initial state is fixed: [1 1 1 0 1 1 0] (x[6]...x[0])
    % Convert to x[0]...x[6] for generateMSequenceCommon
    pss_m_seq_initial_state = [0, 1, 1, 0, 1, 1, 1];
    
    % Call the common m-sequence generator
    x_sequence = generateMSequenceCommon(127, pss_m_seq_initial_state);
    
    pssSymbols = zeros(127, 1);
    for n = 0:126
        index_in_x = mod((n + 43 * u), 127) + 1; % +1 for 1-based indexing
        pssSymbols(n + 1) = 1 - 2 * x_sequence(index_in_x);
    end
end
    %       pssSymbols (double array): A 127x1 column vector of PSS symbols (-1 or 1).

    % Determine u from NID(2)
    % NID(2) = ncellid mod 3
    u = mod(ncellid, 3);

    % Generate the m-sequence of length 127
    x_sequence = generateMSequence(127);

    % Initialize PSS symbols array
    pssSymbols = zeros(127, 1);

    % Generate PSS symbols d_PSS(n)
    % d_PSS(n) = 1 - 2 * x[(n + 43u) mod 127]
    % Note: MATLAB uses 1-based indexing, so n from 0 to 126 in formula
    % corresponds to index n+1 in MATLAB array.
    for n = 0:126
        index_in_x = mod((n + 43 * u), 127) + 1; % +1 for 1-based indexing
        pssSymbols(n + 1) = 1 - 2 * x_sequence(index_in_x);
    end
end

function mSequence = generateMSequence(length)
    % generateMSequence: Generates an m-sequence of a given length based on
    % the 3GPP TS 38.211 definition for PSS.

    % LFSR initial state [x(6) x(5) x(4) x(3) x(2) x(1) x(0)]
    % In MATLAB, we'll represent this from x(0) to x(6)
    % [1 1 1 0 1 1 0] corresponds to x[6]...x[0]
    lfsr = [0, 1, 1, 0, 1, 1, 1]; % x[0] to x[6]
    mSequence = zeros(1, length);

    for i = 1:length
        % The current output is x[0] (the first element in the current LFSR state)
        mSequence(i) = lfsr(1); % MATLAB uses 1-based indexing

        % Calculate the next bit: x(i+7) = (x(i+4) + x(i)) mod 2
        % For the current state, this means (x[4] + x[0]) mod 2
        % In MATLAB, this is lfsr(5) + lfsr(1)
        next_bit = mod((lfsr(5) + lfsr(1)), 2);

        % Shift the LFSR: x[i] becomes x[i+1], and next_bit becomes x[6]
        lfsr = [lfsr(2:end), next_bit];
    end
end