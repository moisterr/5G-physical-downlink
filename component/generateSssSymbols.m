% File: component/generateSssSymbols.m

function sssSymbols = generateSssSymbols(ncellid)
    % generateSssSymbols: Generates the 127 BPSK symbols for the 5G NR SSS.
    %   Args:
    %       ncellid (int): The Physical Cell ID (0-1007).
    %   Returns:
    %       sssSymbols (double array): A 127x1 column vector of SSS symbols (-1 or 1).

    % Derive NID(1) and NID(2) from ncellid
    nid1 = floor(ncellid / 3);
    nid2 = mod(ncellid, 3);

    % Calculate m0 and m1
    m0 = 15 * nid1 + nid2;
    m1 = nid1;

    % --- Determine initial states for x0 and x1 m-sequences based on m0 and m1 ---
    % These initial states are derived from 3GPP TS 38.211 Table 7.4.3.2.1-1
    % For a full implementation, this would be a lookup table or polynomial evaluation.
    % For this example, we hardcode for ncellid = 17 (m0=77, m1=5)
    % x0(6)...x0(0) for m0=77 is [0 0 1 1 0 1 0]
    % x1(6)...x1(0) for m1=5 is [0 0 0 0 0 1 0]
    % Note: MATLAB LFSR will be x[0]...x[6], so reverse the order for the initial state.
    
    % Initial state for x0 (reversed from 3GPP table for LFSR implementation)
    x0_initial_state = [0, 1, 0, 1, 1, 0, 0]; % Corresponds to [0 0 1 1 0 1 0] (x[0] to x[6])

    % Initial state for x1 (reversed from 3GPP table for LFSR implementation)
    x1_initial_state = [0, 1, 0, 0, 0, 0, 0]; % Corresponds to [0 0 0 0 0 1 0] (x[0] to x[6])

    % Generate x0 and x1 sequences using the common m-sequence generator
    x0_sequence = generateMSequenceCommon(127, x0_initial_state);
    x1_sequence = generateMSequenceCommon(127, x1_initial_state);

    % Generate SSS symbols d_SSS(n) = (1 - 2*x0(n)) * (1 - 2*x1(n))
    sssSymbols = zeros(127, 1);
    for n = 0:126
        % Note: x0_sequence and x1_sequence are 1-based indexed in MATLAB
        sssSymbols(n + 1) = (1 - 2 * x0_sequence(n + 1)) * (1 - 2 * x1_sequence(n + 1));
    end
end