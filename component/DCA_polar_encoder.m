function e = DCA_polar_encoder(a, crc_polynomial_pattern, crc_interleaver_pattern, info_bit_pattern, rate_matching_pattern)
% DCA_POLAR_ENCODER Distributed-CRC-Aided (DCA) polar encoder.
%   e = CA_POLAR_ENCODER(a, crc_polynomial_pattern, crc_interleaver_pattern, info_bit_pattern, rate_matching_pattern) 
%   encodes the information bit sequence a, in order to obtain the encoded 
%   bit sequence e.
%
%   a should be a binary row vector comprising A number of bits, each 
%   having the value 0 or 1. 
%
%   crc_polynomial_pattern should be a binary row vector comprising P+1
%   number of bits, each having the value 0 or 1. These bits parameterise a
%   Cyclic Redundancy Check (CRC) comprising P bits. Each bit provides the
%   coefficient of the corresponding element in the CRC generator
%   polynomial. From left to right, the bits provide the coefficients for
%   the elements D^P, D^P-1, D^P-2, ..., D^2, D, 1.
%
%   crc_interleaver_pattern should be a row vector comprising K number of
%   integers, each having a unique value in the range 1 to K. Each integer
%   identifies which one of the K information or CRC bits provides the 
%   corresponding bit in the input to the polar encoder kernal.
%
%   info_bit_pattern should be a row vector comprising N number of logical 
%   elements, each having the value true or false. The number of elements 
%   in info_bit_pattern having the value true should be K, where K = A+P. 
%   These elements having the value true identify the positions of the 
%   information and CRC bits within the input to the polar encoder kernal.
%
%   rate_matching_pattern should be a row vector comprising E number of
%   integers, each having a value in the range 1 to N. Each integer
%   identifies which one of the N outputs from the polar encoder kernal
%   provides the corresponding bit in the encoded bit sequence e.
%
%   e will be a binary row vector comprising E number of bits, each having
%   the value 0 or 1.
%
%   See also DCA_POLAR_DECODER

A = length(a);
P = length(crc_polynomial_pattern)-1;
K = length(crc_interleaver_pattern);
N = length(info_bit_pattern);

if A+P ~= K
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

% Generate the CRC bits and append them to the information bits.
G_P = get_crc_generator_matrix(A,crc_polynomial_pattern);
b = [a, mod(a*G_P,2)];

% Interleave the information and CRC bits.
c = b(crc_interleaver_pattern);

% Position the information and CRC bits within the input to the polar 
% encoder kernal.
u = zeros(1,N);
u(info_bit_pattern) = c;

% Perform the polar encoder kernal operation.
G_N = get_G_N(N);
d = mod(u*G_N,2);

% Extract the encoded bits from the output of the polar encoder kernal.
e = d(rate_matching_pattern);

end