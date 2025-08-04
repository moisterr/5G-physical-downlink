function symbOut = nrModuMapper(bitsIn, moduType)
% This function maps input bits to complex modulation symbols
% Inputs:
%   bitsIn   - Input binary vector (0s and 1s)
%   moduType - Modulation type: 'bpsk', 'qpsk', '16qam', '64qam', '256qam'
% Output:
%   symbOut  - Output complex symbols after modulation

b = bitsIn;

switch lower(moduType)
    case 'bpsk'
        % BPSK: 1 bit per symbol
        symbOut = zeros(size(b));
        for i = 0:length(bitsIn)-1
            % Map bit 0 -> +1, bit 1 -> -1 (with a scaling and phase rotation)
            symbOut(i+1) = 0.5 * sqrt(2) * ((1 - 2 * b(i+1)) + 1j * (1 - 2 * b(i+1)));
        end

    case 'qpsk'
        % QPSK: 2 bits per symbol
        nOfBitsIn = length(bitsIn);
        assert(mod(nOfBitsIn, 2) == 0);  % Check for valid length
        symbOut = zeros(nOfBitsIn / 2, 1);
        for i = 0:nOfBitsIn/2 - 1
            % Map two bits to one QPSK symbol (Gray-coded)
            symbOut(i+1) = 1/sqrt(2) * ((1 - 2 * b(2*i+1)) + 1j * (1 - 2 * b(2*i+2)));
        end

    case '16qam'
        % 16QAM: 4 bits per symbol
        nOfBitsIn = length(bitsIn);
        assert(mod(nOfBitsIn, 4) == 0);
        symbOut = zeros(nOfBitsIn / 4, 1);
        for i = 0:nOfBitsIn/4 - 1
            % Gray-mapped 16-QAM symbol generation
            re = (1 - 2 * b(4*i+1)) * (2 - (1 - 2 * b(4*i+3)));
            im = (1 - 2 * b(4*i+2)) * (2 - (1 - 2 * b(4*i+4)));
            symbOut(i+1) = re + 1j * im;
        end
        symbOut = symbOut / sqrt(10);  % Normalize average power

    case '64qam'
        % 64QAM: 6 bits per symbol
        nOfBitsIn = length(bitsIn);
        assert(mod(nOfBitsIn, 6) == 0);
        symbOut = zeros(nOfBitsIn / 6, 1);
        for i = 0:nOfBitsIn/6 - 1
            % Gray-mapped 64-QAM symbol generation
            re = (1 - 2 * b(6*i+1)) * (4 - (1 - 2 * b(6*i+3)) * (2 - (1 - 2 * b(6*i+5))));
            im = (1 - 2 * b(6*i+2)) * (4 - (1 - 2 * b(6*i+4)) * (2 - (1 - 2 * b(6*i+6))));
            symbOut(i+1) = re + 1j * im;
        end
        symbOut = symbOut / sqrt(42);  % Normalize average power

    case '256qam'
        % 256QAM: 8 bits per symbol
        nOfBitsIn = length(bitsIn);
        assert(mod(nOfBitsIn, 8) == 0);
        symbOut = zeros(nOfBitsIn / 8, 1);
        for i = 0:nOfBitsIn/8 - 1
            % Gray-mapped 256-QAM symbol generation
            re = (1 - 2 * b(8*i+1)) * (8 - (1 - 2 * b(8*i+3)) * ...
                  (4 - (1 - 2 * b(8*i+5)) * (2 - (1 - 2 * b(8*i+7)))));
            im = (1 - 2 * b(8*i+2)) * (8 - (1 - 2 * b(8*i+4)) * ...
                  (4 - (1 - 2 * b(8*i+6)) * (2 - (1 - 2 * b(8*i+8)))));
            symbOut(i+1) = re + 1j * im;
        end
        symbOut = symbOut / sqrt(170);  % Normalize average power
end
end
