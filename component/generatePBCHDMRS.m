function sym = generatePBCHDMRS(ncellid, ibar_SSB)
%nrPBCHDMRS PBCH demodulation reference signal (simplified version)
%   SYM = nrPBCHDMRS(NCELLID,IBAR_SSB) returns complex PBCH DM-RS symbols
%   as per 3GPP TS 38.211 Section 7.4.1.4.1. Assumes default output type.

    % Validate inputs
    validateattributes(ncellid, {'numeric'}, ...
        {'scalar','integer','>=',0,'<=',1007}, 'nrPBCHDMRS', 'NCELLID');
    validateattributes(ibar_SSB, {'numeric'}, ...
        {'scalar','integer','>=',0,'<=',7}, 'nrPBCHDMRS', 'IBAR_SSB');

    % Initialize scrambling (TS 38.211 7.4.1.4.1)
    cinit = 2^11 * (ibar_SSB + 1) * (floor(ncellid / 4) + 1) + ...
            2^6  * (ibar_SSB + 1) + mod(ncellid, 4);

    % Generate PRBS of length 288 (2 bits per symbol × 144 symbols)
    prbs = double(nrPRBS(cinit, 2 * 144));

    % QPSK modulation (no varargin)
    sym = nrModuMapper(prbs, 'qpsk');
end
