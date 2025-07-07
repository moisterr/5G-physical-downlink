function symbols = PBCH_modulate(bits)
% PBCH_MODULATE QPSK modulation for PBCH
%   symbols = PBCH_MODULATE(bits) performs QPSK modulation on the input bit sequence
%
%   bits should be a binary row vector of length 864
%   symbols will be a complex row vector of length 432

% Validate input
if length(bits) ~= 864
    error('Input must be 864 bits for PBCH');
end

% Reshape into groups of 2 bits
grouped_bits = reshape(bits, 2, [])';

% Map to QPSK symbols (3GPP TS 38.211 Section 7.3.1)
mapping = [1+1j; 1-1j; -1+1j; -1-1j] / sqrt(2); % Normalized constellation

% Convert binary to decimal indices
indices = bi2de(grouped_bits, 'left-msb') + 1;
symbols = mapping(indices).';
end