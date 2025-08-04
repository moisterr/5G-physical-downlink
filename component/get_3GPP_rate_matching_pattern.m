function [rate_matching_pattern, mode] = get_3GPP_rate_matching_pattern(K, N, E)
% Calculates the rate matching pattern and mode for 5G NR Polar encoding
% Inputs:
%   K - Number of information + CRC bits (after CRC appending and interleaving)
%   N - Mother code block length (must be a power of 2)
%   E - Number of output bits after rate matching (transmitted bits)
% Outputs:
%   rate_matching_pattern - Index pattern for selecting E bits from N-bit encoded block
%   mode - One of: 'repetition', 'puncturing', or 'shortening'

n = log2(N);  % Polar code block length must be 2^n
if n ~= round(n)
    error('N should be a power of 2');
end
if n < 5
    error('N should be at least 32 (minimum size in 3GPP)');
end

% P is the bit-reversed permutation pattern used to interleave the N bits
P = [0 1 2 4 3 5 6 7 8 16 9 17 10 18 11 19 12 20 13 21 14 22 15 23 ...
     24 25 26 28 27 29 30 31];

d = 1:N;          % Sequential bit indices from 1 to N
J = zeros(1,N);   % Interleaved bit positions
y = zeros(1,N);   % Final permuted indices

% Generate circular buffer permutation y[n] based on P pattern
for n=0:N-1
    i = floor(32 * n / N);                     % Select index from P
    J(n+1) = P(i+1) * (N / 32) + mod(n, N/32); % Compute permuted index
    y(n+1) = d(J(n+1)+1);                      % Store permuted value
end

% Allocate pattern output
rate_matching_pattern = zeros(1, E);

% ---- RATE MATCHING MODES ----
if E >= N
    % Case 1: Repetition (transmit more bits than we have)
    % Circularly repeat the pattern if E > N
    for k = 0:E-1
        rate_matching_pattern(k+1) = y(mod(k, N) + 1);
    end
    mode = 'repetition';
else
    if K/E <= 7/16
        % Case 2: Puncturing (skip beginning bits from end of pattern)
        for k = 0:E-1
            rate_matching_pattern(k+1) = y(k + N - E + 1);
        end
        mode = 'puncturing';
    else
        % Case 3: Shortening (use the beginning part of y)
        for k = 0:E-1
            rate_matching_pattern(k+1) = y(k+1);
        end
        mode = 'shortening';
    end
end
