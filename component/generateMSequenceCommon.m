% File: component/generateMSequenceCommon.m

function mSequence = generateMSequenceCommon(length, initial_state)
    % generateMSequenceCommon: Generates an m-sequence of a given length
    % based on the 3GPP TS 38.211 definition, with a configurable initial state.
    % This is a common helper for PSS and SSS symbol generation.
    %
    %   Args:
    %       length (int): Desired length of the m-sequence.
    %       initial_state (array): 7-element array representing the initial LFSR state [x(0) x(1) ... x(6)].
    %
    %   Returns:
    %       mSequence (double array): A 1xLength row vector of m-sequence values (0 or 1).

    lfsr = initial_state; % LFSR initial state [x(0) x(1) ... x(6)]
    mSequence = zeros(1, length);

    for i = 1:length
        mSequence(i) = lfsr(1); % Current output is x[0] (first element)

        % Calculate the next bit based on the specific LFSR taps for PSS/SSS
        % For PSS and SSS x0/x1: x(i+7) = (x(i+4) + x(i)) mod 2
        % In MATLAB 1-based indexing: (lfsr(5) + lfsr(1)) mod 2
        next_bit = mod((lfsr(5) + lfsr(1)), 2);

        % Shift the LFSR: x[i] becomes x[i+1], and next_bit becomes x[6]
        lfsr = [lfsr(2:end), next_bit];
    end
end