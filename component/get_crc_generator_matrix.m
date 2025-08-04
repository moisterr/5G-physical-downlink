function G_P = get_crc_generator_matrix(A, crc_polynomial_pattern)
% This function generates the CRC generator matrix G_P
% Inputs:
%   A - the number of bits in the input message
%   crc_polynomial_pattern - the generator polynomial coefficients (in binary form)
% Output:
%   G_P - the CRC generator matrix of size A x P, where P = degree of the polynomial

% Degree of the CRC polynomial
P = length(crc_polynomial_pattern) - 1;

% Check if the CRC polynomial is valid (must have at least degree 1)
if P < 1
    error('crc_polynomial_pattern is invalid');
end

% Initialize the generator matrix with zeros
G_P = zeros(A, P);

% Only proceed if A > 0
if A > 0
    % The last row of G_P is the CRC polynomial (excluding the leading 1)
    G_P(end, :) = crc_polynomial_pattern(2:end);
    
    % Backward recurrence to compute the rest of the generator matrix
    % Each row is calculated using the row below it and polynomial multiplication
    for k = A-1:-1:1
        % Perform binary XOR between shifted lower row and the polynomial
        G_P(k, :) = xor([G_P(k+1, 2:end), 0], ...
                        G_P(k+1, 1) * crc_polynomial_pattern(2:end));
    end
end
end
