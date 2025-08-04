function mSequence = generateMSequenceCommon(length, initial_state)
% generateMSequenceCommon - Generate a maximal length sequence (m-sequence)
% using a 5-bit LFSR with feedback from taps at bit positions 1 and 5.
%
% Inputs:
%   length         - Desired length of the output m-sequence
%   initial_state  - Initial state of the LFSR (1x5 binary vector)
%
% Output:
%   mSequence      - Generated m-sequence (1 x length)

    % Initialize the LFSR with the given initial state
    lfsr = initial_state;

    % Pre-allocate output sequence
    mSequence = zeros(1, length);

    % Generate sequence
    for i = 1:length
        % Output the first bit of the current LFSR state
        mSequence(i) = lfsr(1);

        % Compute the feedback bit using XOR of bit 1 and bit 5
        % This corresponds to the feedback polynomial x^5 + x + 1
        next_bit = mod((lfsr(5) + lfsr(1)), 2);

        % Shift LFSR left by 1 and append the feedback bit
        lfsr = [lfsr(2:end), next_bit];
    end
end
