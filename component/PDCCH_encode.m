function f = PDCCH_encode(a, E, RNTI)
% PDCCH_encode performs Polar encoding for PDCCH (control channel) in 5G NR.
%
% Inputs:
%   a    - Input bit vector (DCI message), A <= 140 bits
%   E    - Desired output length in bits, E <= 8192
%   RNTI - 16-bit Radio Network Temporary Identifier (used for CRC masking)
%          Optional, defaults to all ones [1 1 ... 1] if not specified
%
% Output:
%   f    - Encoded polar codeword of length E

addpath component\  % Add path to the folder with dependent functions

% Handle optional RNTI input
if nargin == 2
    RNTI = ones(1, 16);  % Default RNTI
end

% RNTI must be 16 bits
if length(RNTI) ~= 16
    error("RNTI length should be 16");
end

A = length(a);  % Input message length

% Check for valid input size
if A == 0
    error("A should not be 0");
end 
if A > 140
    error("A should not be greater than 140");
end
if E > 8192
    error("E should not be greater than 8192");
end

% Use 3GPP-defined CRC24C polynomial
% Generator: x^24 + x^23 + x^21 + ... + 1
crc_polynomial_pattern = [1 1 0 1 1 0 0 1 0 1 0 1 1 0 0 0 1 0 0 0 1 0 1 1 1];
P = length(crc_polynomial_pattern) - 1;  % CRC length = 24

% Padding if A < 12 (for DCI formats < 12 bits)
if A < 12
    a = [a, zeros(1, 12 - length(a))];  % Zero-pad to 12 bits
    K = 12 + P;  % Total number of input bits after CRC
else
    K = A + P;
end

% Calculate polar code block length N (must be power of 2, N ≥ K)
% L = 9 for control channel
N = get_3GPP_N(K, E, 9);

% Interleaver pattern for CRC bits before polar encoding
crc_interleaver_pattern = get_3GPP_crc_interleaver_pattern(K);

% Generate rate-matching pattern and mode (repetition, puncturing, etc.)
[rate_matching_pattern, mode] = get_3GPP_rate_matching_pattern(K, N, E);

% Q_N: reliability sequence (bit-channel reliability ordering)
Q_N = get_3GPP_sequence_pattern(N);

% Determine positions of information bits in polar block of length N
info_bit_pattern = get_3GPP_info_bit_pattern(K, Q_N, rate_matching_pattern, mode);

% Perform complete polar encoding pipeline:
% - Append CRC
% - Mask CRC with RNTI
% - Interleave CRC
% - Place info bits in selected positions
% - Encode with polar code
% - Rate match to length E
f = DS1CA_polar_encoder(a, crc_polynomial_pattern, RNTI, ...
    crc_interleaver_pattern, info_bit_pattern, rate_matching_pattern);
end
