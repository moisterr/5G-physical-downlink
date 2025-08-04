function f = PBCH_encode(a, E)
% PBCH_encode performs Polar encoding for 5G NR PBCH channel as per 3GPP 38.212.
% Inputs:
%   a - 32-bit input message vector (usually MIB bits)
%   E - (Optional) encoded output length, default is 864 bits
% Output:
%   f - Polar-encoded output vector of length E

addpath component\  % Add path to directory containing dependent functions

A = length(a);  % Input message length

if A ~= 32
    error('polar_3gpp_matlab:UnsupportedBlockLength','A should be 32.');
end

if nargin < 2
    E = 864;  % Default output length if not specified
end

if E ~= 864
    error('polar_3gpp_matlab:UnsupportedBlockLength','E should be 864.');
end

% 3GPP CRC24C polynomial: generator = x^24 + x^23 + x^21 + ... + 1
crc_polynomial_pattern = [1 1 0 1 1 0 0 1 0 1 0 1 1 0 0 0 1 0 0 0 1 0 1 1 1];
P = length(crc_polynomial_pattern) - 1;  % CRC length = 24
K = A + P;  % Total info bits after CRC = 56

% Determine N: block length of polar code (must be power of 2 ≥ K)
% L = 9 for PBCH according to 3GPP
N = get_3GPP_N(K, E, 9);  

% Interleaver pattern applied on CRC bits before appending
crc_interleaver_pattern = get_3GPP_crc_interleaver_pattern(K);

% Get rate matching pattern and mode (e.g., repetition/puncturing/shortening)
[rate_matching_pattern, mode] = get_3GPP_rate_matching_pattern(K, N, E);

% Q_N is the bit-channel reliability order (descending)
Q_N = get_3GPP_sequence_pattern(N);

% Determine positions of information bits (including CRC) in length-N vector
info_bit_pattern = get_3GPP_info_bit_pattern(K, Q_N, rate_matching_pattern, mode);

% Perform full Polar encoding pipeline:
% - Append CRC
% - Interleave CRC
% - Place info bits in specified positions
% - Polar encode
% - Rate match to length E
f = DCA_polar_encoder(a, crc_polynomial_pattern, crc_interleaver_pattern, info_bit_pattern, rate_matching_pattern);
end
