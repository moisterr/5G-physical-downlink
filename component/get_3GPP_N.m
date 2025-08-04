function N = get_3GPP_N(K,E,n_max)
% get_3GPP_N: Determines the polar codeword length N = 2^n
% according to 3GPP TS 38.212 for polar encoding in 5G NR.
%
% Inputs:
%   K      - Number of information bits (includes CRC bits)
%   E      - Number of bits after rate matching (transmitted bits)
%   n_max  - Maximum allowed exponent n (i.e., N <= 2^n_max)
%
% Output:
%   N      - Polar mother code length (must be power of 2)

% Step 1: Compute n_1, the initial candidate for exponent n.
% If E is not too large and the code rate K/E is small (< 9/16),
% use a smaller block size to avoid wasting bits.
if E <= (9/8)*2^(ceil(log2(E))-1) && K/E < 9/16
    n_1 = ceil(log2(E)) - 1;
else
    % Otherwise, use the usual ceiling of log2(E)
    n_1 = ceil(log2(E));
end

% Step 2: Compute n_2, ensuring the minimum code rate constraint
R_min = 1/8;                   % Minimum allowed code rate by 3GPP
n_min = 5;                     % Minimum exponent (N = 32)
n_2 = ceil(log2(K / R_min));  % Minimum N such that K/N >= R_min

% Step 3: Final selection of n
% Choose n such that: n_min <= n <= n_max
% Also n must satisfy constraints from n_1 and n_2
n = max(n_min, min([n_1, n_2, n_max]));

% Step 4: Compute final codeword length
N = 2^n; % Polar codeword length must be a power of 2
end
