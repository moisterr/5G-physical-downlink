function G_N = get_G_N(N)
% This function generates the generator matrix G_N for Polar coding
% Input:
%   N - block length of the Polar code (must be a power of 2)
% Output:
%   G_N - N x N generator matrix constructed using the Kronecker product

% Calculate the number of Kronecker stages (log2 of N)
n = log2(N);

% Ensure N is a power of 2
if n ~= round(n)
    error('N should be a power of 2');
end

% Initialize generator matrix as scalar 1 (G_1)
G_N = 1;

% Construct G_N recursively using n Kronecker products of the base matrix [1 0; 1 1]
for i = 1:n
    G_N = kron(G_N, [1 0; 1 1]);
end
end
