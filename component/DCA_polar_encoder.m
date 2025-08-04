function e = DCA_polar_encoder(a, crc_polynomial_pattern, crc_interleaver_pattern, info_bit_pattern, rate_matching_pattern)
% DCA_POLAR_ENCODER - Custom implementation of a Polar encoder for DCI or general use.
%
% Inputs:
%   a: Input message bits (1 x A)
%   crc_polynomial_pattern: CRC polynomial vector (e.g., [1 0 1 1] for x^3 + x + 1)
%   crc_interleaver_pattern: Permutation pattern for CRC interleaving (1 x K)
%   info_bit_pattern: Binary mask (1 x N) with 1s at information bit positions (K total)
%   rate_matching_pattern: Index vector to perform rate matching (1 x E)
%
% Output:
%   e: Encoded and rate-matched polar codeword (1 x E)

% A = message length
A = length(a);

% P = number of CRC bits (length of polynomial - 1)
P = length(crc_polynomial_pattern) - 1;

% K = length after CRC (i.e., message + CRC)
K = length(crc_interleaver_pattern);

% N = polar code block length (must be power of 2)
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

% ---------- Step 1: CRC encoding ----------
% Generate CRC generator matrix G_P
G_P = get_crc_generator_matrix(A, crc_polynomial_pattern);

% Append CRC bits to message: b = [message, CRC]
% CRC = a * G_P (mod 2)
b = [a, mod(a * G_P, 2)];

% ---------- Step 2: CRC interleaving ----------
% Rearrange bits according to crc_interleaver_pattern
c = b(crc_interleaver_pattern);

% ---------- Step 3: Insert into information bit positions ----------
% u is a length-N zero vector; fill only info bit locations with c
u = zeros(1, N);
u(info_bit_pattern) = c;

% ---------- Step 4: Polar encoding ----------
% Generate Polar generator matrix G_N
G_N = get_G_N(N);

% Encode: d = u * G_N (mod 2)
d = mod(u * G_N, 2);

% ---------- Step 5: Rate matching ----------
% Select bits using the given rate matching pattern
e = d(rate_matching_pattern);

end
