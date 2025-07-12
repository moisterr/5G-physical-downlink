function f = PDCCH_encode(a, E, RNTI);

addpath component\

if nargin == 2
    RNTI = ones(1, 16);
end

if length(RNTI) ~= 16
    error("RNTI length should be 16");
end

A = length(a);

if A == 0
    error("A should not be 0");
end 

if A > 140
    error("A should not be gt 140");
end

if E > 8192
    error("E should not be gt 8192");
end

crc_polynomial_pattern = [1 1 0 1 1 0 0 1 0 1 0 1 1 0 0 0 1 0 0 0 1 0 1 1 1];
P = length(crc_polynomial_pattern)-1;

if A < 12
    a = [a,zeros(1,12-length(a))];
    K = 12+P;
else
    K = A+P;
end

N = get_3GPP_N(K,E,9);

crc_interleaver_pattern = get_3GPP_crc_interleaver_pattern(K);
[rate_matching_pattern, mode] = get_3GPP_rate_matching_pattern(K,N,E);
Q_N = get_3GPP_sequence_pattern(N);
info_bit_pattern = get_3GPP_info_bit_pattern(K, Q_N, rate_matching_pattern, mode);


f = DS1CA_polar_encoder(a,crc_polynomial_pattern, RNTI, crc_interleaver_pattern,info_bit_pattern,rate_matching_pattern);