function e = DS1CA_polar_encoder(a, crc_polynomial_pattern, crc_scrambling_pattern, crc_interleaver_pattern, info_bit_pattern, rate_matching_pattern)
% DS1CA_POLAR_ENCODER - Custom Polar encoder with CRC scrambling for DS1-CA format
%
% Inputs:
%   a: Input information bits (1 x A)
%   crc_polynomial_pattern: Generator polynomial for CRC (1 x (P+1))
%   crc_scrambling_pattern: Scrambling bits to be XOR-ed with CRC (1 x P_s)
%   crc_interleaver_pattern: Pattern to permute bits before Polar encoding (1 x K)
%   info_bit_pattern: Binary vector of size 1 x N with K ones (defines info bit positions)
%   rate_matching_pattern: Index vector to perform rate matching to output E bits
%
% Output:
%   e: Encoded, CRC-scrambled, rate-matched polar codeword (1 x E)

% A = length of input message
A = length(a);

% P = number of CRC bits (degree of CRC polynomial)
P = length(crc_polynomial_pattern) - 1;

% K = total number of bits after CRC interleaving (should equal A + P)
K = length(crc_interleaver_pattern);

% N = polar block length (must be power of 2)
N = length(info_bit_pattern);

% ---------- Input validation ----------
if A + P ~= K
    error('A+P should equal K');
end

if log2(N) ~= round(log2(N))
    error('N should be a power of 2');
end

if sum(info_bit_pattern) ~= K
    error('info_bit_pattern should contain K number of ones.');
end

if max(rate_matching_pattern) > N
    error('rate_matching_pattern is not compatible with N');
end

if P < length(crc_scrambling_pattern)
    error('K should be no less than the length of the scrambling pattern');
end

% ---------- Step 1: CRC encoding ----------
% Generate CRC generator matrix for full (A+P) input
G_P = get_crc_generator_matrix(A + P, crc_polynomial_pattern);

% Compute CRC over 'a', using extra leading ones as in 3GPP spec
% Concatenate ones(1,P) and input bits, then apply G_P
crc_bits = mod([ones(1, P), a] * G_P, 2);

% ---------- Step 2: CRC scrambling ----------
% XOR the CRC bits with a scrambling pattern to protect against blind decoding
% Zero-pad the scrambling pattern if shorter than P
scrambled_crc_bits = xor(crc_bits, [zeros(1, P - length(crc_scrambling_pattern)), crc_scrambling_pattern]);

% Append scrambled CRC bits to the message
b = [a, scrambled_crc_bits];

% ---------- Step 3: CRC interleaving ----------
% Permute the bits before Polar encoding
c = b(crc_interleaver_pattern);

% ---------- Step 4: Bit insertion for Polar encoding ----------
% Create zero vector u of length N and place c into info bit positions
u = zeros(1, N);
u(info_bit_pattern) = c;

% ---------- Step 5: Polar encoding ----------
% Apply the generator matrix for Polar encoding
G_N = get_G_N(N);
d = mod(u * G_N, 2);

% ---------- Step 6: Rate matching ----------
% Output the final rate-matched polar codeword
e = d(rate_matching_pattern);

end
